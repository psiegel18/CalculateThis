import SwiftUI

struct LoanCalculator: View {
    @State private var loanAmount = ""
    @State private var interestRate = ""
    @State private var loanTerm = ""
    @State private var termUnit = 0 // 0 = years, 1 = months

    var monthlyPayment: Double {
        let principal = Double(loanAmount) ?? 0
        let rate = (Double(interestRate) ?? 0) / 100 / 12
        let months = termUnit == 0 ? (Double(loanTerm) ?? 0) * 12 : (Double(loanTerm) ?? 0)

        guard principal > 0, rate > 0, months > 0 else { return 0 }

        let payment = principal * (rate * pow(1 + rate, months)) / (pow(1 + rate, months) - 1)
        return payment
    }

    var totalPayment: Double {
        let months = termUnit == 0 ? (Double(loanTerm) ?? 0) * 12 : (Double(loanTerm) ?? 0)
        return monthlyPayment * months
    }

    var totalInterest: Double {
        let principal = Double(loanAmount) ?? 0
        return totalPayment - principal
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: .Spacing.large) {
                // Loan Amount
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "banknote.fill")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator4)
                            Text("Loan Amount")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        HStack(spacing: .Spacing.small) {
                            Text("$")
                                .font(.Theme.displaySmall)
                                .foregroundColor(.Theme.textSecondary)

                            TextField("25000", text: $loanAmount)
                                .keyboardTypeCompat(.decimalPad)
                                .font(.Theme.displaySmall)
                                .fontWeight(.bold)
                        }
                        .padding(.Spacing.medium)
                        .background(Color.Theme.secondaryBackground)
                        .cornerRadius(.CornerRadius.medium)
                    }
                }

                // Interest Rate
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "percent")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator4)
                            Text("Annual Interest Rate")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        HStack(spacing: .Spacing.small) {
                            TextField("5.5", text: $interestRate)
                                .keyboardTypeCompat(.decimalPad)
                                .font(.Theme.displaySmall)
                                .fontWeight(.bold)

                            Text("%")
                                .font(.Theme.titleLarge)
                                .foregroundColor(.Theme.textSecondary)
                        }
                        .padding(.Spacing.medium)
                        .background(Color.Theme.secondaryBackground)
                        .cornerRadius(.CornerRadius.medium)
                    }
                }

                // Loan Term
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator4)
                            Text("Loan Term")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        VStack(spacing: .Spacing.small) {
                            TextField("5", text: $loanTerm)
                                .keyboardTypeCompat(.numberPad)
                                .font(.Theme.displaySmall)
                                .fontWeight(.bold)
                                .padding(.Spacing.medium)
                                .background(Color.Theme.secondaryBackground)
                                .cornerRadius(.CornerRadius.medium)

                            Picker("", selection: $termUnit) {
                                Text("Years").tag(0)
                                Text("Months").tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                }

                // Results
                if monthlyPayment > 0 {
                    PrimaryResultCard(
                        title: "Monthly Payment",
                        value: "$\(String(format: "%.2f", monthlyPayment))",
                        subtitle: "Due each month",
                        color: .Theme.calculator4
                    )

                    // Additional Details
                    CardContainer {
                        VStack(spacing: .Spacing.medium) {
                            InfoRow(
                                label: "Total Amount Paid",
                                value: "$\(String(format: "%.2f", totalPayment))",
                                icon: "sum"
                            )

                            ThemedDivider()

                            InfoRow(
                                label: "Total Interest",
                                value: "$\(String(format: "%.2f", totalInterest))",
                                icon: "chart.line.uptrend.xyaxis"
                            )

                            ThemedDivider()

                            InfoRow(
                                label: "Principal",
                                value: "$\(String(format: "%.2f", Double(loanAmount) ?? 0))",
                                icon: "dollarsign.circle"
                            )
                        }
                    }

                    // Breakdown
                    CardContainer {
                        VStack(alignment: .leading, spacing: .Spacing.medium) {
                            HStack {
                                Image(systemName: "chart.pie.fill")
                                    .font(.system(size: IconConfig.mediumSize))
                                    .foregroundColor(.Theme.calculator4)
                                Text("Payment Breakdown")
                                    .font(.Theme.titleMedium)
                                    .fontWeight(.semibold)
                            }

                            let principal = Double(loanAmount) ?? 0
                            let interestPercent = (totalInterest / totalPayment) * 100
                            let principalPercent = (principal / totalPayment) * 100

                            GeometryReader { geometry in
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.Theme.calculator4)
                                        .frame(width: geometry.size.width * (principalPercent / 100))

                                    Rectangle()
                                        .fill(Color.Theme.calculator4.opacity(0.5))
                                        .frame(width: geometry.size.width * (interestPercent / 100))
                                }
                            }
                            .frame(height: 40)
                            .cornerRadius(.CornerRadius.small)

                            VStack(spacing: .Spacing.small) {
                                HStack {
                                    Circle()
                                        .fill(Color.Theme.calculator4)
                                        .frame(width: 12, height: 12)
                                    Text("Principal")
                                        .font(.Theme.bodyMedium)
                                    Spacer()
                                    Text("\(String(format: "%.1f", principalPercent))%")
                                        .font(.Theme.bodyMedium)
                                        .fontWeight(.semibold)
                                }

                                HStack {
                                    Circle()
                                        .fill(Color.Theme.calculator4.opacity(0.5))
                                        .frame(width: 12, height: 12)
                                    Text("Interest")
                                        .font(.Theme.bodyMedium)
                                    Spacer()
                                    Text("\(String(format: "%.1f", interestPercent))%")
                                        .font(.Theme.bodyMedium)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.Spacing.large)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Loan Calculator")
        .navigationBarTitleDisplayModeCompat(.inline)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    var valueColor: Color = .primary
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(valueColor)
        }
    }
}

#Preview {
    NavigationView {
        LoanCalculator()
    }
}
