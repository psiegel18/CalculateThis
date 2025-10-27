import SwiftUI

struct ContentView: View {
    // Colors for each calculator
    private let calculatorColors: [Color] = [
        .Theme.calculator1,
        .Theme.calculator2,
        .Theme.calculator3,
        .Theme.calculator4,
        .Theme.calculator5,
        .Theme.calculator6
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: .Spacing.large) {
                    // Header
                    VStack(alignment: .leading, spacing: .Spacing.small) {
                        Text("CalculateThis")
                            .font(.Theme.displayMedium)
                            .fontWeight(.bold)
                            .foregroundColor(.Theme.textPrimary)

                        Text("Your all-in-one calculation toolkit")
                            .font(.Theme.bodyLarge)
                            .foregroundColor(.Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .Spacing.large)
                    .padding(.top, .Spacing.medium)

                    // Calculator grid
                    VStack(spacing: .Spacing.medium) {
                        NavigationLink(destination: DayOfWeekCalculator()) {
                            EnhancedCalculatorRow(
                                icon: "calendar",
                                title: "Day of Week",
                                description: "Find what day of the week any date falls on",
                                color: calculatorColors[0]
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        NavigationLink(destination: TipCalculator()) {
                            EnhancedCalculatorRow(
                                icon: "dollarsign.circle.fill",
                                title: "Tip Calculator",
                                description: "Calculate tips and split bills easily",
                                color: calculatorColors[1]
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        NavigationLink(destination: BMICalculator()) {
                            EnhancedCalculatorRow(
                                icon: "heart.text.square.fill",
                                title: "BMI Calculator",
                                description: "Calculate your Body Mass Index",
                                color: calculatorColors[2]
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        NavigationLink(destination: LoanCalculator()) {
                            EnhancedCalculatorRow(
                                icon: "creditcard.fill",
                                title: "Loan Calculator",
                                description: "Calculate monthly loan payments",
                                color: calculatorColors[3]
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        NavigationLink(destination: UnitConverter()) {
                            EnhancedCalculatorRow(
                                icon: "arrow.left.arrow.right.circle.fill",
                                title: "Unit Converter",
                                description: "Convert between different units",
                                color: calculatorColors[4]
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        NavigationLink(destination: AgeCalculator()) {
                            EnhancedCalculatorRow(
                                icon: "person.crop.circle.fill",
                                title: "Age Calculator",
                                description: "Calculate exact age and time lived",
                                color: calculatorColors[5]
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, .Spacing.large)
                    .padding(.bottom, .Spacing.large)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true)
        }
        .navigationViewStyleCompat()
    }
}

struct CalculatorRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

// Enhanced calculator row with modern design
struct EnhancedCalculatorRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(spacing: .Spacing.medium) {
            // Icon container
            ZStack {
                RoundedRectangle(cornerRadius: .CornerRadius.medium)
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.system(size: IconConfig.largeSize))
                    .foregroundColor(color)
            }

            // Text content
            VStack(alignment: .leading, spacing: .Spacing.xxsmall) {
                Text(title)
                    .font(.Theme.titleMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.Theme.textPrimary)

                Text(description)
                    .font(.Theme.bodySmall)
                    .foregroundColor(.Theme.textSecondary)
                    .lineLimit(2)
            }

            Spacer()

            // Arrow indicator
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.Theme.textTertiary)
        }
        .padding(.Spacing.medium)
        .background(Color.Theme.cardBackground)
        .cornerRadius(.CornerRadius.large)
        .shadow(color: ShadowStyle.small.color, radius: ShadowStyle.small.radius, x: 0, y: ShadowStyle.small.y)
    }
}

#Preview {
    ContentView()
}
