import SwiftUI

struct DayOfWeekCalculator: View {
    @State private var selectedDate = Date()
    @State private var showCalculation = false
    @State private var calculationSteps: [String] = []
    @State private var resultDayOfWeek = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Date Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Select a Date")
                        .font(.headline)
                    
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .onChange(of: selectedDate) { _ in
                            showCalculation = false
                        }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Calculate Button
                Button(action: calculateDayOfWeek) {
                    Text("Calculate Day of Week")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                // Result Display
                if showCalculation {
                    VStack(spacing: 15) {
                        Text("Result")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(resultDayOfWeek)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        
                        // Calculation Steps
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Calculation Steps (Doomsday Algorithm)")
                                .font(.headline)
                                .padding(.bottom, 5)
                            
                            ForEach(calculationSteps.indices, id: \.self) { index in
                                HStack(alignment: .top, spacing: 10) {
                                    Text("\(index + 1).")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                    Text(calculationSteps[index])
                                        .font(.system(.body, design: .monospaced))
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Day of Week")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func calculateDayOfWeek() {
        calculationSteps.removeAll()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day else { return }
        
        // Step 1: Calculate Century Code
        let centuryCode = getCenturyCode(year: year)
        let baseYear = (year / 100) * 100
        calculationSteps.append("Century Code for \(baseYear)s: \(centuryCode)")
        
        // Step 2: Calculate year components
        let xxYear = year % 100
        let xxYearQuotient = xxYear / 12
        let xxYearRemainder = xxYear % 12
        calculationSteps.append("Last 2 digits: \(xxYear) ÷ 12 = \(xxYearQuotient) R \(xxYearRemainder)")
        
        // Step 3: Divide remainder by 4
        let xxYearRemDiv4Quotient = xxYearRemainder / 4
        let xxYearRemDiv4Remainder = xxYearRemainder % 4
        calculationSteps.append("Remainder ÷ 4: \(xxYearRemainder) ÷ 4 = \(xxYearRemDiv4Quotient) R \(xxYearRemDiv4Remainder)")
        
        // Step 4: Get month's doomsday
        let monthDoomsday = getDoomsday(month: month, year: year)
        let monthName = calendar.monthSymbols[month - 1]
        calculationSteps.append("\(monthName)'s Doomsday: \(monthDoomsday)")
        
        // Step 5: Calculate user doomsday
        let userDoomsday = day - monthDoomsday
        calculationSteps.append("User Doomsday: \(day) - \(monthDoomsday) = \(userDoomsday)")
        
        // Step 6: Sum all values
        let totalResult = centuryCode + xxYearQuotient + xxYearRemainder + xxYearRemDiv4Quotient + userDoomsday
        calculationSteps.append("Total: \(centuryCode) + \(xxYearQuotient) + \(xxYearRemainder) + \(xxYearRemDiv4Quotient) + \(userDoomsday) = \(totalResult)")
        
        // Step 7: Get remainder when dividing by 7
        var weekDate = totalResult % 7
        if weekDate < 0 {
            weekDate += 7
            calculationSteps.append("Adjusted: \(totalResult) mod 7 = \(weekDate) (added 7 for negative)")
        } else {
            calculationSteps.append("Final: \(totalResult) mod 7 = \(weekDate)")
        }
        
        // Get day name
        let weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        resultDayOfWeek = weekdays[weekDate]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        let dateString = formatter.string(from: selectedDate)
        calculationSteps.append("\(dateString) was a \(resultDayOfWeek)!")
        
        showCalculation = true
    }
    
    func getCenturyCode(year: Int) -> Int {
        let centuries: [(range: ClosedRange<Int>, code: Int)] = [
            (1...99, 2), (100...199, 0), (200...299, 5), (300...399, 3),
            (400...499, 2), (500...599, 0), (600...699, 5), (700...799, 3),
            (800...899, 2), (900...999, 0), (1000...1099, 5), (1100...1199, 3),
            (1200...1299, 2), (1300...1399, 0), (1400...1499, 5), (1500...1599, 3),
            (1600...1699, 2), (1700...1799, 0), (1800...1899, 5), (1900...1999, 3),
            (2000...2099, 2), (2100...2199, 0), (2200...2299, 5), (2300...2399, 3),
            (2400...2499, 2), (2500...2599, 0), (2600...2699, 5), (2700...2799, 3),
            (2800...2899, 2), (2900...2999, 0), (3000...3099, 5), (3100...3199, 3)
        ]
        
        for century in centuries {
            if century.range.contains(year) {
                return century.code
            }
        }
        return 0
    }
    
    func getDoomsday(month: Int, year: Int) -> Int {
        let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
        
        switch month {
        case 1: return isLeapYear ? 4 : 3      // January
        case 2: return isLeapYear ? 29 : 28    // February
        case 3: return 14                       // March
        case 4: return 4                        // April
        case 5: return 9                        // May
        case 6: return 6                        // June
        case 7: return 11                       // July
        case 8: return 8                        // August
        case 9: return 5                        // September
        case 10: return 10                      // October
        case 11: return 7                       // November
        case 12: return 12                      // December
        default: return 0
        }
    }
}

#Preview {
    NavigationView {
        DayOfWeekCalculator()
    }
}
