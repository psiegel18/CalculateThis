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
            VStack(spacing: 25) {
                // Bill Amount Input
                VStack(alignment: .leading, spacing: 10) {
                    Text("Bill Amount")
                        .font(.headline)
                    
                    HStack {
                        Text("$")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        TextField("0.00", text: $billAmount)
                            .keyboardTypeCompat(.decimalPad)
                            .font(.title2)
                    }
                    .padding()
                    .background(Color.systemGray6)
                    .cornerRadius(10)
                }
                
                // Tip Percentage Slider
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Tip Percentage")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(tipPercentage))%")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    
                    Slider(value: $tipPercentage, in: 0...30, step: 1)
                        .accentColor(.blue)
                    
                    HStack {
                        Text("0%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("30%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.systemGray6)
                .cornerRadius(10)
                
                // Quick Tip Buttons
                HStack(spacing: 10) {
                    ForEach([10, 15, 18, 20], id: \.self) { percent in
                        Button(action: { tipPercentage = Double(percent) }) {
                            Text("\(percent)%")
                                .fontWeight(tipPercentage == Double(percent) ? .bold : .regular)
                                .foregroundColor(tipPercentage == Double(percent) ? .white : .blue)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(tipPercentage == Double(percent) ? Color.blue : Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Number of People
                VStack(alignment: .leading, spacing: 10) {
                    Text("Split Between")
                        .font(.headline)
                    
                    Stepper(value: $numberOfPeople, in: 1...20) {
                        Text("\(numberOfPeople) \(numberOfPeople == 1 ? "person" : "people")")
                            .font(.title3)
                    }
                }
                .padding()
                .background(Color.systemGray6)
                .cornerRadius(10)
                
                // Results
                VStack(spacing: 15) {
                    ResultRow(label: "Tip Amount", amount: tipAmount, highlight: true)
                    ResultRow(label: "Total Bill", amount: totalAmount)
                    
                    if numberOfPeople > 1 {
                        Divider()
                        ResultRow(label: "Per Person", amount: amountPerPerson, highlight: true)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
        }
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
