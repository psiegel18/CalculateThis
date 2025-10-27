//
//  AgeCalculator.swift
//  CalculateThis
//

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
            VStack(spacing: .Spacing.large) {
                // Birth Date Picker
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "gift.fill")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator6)
                            Text("Birth Date")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                }

                // Target Date Picker
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "calendar.circle.fill")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator6)
                            Text("Calculate Age As Of")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        DatePicker("", selection: $targetDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                }

                // Calculate Button
                Button(action: {
                    withAnimation(.theme) {
                        showResults = true
                    }
                }) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Calculate Age")
                            .fontWeight(.semibold)
                    }
                }
                .primaryButtonStyle()

                // Results
                if showResults && birthDate < targetDate {
                    VStack(spacing: .Spacing.large) {
                        // Primary Age Display
                        CardContainer {
                            VStack(spacing: .Spacing.medium) {
                                Text("Your Age")
                                    .font(.Theme.titleMedium)
                                    .foregroundColor(.Theme.textSecondary)

                                HStack(spacing: .Spacing.medium) {
                                    EnhancedAgeBlock(value: ageComponents.year ?? 0, label: "Years", color: .Theme.calculator6)
                                    EnhancedAgeBlock(value: ageComponents.month ?? 0, label: "Months", color: .Theme.calculator6)
                                    EnhancedAgeBlock(value: ageComponents.day ?? 0, label: "Days", color: .Theme.calculator6)
                                }
                            }
                        }

                        // Alternative Representations
                        CardContainer {
                            VStack(alignment: .leading, spacing: .Spacing.medium) {
                                HStack {
                                    Image(systemName: "clock.fill")
                                        .font(.system(size: IconConfig.mediumSize))
                                        .foregroundColor(.Theme.calculator6)
                                    Text("In Other Units")
                                        .font(.Theme.titleMedium)
                                        .fontWeight(.semibold)
                                }

                                VStack(spacing: .Spacing.small) {
                                    InfoRow(label: "Total Months", value: "\(totalMonths)", icon: "calendar")
                                    ThemedDivider()
                                    InfoRow(label: "Total Weeks", value: "\(totalWeeks)", icon: "calendar")
                                    ThemedDivider()
                                    InfoRow(label: "Total Days", value: "\(totalDays)", icon: "calendar")
                                    ThemedDivider()
                                    InfoRow(label: "Total Hours", value: "\(totalHours)", icon: "clock")
                                    ThemedDivider()
                                    InfoRow(label: "Total Minutes", value: "\(totalMinutes)", icon: "clock")
                                }
                            }
                        }

                        // Next Birthday
                        if let next = nextBirthday {
                            PrimaryResultCard(
                                title: "Next Birthday",
                                value: next.formatted(date: .long, time: .omitted),
                                subtitle: "in \(daysUntilBirthday) days",
                                color: .Theme.calculator2
                            )
                        }
                    }
                } else if showResults {
                    CardContainer {
                        VStack(spacing: .Spacing.small) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: IconConfig.xlargeSize))
                                .foregroundColor(.Theme.error)

                            Text("Birth date must be before target date")
                                .font(.Theme.bodyMedium)
                                .foregroundColor(.Theme.error)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.Spacing.medium)
                    }
                }
            }
            .padding(.Spacing.large)
        }
        .background(Color(.systemGroupedBackground))
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

struct EnhancedAgeBlock: View {
    let value: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: .Spacing.xxsmall) {
            Text("\(value)")
                .font(.Theme.displaySmall)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(label)
                .font(.Theme.labelMedium)
                .foregroundColor(.Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.Spacing.medium)
        .background(color.opacity(0.1))
        .cornerRadius(.CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: .CornerRadius.medium)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
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
