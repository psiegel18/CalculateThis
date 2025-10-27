import SwiftUI

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
            VStack(spacing: 25) {
                // Loan Amount
                VStack(alignment: .leading, spacing: 10) {
                    Text("Loan Amount")
                        .font(.headline)
                    
                    HStack {
                        Text("$")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        TextField("0", text: $loanAmount)
                            .keyboardTypeCompat(.decimalPad)
                            .font(.title2)
                    }
                    .padding()
                    .background(Color.systemGray6)
                    .cornerRadius(10)
                }
                
                // Interest Rate
                VStack(alignment: .leading, spacing: 10) {
                    Text("Annual Interest Rate")
                        .font(.headline)
                    
                    HStack {
                        TextField("0", text: $interestRate)
                            .keyboardTypeCompat(.decimalPad)
                            .font(.title2)
                        Text("%")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.systemGray6)
                    .cornerRadius(10)
                }
                
                // Loan Term
                VStack(alignment: .leading, spacing: 10) {
                    Text("Loan Term")
                        .font(.headline)
                    
                    HStack(spacing: 10) {
                        TextField("0", text: $loanTerm)
                            .keyboardTypeCompat(.numberPad)
                            .font(.title2)
                            .padding()
                            .background(Color.systemGray6)
                            .cornerRadius(10)
                        
                        Picker("", selection: $termUnit) {
                            Text("Years").tag(0)
                            Text("Months").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 150)
                    }
                }
                
                // Results
                if monthlyPayment > 0 {
                    VStack(spacing: 20) {
                        // Monthly Payment (Primary)
                        VStack(spacing: 8) {
                            Text("Monthly Payment")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("$\(String(format: "%.2f", monthlyPayment))")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Additional Details
                        VStack(spacing: 15) {
                            DetailRow(
                                label: "Total Amount Paid",
                                value: "$\(String(format: "%.2f", totalPayment))"
                            )
                            
                            Divider()
                            
                            DetailRow(
                                label: "Total Interest",
                                value: "$\(String(format: "%.2f", totalInterest))",
                                valueColor: .orange
                            )
                            
                            Divider()
                            
                            DetailRow(
                                label: "Principal",
                                value: "$\(String(format: "%.2f", Double(loanAmount) ?? 0))"
                            )
                        }
                        .padding()
                        .background(Color.systemGray6)
                        .cornerRadius(12)
                        
                        // Breakdown
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Payment Breakdown")
                                .font(.headline)
                            
                            let principal = Double(loanAmount) ?? 0
                            let interestPercent = (totalInterest / totalPayment) * 100
                            let principalPercent = (principal / totalPayment) * 100
                            
                            GeometryReader { geometry in
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.blue)
                                        .frame(width: geometry.size.width * (principalPercent / 100))
                                    
                                    Rectangle()
                                        .fill(Color.orange)
                                        .frame(width: geometry.size.width * (interestPercent / 100))
                                }
                            }
                            .frame(height: 30)
                            .cornerRadius(8)
                            
                            HStack {
                                Label("Principal (\(String(format: "%.1f", principalPercent))%)", systemImage: "circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                                
                                Spacer()
                                
                                Label("Interest (\(String(format: "%.1f", interestPercent))%)", systemImage: "circle.fill")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .background(Color.systemGray6)
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
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
