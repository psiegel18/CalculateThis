//
//  DayOfWeekCalculator.swift
//  CalculateThis
//

import SwiftUI

struct DayOfWeekCalculator: View {
    @State private var selectedDate = Date()
    @State private var showCalculation = false
    @State private var calculationSteps: [String] = []
    @State private var resultDayOfWeek = ""

    var body: some View {
        ScrollView {
            VStack(spacing: .Spacing.large) {
                // Date Picker
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator1)
                            Text("Select a Date")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .onChange(of: selectedDate) {
                                showCalculation = false
                            }
                    }
                }

                // Calculate Button
                Button(action: {
                    withAnimation(.theme) {
                        calculateDayOfWeek()
                    }
                }) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Calculate Day of Week")
                            .fontWeight(.semibold)
                    }
                }
                .primaryButtonStyle()

                // Result Display
                if showCalculation {
                    VStack(spacing: .Spacing.large) {
                        PrimaryResultCard(
                            title: "Day of the Week",
                            value: resultDayOfWeek,
                            subtitle: selectedDate.formatted(date: .long, time: .omitted),
                            color: .Theme.calculator1
                        )

                        // Calculation Steps
                        CardContainer {
                            VStack(alignment: .leading, spacing: .Spacing.medium) {
                                HStack {
                                    Image(systemName: "function")
                                        .font(.system(size: IconConfig.mediumSize))
                                        .foregroundColor(.Theme.calculator1)
                                    Text("Calculation Steps")
                                        .font(.Theme.titleMedium)
                                        .fontWeight(.semibold)
                                }

                                Text("Doomsday Algorithm")
                                    .font(.Theme.labelMedium)
                                    .foregroundColor(.Theme.textSecondary)

                                VStack(alignment: .leading, spacing: .Spacing.small) {
                                    ForEach(calculationSteps.indices, id: \.self) { index in
                                        HStack(alignment: .top, spacing: .Spacing.small) {
                                            Text("\(index + 1).")
                                                .font(.Theme.monoMedium)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.Theme.calculator1)
                                                .frame(width: 28, alignment: .trailing)

                                            Text(calculationSteps[index])
                                                .font(.Theme.monoMedium)
                                                .foregroundColor(.Theme.textPrimary)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .padding(.vertical, .Spacing.xxsmall)

                                        if index < calculationSteps.count - 1 {
                                            Divider()
                                                .padding(.leading, 36)
                                        }
                                    }
                                }
                                .padding(.Spacing.small)
                                .background(Color.Theme.calculator1.opacity(0.05))
                                .cornerRadius(.CornerRadius.small)
                            }
                        }
                    }
                }
            }
            .padding(.Spacing.large)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Day of Week")
        .navigationBarTitleDisplayModeCompat(.inline)
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
