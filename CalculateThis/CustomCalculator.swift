//
//  CustomCalculator.swift
//  CalculateThis
//
//  Data models for custom user-created calculators
//

import SwiftUI

// MARK: - Custom Calculator Model

struct CustomCalculator: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var description: String
    var icon: String
    var color: String
    var inputs: [CalculatorInput]
    var formulas: [CalculatorFormula]
    var outputs: [CalculatorOutput]
    var author: String
    var version: String = "1.0"
    var downloads: Int = 0
    var rating: Double = 0
    var ratingCount: Int = 0
    var createdDate: Date = Date()
    var isPublished: Bool = false
    var category: CalculatorCategory = .other

    enum CalculatorCategory: String, Codable, CaseIterable {
        case finance = "Finance"
        case health = "Health"
        case conversion = "Conversion"
        case math = "Math"
        case science = "Science"
        case lifestyle = "Lifestyle"
        case business = "Business"
        case other = "Other"

        var icon: String {
            switch self {
            case .finance: return "dollarsign.circle.fill"
            case .health: return "heart.fill"
            case .conversion: return "arrow.triangle.2.circlepath"
            case .math: return "function"
            case .science: return "atom"
            case .lifestyle: return "sparkles"
            case .business: return "briefcase.fill"
            case .other: return "square.grid.2x2.fill"
            }
        }
    }
}

// MARK: - Calculator Input

struct CalculatorInput: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var label: String
    var type: InputType
    var defaultValue: String = ""
    var unit: String?
    var minValue: Double?
    var maxValue: Double?
    var step: Double?
    var placeholder: String?

    enum InputType: String, Codable, CaseIterable {
        case number = "Number"
        case decimal = "Decimal"
        case text = "Text"
        case slider = "Slider"
        case toggle = "Toggle"
        case picker = "Picker"
        case date = "Date"

        var icon: String {
            switch self {
            case .number, .decimal: return "number"
            case .text: return "textformat"
            case .slider: return "slider.horizontal.3"
            case .toggle: return "switch.2"
            case .picker: return "list.bullet"
            case .date: return "calendar"
            }
        }
    }
}

// MARK: - Calculator Formula

struct CalculatorFormula: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var expression: String
    var description: String?
}

// MARK: - Calculator Output

struct CalculatorOutput: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var label: String
    var formulaName: String
    var format: OutputFormat
    var unit: String?
    var showInResult: Bool = true

    enum OutputFormat: String, Codable, CaseIterable {
        case number = "Number"
        case decimal1 = "Decimal (1)"
        case decimal2 = "Decimal (2)"
        case decimal4 = "Decimal (4)"
        case currency = "Currency"
        case percentage = "Percentage"
        case text = "Text"

        func format(_ value: Double) -> String {
            switch self {
            case .number:
                return String(format: "%.0f", value)
            case .decimal1:
                return String(format: "%.1f", value)
            case .decimal2:
                return String(format: "%.2f", value)
            case .decimal4:
                return String(format: "%.4f", value)
            case .currency:
                return "$\(String(format: "%.2f", value))"
            case .percentage:
                return "\(String(format: "%.1f", value))%"
            case .text:
                return "\(value)"
            }
        }
    }
}

// MARK: - Sample Templates

extension CustomCalculator {
    static var templates: [CustomCalculator] {
        [
            // Percentage Calculator Template
            CustomCalculator(
                name: "Percentage Calculator",
                description: "Calculate percentages and percentage changes",
                icon: "percent",
                color: "blue",
                inputs: [
                    CalculatorInput(name: "value", label: "Value", type: .decimal, placeholder: "100"),
                    CalculatorInput(name: "percentage", label: "Percentage", type: .decimal, placeholder: "20")
                ],
                formulas: [
                    CalculatorFormula(name: "result", expression: "value * (percentage / 100)", description: "Calculate percentage of value")
                ],
                outputs: [
                    CalculatorOutput(label: "Result", formulaName: "result", format: .decimal2)
                ],
                author: "CalculateThis",
                category: .math
            ),

            // Discount Calculator Template
            CustomCalculator(
                name: "Discount Calculator",
                description: "Calculate discounted prices and savings",
                icon: "tag.fill",
                color: "green",
                inputs: [
                    CalculatorInput(name: "price", label: "Original Price", type: .decimal, placeholder: "99.99"),
                    CalculatorInput(name: "discount", label: "Discount %", type: .slider, defaultValue: "20", minValue: 0, maxValue: 100)
                ],
                formulas: [
                    CalculatorFormula(name: "savings", expression: "price * (discount / 100)", description: "Amount saved"),
                    CalculatorFormula(name: "final", expression: "price - savings", description: "Final price")
                ],
                outputs: [
                    CalculatorOutput(label: "You Save", formulaName: "savings", format: .currency),
                    CalculatorOutput(label: "Final Price", formulaName: "final", format: .currency)
                ],
                author: "CalculateThis",
                category: .finance
            ),

            // Speed Calculator Template
            CustomCalculator(
                name: "Speed Calculator",
                description: "Calculate speed, distance, or time",
                icon: "speedometer",
                color: "orange",
                inputs: [
                    CalculatorInput(name: "distance", label: "Distance", type: .decimal, placeholder: "100", unit: "km"),
                    CalculatorInput(name: "time", label: "Time", type: .decimal, placeholder: "2", unit: "hours")
                ],
                formulas: [
                    CalculatorFormula(name: "speed", expression: "distance / time", description: "Speed = Distance / Time")
                ],
                outputs: [
                    CalculatorOutput(label: "Speed", formulaName: "speed", format: .decimal2, unit: "km/h")
                ],
                author: "CalculateThis",
                category: .science
            )
        ]
    }
}
