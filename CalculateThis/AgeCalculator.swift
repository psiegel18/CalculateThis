import SwiftUI

struct AgeCalculator: View {
    @State private var birthDate = Date()
    @State private var targetDate = Date()
    @State private var showResults = false
    
    var ageComponents: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: birthDate, to: targetDate)
    }
    
    var totalDays: Int {
        Calendar.current.dateComponents([.day], from: birthDate, to: targetDate).day ?? 0
    }
    
    var totalWeeks: Int {
        totalDays / 7
    }
    
    var totalMonths: Int {
        let components = Calendar.current.dateComponents([.month], from: birthDate, to: targetDate)
        return components.month ?? 0
    }
    
    var totalHours: Int {
        totalDays * 24
    }
    
    var totalMinutes: Int {
        totalHours * 60
    }
    
    var nextBirthday: Date? {
        var components = Calendar.current.dateComponents([.month, .day], from: birthDate)
        components.year = Calendar.current.component(.year, from: targetDate)
        
        guard var next = Calendar.current.date(from: components) else { return nil }
        
        if next <= targetDate {
            components.year = (components.year ?? 0) + 1
            next = Calendar.current.date(from: components) ?? next
        }
        
        return next
    }
    
    var daysUntilBirthday: Int {
        guard let next = nextBirthday else { return 0 }
        return Calendar.current.dateComponents([.day], from: targetDate, to: next).day ?? 0
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Birth Date Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Birth Date")
                        .font(.headline)
                    
                    DatePicker("", selection: $birthDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }
                .padding()
                .background(Color.systemGray6)
                .cornerRadius(12)
                
                // Target Date Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Calculate Age As Of")
                        .font(.headline)
                    
                    DatePicker("", selection: $targetDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }
                .padding()
                .background(Color.systemGray6)
                .cornerRadius(12)
                
                // Calculate Button
                Button(action: { showResults = true }) {
                    Text("Calculate Age")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                // Results
                if showResults && birthDate < targetDate {
                    VStack(spacing: 20) {
                        // Primary Age Display
                        VStack(spacing: 10) {
                            Text("Your Age")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 15) {
                                AgeBlock(value: ageComponents.year ?? 0, label: "Years")
                                AgeBlock(value: ageComponents.month ?? 0, label: "Months")
                                AgeBlock(value: ageComponents.day ?? 0, label: "Days")
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Alternative Representations
                        VStack(alignment: .leading, spacing: 15) {
                            Text("In Other Units")
                                .font(.headline)
                            
                            StatRow(label: "Total Months", value: "\(totalMonths)")
                            Divider()
                            StatRow(label: "Total Weeks", value: "\(totalWeeks)")
                            Divider()
                            StatRow(label: "Total Days", value: "\(totalDays)")
                            Divider()
                            StatRow(label: "Total Hours", value: "\(totalHours)")
                            Divider()
                            StatRow(label: "Total Minutes", value: "\(totalMinutes)")
                        }
                        .padding()
                        .background(Color.systemGray6)
                        .cornerRadius(12)
                        
                        // Next Birthday
                        if let next = nextBirthday {
                            VStack(spacing: 10) {
                                Text("Next Birthday")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text(next, style: .date)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Text("in \(daysUntilBirthday) days")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                } else if showResults {
                    Text("Birth date must be before target date")
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Age Calculator")
        .navigationBarTitleDisplayModeCompat(.inline)
    }
}

struct AgeBlock: View {
    let value: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(value)")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.blue)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }
    }
}

#Preview {
    NavigationView {
        AgeCalculator()
    }
}
