import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: DayOfWeekCalculator()) {
                    CalculatorRow(
                        icon: "calendar",
                        title: "Day of Week Calculator",
                        description: "Find what day of the week any date falls on"
                    )
                }
                
                NavigationLink(destination: TipCalculator()) {
                    CalculatorRow(
                        icon: "dollarsign.circle",
                        title: "Tip Calculator",
                        description: "Calculate tips and split bills"
                    )
                }
                
                NavigationLink(destination: BMICalculator()) {
                    CalculatorRow(
                        icon: "heart.text.square",
                        title: "BMI Calculator",
                        description: "Calculate Body Mass Index"
                    )
                }
                
                NavigationLink(destination: LoanCalculator()) {
                    CalculatorRow(
                        icon: "creditcard",
                        title: "Loan Calculator",
                        description: "Calculate monthly loan payments"
                    )
                }
                
                NavigationLink(destination: UnitConverter()) {
                    CalculatorRow(
                        icon: "arrow.left.arrow.right",
                        title: "Unit Converter",
                        description: "Convert between different units"
                    )
                }
                
                NavigationLink(destination: AgeCalculator()) {
                    CalculatorRow(
                        icon: "person.crop.circle",
                        title: "Age Calculator",
                        description: "Calculate exact age and time lived"
                    )
                }
            }
            .navigationTitle("Calculators")
            .navigationBarTitleDisplayModeCompat(.large)
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

#Preview {
    ContentView()
}
