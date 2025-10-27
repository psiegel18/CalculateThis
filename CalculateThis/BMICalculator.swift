import SwiftUI

struct BMICalculator: View {
    @State private var weight = ""
    @State private var height = ""
    @State private var useMetric = true

    var bmi: Double {
        let w = Double(weight) ?? 0
        let h = Double(height) ?? 0

        guard w > 0 && h > 0 else { return 0 }

        if useMetric {
            // kg and cm
            let heightInMeters = h / 100
            return w / (heightInMeters * heightInMeters)
        } else {
            // lbs and inches
            return (w / (h * h)) * 703
        }
    }

    var bmiCategory: (String, Color, String) {
        switch bmi {
        case 0..<18.5:
            return ("Underweight", .Theme.calculator1, "arrow.down.circle.fill")
        case 18.5..<25:
            return ("Normal Weight", .Theme.calculator2, "checkmark.circle.fill")
        case 25..<30:
            return ("Overweight", .Theme.calculator4, "exclamationmark.triangle.fill")
        case 30...:
            return ("Obese", .Theme.calculator3, "exclamationmark.circle.fill")
        default:
            return ("", .gray, "")
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: .Spacing.large) {
                // Unit Toggle
                CardContainer {
                    VStack(spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator3)
                            Text("Unit System")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                            Spacer()
                        }

                        Picker("Unit System", selection: $useMetric.animation(.theme)) {
                            Text("Metric (kg, cm)").tag(true)
                            Text("Imperial (lbs, in)").tag(false)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }

                // Weight Input
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "scalemass.fill")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator3)
                            Text("Weight")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        HStack(spacing: .Spacing.small) {
                            TextField(useMetric ? "70" : "154", text: $weight)
                                .keyboardTypeCompat(.decimalPad)
                                .font(.Theme.displaySmall)
                                .fontWeight(.bold)

                            Text(useMetric ? "kg" : "lbs")
                                .font(.Theme.titleLarge)
                                .foregroundColor(.Theme.textSecondary)
                        }
                        .padding(.Spacing.medium)
                        .background(Color.Theme.secondaryBackground)
                        .cornerRadius(.CornerRadius.medium)
                    }
                }

                // Height Input
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "ruler.fill")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator3)
                            Text("Height")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        HStack(spacing: .Spacing.small) {
                            TextField(useMetric ? "175" : "69", text: $height)
                                .keyboardTypeCompat(.decimalPad)
                                .font(.Theme.displaySmall)
                                .fontWeight(.bold)

                            Text(useMetric ? "cm" : "in")
                                .font(.Theme.titleLarge)
                                .foregroundColor(.Theme.textSecondary)
                        }
                        .padding(.Spacing.medium)
                        .background(Color.Theme.secondaryBackground)
                        .cornerRadius(.CornerRadius.medium)
                    }
                }

                // BMI Result
                if bmi > 0 {
                    PrimaryResultCard(
                        title: "Your BMI",
                        value: String(format: "%.1f", bmi),
                        subtitle: bmiCategory.0,
                        color: bmiCategory.1
                    )

                    // BMI Category Badge
                    HStack(spacing: .Spacing.small) {
                        Image(systemName: bmiCategory.2)
                            .font(.system(size: IconConfig.mediumSize))
                            .foregroundColor(bmiCategory.1)

                        Text(bmiCategory.0)
                            .font(.Theme.titleMedium)
                            .fontWeight(.bold)
                            .foregroundColor(bmiCategory.1)
                    }
                    .padding(.horizontal, .Spacing.large)
                    .padding(.vertical, .Spacing.medium)
                    .background(bmiCategory.1.opacity(0.15))
                    .cornerRadius(.CornerRadius.full)
                    .overlay(
                        RoundedRectangle(cornerRadius: .CornerRadius.full)
                            .stroke(bmiCategory.1.opacity(0.3), lineWidth: 2)
                    )

                    // BMI Scale
                    CardContainer {
                        VStack(alignment: .leading, spacing: .Spacing.medium) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: IconConfig.mediumSize))
                                    .foregroundColor(.Theme.calculator3)
                                Text("BMI Categories")
                                    .font(.Theme.titleMedium)
                                    .fontWeight(.semibold)
                            }

                            VStack(spacing: .Spacing.small) {
                                EnhancedBMIScaleRow(
                                    label: "Underweight",
                                    range: "< 18.5",
                                    color: .Theme.calculator1,
                                    isActive: bmi < 18.5
                                )
                                EnhancedBMIScaleRow(
                                    label: "Normal Weight",
                                    range: "18.5 - 24.9",
                                    color: .Theme.calculator2,
                                    isActive: bmi >= 18.5 && bmi < 25
                                )
                                EnhancedBMIScaleRow(
                                    label: "Overweight",
                                    range: "25 - 29.9",
                                    color: .Theme.calculator4,
                                    isActive: bmi >= 25 && bmi < 30
                                )
                                EnhancedBMIScaleRow(
                                    label: "Obese",
                                    range: "≥ 30",
                                    color: .Theme.calculator3,
                                    isActive: bmi >= 30
                                )
                            }
                        }
                    }
                }
            }
            .padding(.Spacing.large)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("BMI Calculator")
        .navigationBarTitleDisplayModeCompat(.inline)
    }
}

struct BMIScaleRow: View {
    let label: String
    let range: String
    let color: Color

    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
                .fontWeight(.medium)
            Spacer()
            Text(range)
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 5)
    }
}

struct EnhancedBMIScaleRow: View {
    let label: String
    let range: String
    let color: Color
    let isActive: Bool

    var body: some View {
        HStack(spacing: .Spacing.small) {
            // Color indicator
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 4, height: 40)

            VStack(alignment: .leading, spacing: .Spacing.xxsmall) {
                Text(label)
                    .font(.Theme.bodyMedium)
                    .fontWeight(isActive ? .bold : .regular)

                Text(range)
                    .font(.Theme.caption)
                    .foregroundColor(.Theme.textTertiary)
            }

            Spacer()

            if isActive {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: IconConfig.mediumSize))
                    .foregroundColor(color)
            }
        }
        .padding(.Spacing.small)
        .background(isActive ? color.opacity(0.1) : Color.clear)
        .cornerRadius(.CornerRadius.small)
    }
}

#Preview {
    NavigationView {
        BMICalculator()
    }
}
