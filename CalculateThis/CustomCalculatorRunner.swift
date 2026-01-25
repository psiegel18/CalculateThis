//
//  CustomCalculatorRunner.swift
//  CalculateThis
//
//  Dynamic UI for running custom user-created calculators
//

import SwiftUI

struct CustomCalculatorRunner: View {
    let calculator: CustomCalculator
    @State private var inputValues: [String: String] = [:]
    @State private var results: [String: Double] = [:]
    @State private var errorMessage: String?

    private var calculatorColor: Color {
        switch calculator.color {
        case "blue": return .Theme.calculator1
        case "green": return .Theme.calculator2
        case "red": return .Theme.calculator3
        case "orange": return .Theme.calculator4
        case "purple": return .Theme.calculator5
        case "pink": return .Theme.calculator6
        default: return .Theme.primary
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: .Spacing.large) {
                // Calculator Info
                CardContainer {
                    HStack(spacing: .Spacing.medium) {
                        ZStack {
                            RoundedRectangle(cornerRadius: .CornerRadius.medium)
                                .fill(calculatorColor.opacity(0.15))
                                .frame(width: 56, height: 56)

                            Image(systemName: calculator.icon)
                                .font(.system(size: IconConfig.largeSize))
                                .foregroundColor(calculatorColor)
                        }

                        VStack(alignment: .leading, spacing: .Spacing.xxsmall) {
                            Text(calculator.name)
                                .font(.Theme.titleLarge)
                                .fontWeight(.bold)

                            Text(calculator.description)
                                .font(.Theme.bodySmall)
                                .foregroundColor(.Theme.textSecondary)
                        }

                        Spacer()
                    }
                }

                // Inputs
                ForEach(calculator.inputs) { input in
                    buildInputView(for: input)
                }

                // Calculate Button
                Button(action: calculateResults) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Calculate")
                            .fontWeight(.semibold)
                    }
                }
                .primaryButtonStyle()

