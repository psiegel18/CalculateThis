//
//  UnitConverter.swift
//  CalculateThis
//

import SwiftUI

struct UnitConverter: View {
    @State private var category = 0
    @State private var inputValue = ""
    @State private var fromUnit = 0
    @State private var toUnit = 1

    let categories = ["Length", "Weight", "Temperature", "Volume"]

    let lengthUnits = ["Meters", "Kilometers", "Miles", "Feet", "Inches", "Centimeters"]
    let lengthFactors = [1.0, 1000.0, 1609.34, 0.3048, 0.0254, 0.01]

    let weightUnits = ["Kilograms", "Grams", "Pounds", "Ounces"]
    let weightFactors = [1.0, 0.001, 0.453592, 0.0283495]

    let temperatureUnits = ["Celsius", "Fahrenheit", "Kelvin"]

    let volumeUnits = ["Liters", "Milliliters", "Gallons", "Cups", "Fluid Ounces"]
    let volumeFactors = [1.0, 0.001, 3.78541, 0.236588, 0.0295735]

    var currentUnits: [String] {
        switch category {
        case 0: return lengthUnits
        case 1: return weightUnits
        case 2: return temperatureUnits
        case 3: return volumeUnits
        default: return []
        }
    }

    var convertedValue: Double {
        let input = Double(inputValue) ?? 0

        switch category {
        case 0: // Length
            let baseValue = input * lengthFactors[fromUnit]
            return baseValue / lengthFactors[toUnit]
        case 1: // Weight
            let baseValue = input * weightFactors[fromUnit]
            return baseValue / weightFactors[toUnit]
        case 2: // Temperature
            return convertTemperature(input, from: fromUnit, to: toUnit)
        case 3: // Volume
            let baseValue = input * volumeFactors[fromUnit]
            return baseValue / volumeFactors[toUnit]
        default:
            return 0
        }
    }

    var categoryIcon: String {
        switch category {
        case 0: return "ruler"
        case 1: return "scalemass"
        case 2: return "thermometer"
        case 3: return "drop"
        default: return "arrow.left.arrow.right"
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: .Spacing.large) {
                // Category Selector
                CardContainer {
                    VStack(spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "square.grid.2x2")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator5)
                            Text("Category")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                            Spacer()
                        }

                        Picker("Category", selection: $category.animation(.theme)) {
                            ForEach(0..<categories.count, id: \.self) { index in
                                Text(categories[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: category) {
                            fromUnit = 0
                            toUnit = min(1, currentUnits.count - 1)
                            inputValue = ""
                        }
                    }
                }

                // Input Section
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "\(categoryIcon).fill")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator5)
                            Text("From")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        TextField("Enter value", text: $inputValue)
                            .keyboardTypeCompat(.decimalPad)
                            .font(.Theme.displaySmall)
                            .fontWeight(.bold)
                            .padding(.Spacing.medium)
                            .background(Color.Theme.secondaryBackground)
                            .cornerRadius(.CornerRadius.medium)

                        Picker("From Unit", selection: $fromUnit) {
                            ForEach(0..<currentUnits.count, id: \.self) { index in
                                Text(currentUnits[index]).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, .Spacing.medium)
                        .padding(.vertical, .Spacing.small)
                        .background(Color.Theme.calculator5.opacity(0.1))
                        .cornerRadius(.CornerRadius.small)
                    }
                }

                // Swap Button
                Button(action: {
                    withAnimation(.theme) {
                        swapUnits()
                    }
                }) {
                    HStack(spacing: .Spacing.small) {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .font(.system(size: 32))
                        Text("Swap")
                            .font(.Theme.titleSmall)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.Theme.calculator5)
                    .padding(.horizontal, .Spacing.large)
                    .padding(.vertical, .Spacing.small)
                    .background(Color.Theme.calculator5.opacity(0.15))
                    .cornerRadius(.CornerRadius.full)
                }

                // Output Section
                CardContainer {
                    VStack(alignment: .leading, spacing: .Spacing.medium) {
                        HStack {
                            Image(systemName: "\(categoryIcon).fill")
                                .font(.system(size: IconConfig.mediumSize))
                                .foregroundColor(.Theme.calculator5)
                            Text("To")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                        }

                        Text(inputValue.isEmpty ? "0" : String(format: "%.4f", convertedValue))
                            .font(.Theme.displayMedium)
                            .fontWeight(.bold)
                            .foregroundColor(.Theme.calculator5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.Spacing.medium)
                            .background(Color.Theme.calculator5.opacity(0.1))
                            .cornerRadius(.CornerRadius.medium)

                        Picker("To Unit", selection: $toUnit) {
                            ForEach(0..<currentUnits.count, id: \.self) { index in
                                Text(currentUnits[index]).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, .Spacing.medium)
                        .padding(.vertical, .Spacing.small)
                        .background(Color.Theme.calculator2.opacity(0.1))
                        .cornerRadius(.CornerRadius.small)
                    }
                }

                // Conversion Summary
                if !inputValue.isEmpty {
                    PrimaryResultCard(
                        title: "Conversion Result",
                        value: "\(convertedValue, specifier: "%.4f")",
                        subtitle: "\(inputValue) \(currentUnits[fromUnit]) = \(convertedValue, specifier: "%.4f") \(currentUnits[toUnit])",
                        color: .Theme.calculator5
                    )
                }
            }
            .padding(.Spacing.large)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Unit Converter")
        .navigationBarTitleDisplayModeCompat(.inline)
    }

    func swapUnits() {
        let temp = fromUnit
        fromUnit = toUnit
        toUnit = temp
    }

    func convertTemperature(_ value: Double, from: Int, to: Int) -> Double {
        // Convert to Celsius first
        var celsius: Double
        switch from {
        case 0: celsius = value // Already Celsius
        case 1: celsius = (value - 32) * 5/9 // Fahrenheit to Celsius
        case 2: celsius = value - 273.15 // Kelvin to Celsius
        default: celsius = 0
        }

        // Convert from Celsius to target unit
        switch to {
        case 0: return celsius
        case 1: return celsius * 9/5 + 32 // Celsius to Fahrenheit
        case 2: return celsius + 273.15 // Celsius to Kelvin
        default: return 0
        }
    }
}

#Preview {
    NavigationView {
        UnitConverter()
    }
}
