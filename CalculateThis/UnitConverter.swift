import SwiftUI

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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Category Selector
                Picker("Category", selection: $category) {
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
                
                // Input Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("From")
                        .font(.headline)
                    
                    TextField("Enter value", text: $inputValue)
                        .keyboardTypeCompat(.decimalPad)
                        .font(.title2)
                        .padding()
                        .background(Color.systemGray6)
                        .cornerRadius(10)
                    
                    Picker("From Unit", selection: $fromUnit) {
                        ForEach(0..<currentUnits.count, id: \.self) { index in
                            Text(currentUnits[index]).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Swap Button
                Button(action: swapUnits) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                
                // Output Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("To")
                        .font(.headline)
                    
                    Text(inputValue.isEmpty ? "0" : String(format: "%.4f", convertedValue))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    
                    Picker("To Unit", selection: $toUnit) {
                        ForEach(0..<currentUnits.count, id: \.self) { index in
                            Text(currentUnits[index]).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Conversion Summary
                if !inputValue.isEmpty {
                    VStack(spacing: 10) {
                        Text("Conversion")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("\(inputValue) \(currentUnits[fromUnit]) =")
                            .font(.body)
                        
                        Text("\(convertedValue, specifier: "%.4f") \(currentUnits[toUnit])")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.systemGray6)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
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