                // Error Message
                if let error = errorMessage {
                    CardContainer {
                        HStack(spacing: .Spacing.small) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.Theme.error)
                            Text(error)
                                .font(.Theme.bodySmall)
                                .foregroundColor(.Theme.error)
                        }
                    }
                }

                // Results
                if !results.isEmpty {
                    ForEach(calculator.outputs.filter { $0.showInResult }) { output in
                        if let result = results[output.formulaName] {
                            buildResultView(for: output, value: result)
                        }
                    }
                }
            }
            .padding(.Spacing.large)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle(calculator.name)
        .navigationBarTitleDisplayModeCompat(.inline)
        .onAppear {
            initializeInputValues()
        }
    }

    // MARK: - Input Views

    @ViewBuilder
    private func buildInputView(for input: CalculatorInput) -> some View {
        CardContainer {
            VStack(alignment: .leading, spacing: .Spacing.medium) {
                HStack {
                    Image(systemName: input.type.icon)
                        .font(.system(size: IconConfig.mediumSize))
                        .foregroundColor(calculatorColor)
                    Text(input.label)
                        .font(.Theme.titleMedium)
                        .fontWeight(.semibold)
                    if let unit = input.unit {
                        Text("(\(unit))")
                            .font(.Theme.bodySmall)
                            .foregroundColor(.Theme.textSecondary)
                    }
                }

                switch input.type {
                case .number, .decimal:
                    TextField(input.placeholder ?? "Enter value", text: Binding(
                        get: { inputValues[input.name] ?? input.defaultValue },
                        set: { inputValues[input.name] = $0 }
                    ))
                    .keyboardTypeCompat(input.type == .number ? .numberPad : .decimalPad)
                    .font(.Theme.displaySmall)
                    .fontWeight(.bold)
                    .padding(.Spacing.medium)
                    .background(Color.Theme.secondaryBackground)
                    .cornerRadius(.CornerRadius.medium)

                case .text:
                    TextField(input.placeholder ?? "Enter text", text: Binding(
                        get: { inputValues[input.name] ?? input.defaultValue },
                        set: { inputValues[input.name] = $0 }
                    ))
                    .font(.Theme.titleLarge)
                    .padding(.Spacing.medium)
                    .background(Color.Theme.secondaryBackground)
                    .cornerRadius(.CornerRadius.medium)

                case .slider:
                    VStack(spacing: .Spacing.small) {
                        HStack {
                            Text(inputValues[input.name] ?? input.defaultValue)
                                .font(.Theme.headlineSmall)
                                .fontWeight(.bold)
                                .foregroundColor(calculatorColor)
                            Spacer()
                        }

                        Slider(
                            value: Binding(
                                get: { Double(inputValues[input.name] ?? input.defaultValue) ?? 0 },
                                set: { inputValues[input.name] = String(format: "%.1f", $0) }
                            ),
                            in: (input.minValue ?? 0)...(input.maxValue ?? 100),
                            step: input.step ?? 1
                        )
                        .accentColor(calculatorColor)

                        HStack {
                            Text("\(input.minValue ?? 0, specifier: "%.0f")")
                                .font(.Theme.caption)
                                .foregroundColor(.Theme.textTertiary)
                            Spacer()
                            Text("\(input.maxValue ?? 100, specifier: "%.0f")")
                                .font(.Theme.caption)
                                .foregroundColor(.Theme.textTertiary)
                        }
                    }

                case .toggle:
                    Toggle("", isOn: Binding(
                        get: { (inputValues[input.name] ?? input.defaultValue) == "true" },
                        set: { inputValues[input.name] = $0 ? "true" : "false" }
                    ))
                    .labelsHidden()

                case .date:
                    DatePicker("", selection: Binding(
                        get: { Date() }, // Would need proper date parsing
                        set: { _ in }
                    ), displayedComponents: .date)
                    .datePickerStyle(.compact)

                case .picker:
                    // Would need picker options in the model
                    Text("Picker not implemented yet")
                        .font(.Theme.bodySmall)
                        .foregroundColor(.Theme.textSecondary)
                }
            }
        }
    }

    // MARK: - Result Views

    @ViewBuilder
    private func buildResultView(for output: CalculatorOutput, value: Double) -> some View {
        if calculator.outputs.first(where: { $0.showInResult })?.id == output.id {
            // Primary result - first output
            PrimaryResultCard(
                title: output.label,
                value: output.format.format(value),
                subtitle: output.unit,
                color: calculatorColor
            )
        } else {
            // Secondary results
            ResultCard(
                label: output.label,
                value: output.format.format(value),
                color: calculatorColor,
                icon: "checkmark.circle.fill"
            )
        }
    }

    // MARK: - Calculation

    private func initializeInputValues() {
        for input in calculator.inputs {
            if inputValues[input.name] == nil {
                inputValues[input.name] = input.defaultValue
            }
        }
    }

    private func calculateResults() {
        errorMessage = nil
        results.removeAll()

        let evaluator = ExpressionEvaluator()

        // Set all input variables
        for input in calculator.inputs {
            let valueString = inputValues[input.name] ?? input.defaultValue
            if let value = Double(valueString) {
                evaluator.setVariable(input.name, value: value)
            } else if valueString == "true" {
                evaluator.setVariable(input.name, value: 1.0)
            } else if valueString == "false" {
                evaluator.setVariable(input.name, value: 0.0)
            }
        }

        // Evaluate all formulas in order
        do {
            for formula in calculator.formulas {
                let result = try evaluator.evaluate(formula.expression)
                results[formula.name] = result
                // Make formula results available for subsequent formulas
                evaluator.setVariable(formula.name, value: result)
            }
        } catch let error as ExpressionEvaluator.EvaluationError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Calculation error: \(error.localizedDescription)"
        }
    }
}

#Preview {
    NavigationView {
        CustomCalculatorRunner(calculator: CustomCalculator.templates[0])
    }
}
