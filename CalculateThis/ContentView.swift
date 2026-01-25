import SwiftUI

struct ContentView: View {
    @StateObject private var calculatorStore = CalculatorStore()

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

                    // Custom Calculators Section
                    if !calculatorStore.myCalculators.isEmpty {
                        VStack(alignment: .leading, spacing: .Spacing.medium) {
                            HStack {
                                VStack(alignment: .leading, spacing: .Spacing.xxsmall) {
                                    Text("My Calculators")
                                        .font(.Theme.titleLarge)
                                        .fontWeight(.bold)
                                    Text("\(calculatorStore.myCalculators.count) custom calculator\(calculatorStore.myCalculators.count == 1 ? "" : "s")")
                                        .font(.Theme.bodySmall)
                                        .foregroundColor(.Theme.textSecondary)
                                }
                                Spacer()
                                NavigationLink(destination: MyCalculators().environmentObject(calculatorStore)) {
                                    Text("See All")
                                        .font(.Theme.labelLarge)
                                        .foregroundColor(.Theme.primary)
                                }
                            }
                            .padding(.horizontal, .Spacing.large)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: .Spacing.medium) {
                                    ForEach(calculatorStore.myCalculators.prefix(5)) { calculator in
                                        NavigationLink(destination: CustomCalculatorRunner(calculator: calculator)) {
                                            CustomCalculatorCard(calculator: calculator)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, .Spacing.large)
                            }
                        }
                    }

                    // Marketplace Banner
                    NavigationLink(destination: CalculatorMarketplace().environmentObject(calculatorStore)) {
                        HStack(spacing: .Spacing.medium) {
                            ZStack {
                                RoundedRectangle(cornerRadius: .CornerRadius.medium)
                                    .fill(Color.Theme.accent.opacity(0.15))
                                    .frame(width: 56, height: 56)

                                Image(systemName: "cart.fill")
                                    .font(.system(size: IconConfig.largeSize))
                                    .foregroundColor(.Theme.accent)
                            }

                            VStack(alignment: .leading, spacing: .Spacing.xxsmall) {
                                Text("Calculator Marketplace")
                                    .font(.Theme.titleMedium)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.Theme.textPrimary)

                                Text("Discover community-created calculators")
                                    .font(.Theme.bodySmall)
                                    .foregroundColor(.Theme.textSecondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.Theme.textTertiary)
                        }
                        .padding(.Spacing.medium)
                        .background(
                            LinearGradient(
                                colors: [Color.Theme.accent.opacity(0.1), Color.Theme.primary.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(.CornerRadius.large)
                        .overlay(
                            RoundedRectangle(cornerRadius: .CornerRadius.large)
                                .stroke(Color.Theme.accent.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: ShadowStyle.small.color, radius: ShadowStyle.small.radius, x: 0, y: ShadowStyle.small.y)
                        .padding(.horizontal, .Spacing.large)
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Section Header
                    VStack(alignment: .leading, spacing: .Spacing.xxsmall) {
                        Text("Built-in Calculators")
                            .font(.Theme.titleLarge)
                            .fontWeight(.bold)
                        Text("Essential calculation tools")
                            .font(.Theme.bodySmall)
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
            .background(Color(NSColor.controlBackgroundColor))
            .navigationTitle("")
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

// Custom Calculator Card for horizontal scroll
struct CustomCalculatorCard: View {
    let calculator: CustomCalculator

    private var calculatorColor: Color {
        switch calculator.color {
        case "blue": return .Theme.calculator1
        case "green": return .Theme.calculator2
        case "red": return .Theme.calculator3
        case "orange": return .Theme.calculator4
        case "purple": return .Theme.calculator5
        case "pink": return .Theme.calculator6
        default: return .Theme.primary
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .Spacing.small) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: .CornerRadius.medium)
                    .fill(calculatorColor.opacity(0.15))
                    .frame(width: 48, height: 48)

                Image(systemName: calculator.icon)
                    .font(.system(size: IconConfig.mediumSize))
                    .foregroundColor(calculatorColor)
            }

            VStack(alignment: .leading, spacing: .Spacing.xxsmall) {
                Text(calculator.name)
                    .font(.Theme.titleSmall)
                    .fontWeight(.semibold)
                    .foregroundColor(.Theme.textPrimary)
                    .lineLimit(1)

                Text(calculator.description)
                    .font(.Theme.caption)
                    .foregroundColor(.Theme.textSecondary)
                    .lineLimit(2)
                    .frame(height: 32)
            }

            HStack(spacing: .Spacing.xxsmall) {
                Badge(text: calculator.category.rawValue, color: calculatorColor)
                Spacer()
            }
        }
        .padding(.Spacing.medium)
        .frame(width: 160)
        .background(Color.Theme.cardBackground)
        .cornerRadius(.CornerRadius.medium)
        .shadow(color: ShadowStyle.small.color, radius: ShadowStyle.small.radius, x: 0, y: ShadowStyle.small.y)
    }
}

#Preview {
    ContentView()
}
