import SwiftUI

struct TipCalculator: View {
    @State private var billAmount = ""
    @State private var tipPercentage = 15.0
    @State private var numberOfPeople = 1

    var tipAmount: Double {
        let bill = Double(billAmount) ?? 0
        return bill * (tipPercentage / 100)
    }

    var totalAmount: Double {
        let bill = Double(billAmount) ?? 0
        return bill + tipAmount
    }

    var amountPerPerson: Double {
        totalAmount / Double(numberOfPeople)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: .Spacing.large) {
                // Bill Amount Input
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator2)
                            Text("Bill Amount")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        HStack(spacing: .Spacing.small) {
                            Text("$")
                                .font(.Theme.displaySmall)
                                .foregroundColor(.Theme.textSecondary)

                            TextField("0.00", text: $billAmount)
                                .keyboardTypeCompat(.decimalPad)
                                .font(.Theme.displaySmall)
                                .fontWeight(.bold)
                        }
                        .padding(.Spacing.medium)
                        .background(Color.Theme.secondaryBackground)
                        .cornerRadius(.CornerRadius.medium)
                    }
                }

                // Tip Percentage Section
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "percent")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator2)
                            Text("Tip Percentage")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(Int(tipPercentage))%")
                                .font(.Theme.headlineSmall)
                                .fontWeight(.bold)
                                .foregroundColor(.Theme.calculator2)
                        }

                        Slider(value: $tipPercentage, in: 0...30, step: 1)
                            .accentColor(.Theme.calculator2)

                        HStack {
                            Text("0%")
                                .font(.Theme.caption)
                                .foregroundColor(.Theme.textTertiary)
                            Spacer()
                            Text("30%")
                                .font(.Theme.caption)
                                .foregroundColor(.Theme.textTertiary)
                        }

                        // Quick Tip Buttons
                        VStack(alignment: .leading, spacing: .Spacing.small) {
                            Text("Quick Select")
                                .font(.Theme.labelMedium)
                                .foregroundColor(.Theme.textSecondary)

                            HStack(spacing: .Spacing.small) {
                                ForEach([10, 15, 18, 20], id: \.self) { percent in
                                    QuickActionButton(
                                        title: "\(percent)%",
                                        isSelected: tipPercentage == Double(percent)
                                    ) {
                                        withAnimation(.theme) {
                                            tipPercentage = Double(percent)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, .Spacing.small)
                    }
                }

                // Number of People
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator2)
                            Text("Split Between")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        HStack {
                            Button(action: {
                                if numberOfPeople > 1 {
                                    numberOfPeople -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(numberOfPeople > 1 ? .Theme.calculator2 : .Theme.textTertiary.opacity(0.3))
                            }
                            .disabled(numberOfPeople <= 1)

                            Spacer()

                            VStack(spacing: .Spacing.xxsmall) {
                                Text("\(numberOfPeople)")
                                    .font(.Theme.displaySmall)
                                    .fontWeight(.bold)
                                Text(numberOfPeople == 1 ? "person" : "people")
                                    .font(.Theme.bodySmall)
                                    .foregroundColor(.Theme.textSecondary)
                            }

                            Spacer()

                            Button(action: {
                                if numberOfPeople < 20 {
                                    numberOfPeople += 1
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(numberOfPeople < 20 ? .Theme.calculator2 : .Theme.textTertiary.opacity(0.3))
                            }
                            .disabled(numberOfPeople >= 20)
                        }
                    }
                }

                // Results
                VStack(spacing: .Spacing.medium) {
                    // Primary result - Per Person or Total
                    if numberOfPeople > 1 {
                        PrimaryResultCard(
                            title: "Per Person",
                            value: "$\(amountPerPerson, specifier: "%.2f")",
                            subtitle: "Split between \(numberOfPeople) people",
                            color: .Theme.calculator2
                        )
                    } else {
                        PrimaryResultCard(
                            title: "Total Amount",
                            value: "$\(totalAmount, specifier: "%.2f")",
                            subtitle: "Bill + Tip",
                            color: .Theme.calculator2
                        )
                    }

                    // Breakdown
                    CardContainer {
                        VStack(spacing: .Spacing.medium) {
                            InfoRow(
                                label: "Original Bill",
                                value: "$\(Double(billAmount) ?? 0, specifier: "%.2f")",
                                icon: "doc.text.fill"
                            )

                            ThemedDivider()

                            InfoRow(
                                label: "Tip (\(Int(tipPercentage))%)",
                                value: "$\(tipAmount, specifier: "%.2f")",
                                icon: "plus.circle.fill"
                            )

                            ThemedDivider()

                            InfoRow(
                                label: "Total Bill",
                                value: "$\(totalAmount, specifier: "%.2f")",
                                icon: "equal.circle.fill"
                            )

                            if numberOfPeople > 1 {
                                ThemedDivider()

                                InfoRow(
                                    label: "Each Person Pays",
                                    value: "$\(amountPerPerson, specifier: "%.2f")",
                                    icon: "person.fill"
                                )
                            }
                        }
                    }
                }
            }
            .padding(.Spacing.large)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Tip Calculator")
        .navigationBarTitleDisplayModeCompat(.inline)
    }
}

struct ResultRow: View {
    let label: String
    let amount: Double
    var highlight: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(highlight ? .headline : .body)
            Spacer()
            Text("$\(amount, specifier: "%.2f")")
                .font(highlight ? .title2 : .title3)
                .fontWeight(highlight ? .bold : .semibold)
                .foregroundColor(highlight ? .blue : .primary)
        }
    }
}

#Preview {
    NavigationView {
        TipCalculator()
    }
}
