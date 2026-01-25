//
//  CalculatorBuilder.swift
//  CalculateThis
//
//  UI for creating and editing custom calculators
//

import SwiftUI

struct CalculatorBuilder: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: CalculatorStore

    @State private var calculator: CustomCalculator
    @State private var showingTemplates = false
    @State private var activeSheet: Sheet?

    private let isEditing: Bool

    enum Sheet: Identifiable {
        case addInput
        case editInput(CalculatorInput)
        case addFormula
        case editFormula(CalculatorFormula)
        case addOutput
        case editOutput(CalculatorOutput)
        case testCalculator

        var id: String {
            switch self {
            case .addInput: return "addInput"
            case .editInput(let input): return "editInput-\(input.id)"
            case .addFormula: return "addFormula"
            case .editFormula(let formula): return "editFormula-\(formula.id)"
            case .addOutput: return "addOutput"
            case .editOutput(let output): return "editOutput-\(output.id)"
            case .testCalculator: return "testCalculator"
            }
        }
    }

    init(calculator: CustomCalculator? = nil) {
        self.isEditing = calculator != nil
        _calculator = State(initialValue: calculator ?? CustomCalculator(
            name: "New Calculator",
            description: "",
            icon: "function",
            color: "blue",
            inputs: [],
            formulas: [],
            outputs: [],
            author: "You"
        ))
    }

    var body: some View {
        NavigationView {
            Form {
                // Basic Info
                Section("Calculator Info") {
                    TextField("Name", text: $calculator.name)
                        .font(.Theme.titleMedium)

                    TextField("Description", text: $calculator.description, axis: .vertical)
                        .lineLimit(3...6)

                    Picker("Category", selection: $calculator.category) {
                        ForEach(CustomCalculator.CalculatorCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }

                    HStack {
                        Text("Icon")
                        Spacer()
                        Image(systemName: calculator.icon)
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                        TextField("SF Symbol", text: $calculator.icon)
                            .multilineTextAlignment(.trailing)
                    }

                    Picker("Color", selection: $calculator.color) {
                        Text("Blue").tag("blue")
                        Text("Green").tag("green")
                        Text("Red").tag("red")
                        Text("Orange").tag("orange")
                        Text("Purple").tag("purple")
                        Text("Pink").tag("pink")
                    }
                }

                // Inputs Section
                Section {
                    ForEach(calculator.inputs) { input in
                        Button(action: { activeSheet = .editInput(input) }) {
                            HStack {
                                Image(systemName: input.type.icon)
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(input.label)
                                        .font(.headline)
                                    Text("\(input.type.rawValue) - \(input.name)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    .onDelete { indexSet in
                        calculator.inputs.remove(atOffsets: indexSet)
                    }

                    Button(action: { activeSheet = .addInput }) {
                        Label("Add Input", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Inputs (\(calculator.inputs.count))")
                } footer: {
                    Text("Define what values users will enter")
                }

                // Formulas Section
                Section {
                    ForEach(calculator.formulas) { formula in
                        Button(action: { activeSheet = .editFormula(formula) }) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(formula.name)
                                        .font(.headline)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Text(formula.expression)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    .onDelete { indexSet in
                        calculator.formulas.remove(atOffsets: indexSet)
                    }

                    Button(action: { activeSheet = .addFormula }) {
                        Label("Add Formula", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Formulas (\(calculator.formulas.count))")
                } footer: {
                    Text("Define calculations using input names")
                }

                // Outputs Section
                Section {
                    ForEach(calculator.outputs) { output in
                        Button(action: { activeSheet = .editOutput(output) }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(output.label)
                                        .font(.headline)
                                    Text("Formula: \(output.formulaName)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(output.format.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    .onDelete { indexSet in
                        calculator.outputs.remove(atOffsets: indexSet)
                    }

                    Button(action: { activeSheet = .addOutput }) {
                        Label("Add Output", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Outputs (\(calculator.outputs.count))")
                } footer: {
                    Text("Display formula results to users")
                }

                // Actions
                Section {
                    Button(action: { activeSheet = .testCalculator }) {
                        Label("Test Calculator", systemImage: "play.fill")
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Calculator" : "New Calculator")
            .navigationBarTitleDisplayModeCompat(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCalculator()
                    }
                    .disabled(!isValid)
                }
            }
            .sheet(item: $activeSheet) { sheet in
                sheetContent(for: sheet)
            }
        }
    }

    @ViewBuilder
    private func sheetContent(for sheet: Sheet) -> some View {
        switch sheet {
        case .addInput:
            InputEditor(input: nil) { input in
                calculator.inputs.append(input)
            }
        case .editInput(let input):
            InputEditor(input: input) { updated in
                if let index = calculator.inputs.firstIndex(where: { $0.id == input.id }) {
                    calculator.inputs[index] = updated
                }
            }
        case .addFormula:
            FormulaEditor(formula: nil, availableInputs: calculator.inputs, availableFormulas: calculator.formulas) { formula in
                calculator.formulas.append(formula)
            }
        case .editFormula(let formula):
            FormulaEditor(formula: formula, availableInputs: calculator.inputs, availableFormulas: calculator.formulas) { updated in
                if let index = calculator.formulas.firstIndex(where: { $0.id == formula.id }) {
                    calculator.formulas[index] = updated
                }
            }
        case .addOutput:
            OutputEditor(output: nil, availableFormulas: calculator.formulas) { output in
                calculator.outputs.append(output)
            }
        case .editOutput(let output):
            OutputEditor(output: output, availableFormulas: calculator.formulas) { updated in
                if let index = calculator.outputs.firstIndex(where: { $0.id == output.id }) {
                    calculator.outputs[index] = updated
                }
            }
        case .testCalculator:
            NavigationView {
                CustomCalculatorRunner(calculator: calculator)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") {
                                activeSheet = nil
                            }
                        }
                    }
            }
        }
    }

    private var isValid: Bool {
        !calculator.name.isEmpty &&
        !calculator.inputs.isEmpty &&
        !calculator.formulas.isEmpty &&
        !calculator.outputs.isEmpty
    }

    private func saveCalculator() {
        store.saveCalculator(calculator)
        dismiss()
    }
}

// MARK: - Input Editor

struct InputEditor: View {
    @Environment(\.dismiss) var dismiss
    @State private var input: CalculatorInput
    let onSave: (CalculatorInput) -> Void

    init(input: CalculatorInput?, onSave: @escaping (CalculatorInput) -> Void) {
        _input = State(initialValue: input ?? CalculatorInput(
            name: "",
            label: "",
            type: .decimal
        ))
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Basic Info") {
                    TextField("Variable Name (e.g., price)", text: $input.name)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    TextField("Label", text: $input.label)
                    Picker("Type", selection: $input.type) {
                        ForEach(CalculatorInput.InputType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.icon).tag(type)
                        }
                    }
                }

                Section("Options") {
                    TextField("Default Value", text: $input.defaultValue)
                    TextField("Placeholder", text: Binding(
                        get: { input.placeholder ?? "" },
                        set: { input.placeholder = $0.isEmpty ? nil : $0 }
                    ))
                    TextField("Unit (optional)", text: Binding(
                        get: { input.unit ?? "" },
                        set: { input.unit = $0.isEmpty ? nil : $0 }
                    ))
                }

                if input.type == .slider {
                    Section("Slider Settings") {
                        HStack {
                            Text("Min Value")
                            Spacer()
                            TextField("0", value: Binding(
                                get: { input.minValue ?? 0 },
                                set: { input.minValue = $0 }
                            ), format: .number)
                            .keyboardTypeCompat(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        }
                        HStack {
                            Text("Max Value")
                            Spacer()
                            TextField("100", value: Binding(
                                get: { input.maxValue ?? 100 },
                                set: { input.maxValue = $0 }
                            ), format: .number)
                            .keyboardTypeCompat(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        }
                        HStack {
                            Text("Step")
                            Spacer()
                            TextField("1", value: Binding(
                                get: { input.step ?? 1 },
                                set: { input.step = $0 }
                            ), format: .number)
                            .keyboardTypeCompat(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        }
                    }
                }
            }
            .navigationTitle("Input Field")
            .navigationBarTitleDisplayModeCompat(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onSave(input)
                        dismiss()
                    }
                    .disabled(input.name.isEmpty || input.label.isEmpty)
                }
            }
        }
    }
}

// MARK: - Formula Editor

struct FormulaEditor: View {
    @Environment(\.dismiss) var dismiss
    @State private var formula: CalculatorFormula
    let availableInputs: [CalculatorInput]
    let availableFormulas: [CalculatorFormula]
    let onSave: (CalculatorFormula) -> Void

    init(formula: CalculatorFormula?, availableInputs: [CalculatorInput], availableFormulas: [CalculatorFormula], onSave: @escaping (CalculatorFormula) -> Void) {
        _formula = State(initialValue: formula ?? CalculatorFormula(
            name: "",
            expression: ""
        ))
        self.availableInputs = availableInputs
        self.availableFormulas = availableFormulas
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Variable Name (e.g., total)", text: $formula.name)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    TextField("Description (optional)", text: Binding(
                        get: { formula.description ?? "" },
                        set: { formula.description = $0.isEmpty ? nil : $0 }
                    ))
                }

                Section {
                    TextEditor(text: $formula.expression)
                        .font(.system(.body, design: .monospaced))
                        .frame(minHeight: 100)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } header: {
                    Text("Expression")
                } footer: {
                    Text("Use input names and math operators: +, -, *, /, ^, sqrt(), abs(), etc.")
                }

                Section("Available Variables") {
                    if !availableInputs.isEmpty {
                        ForEach(availableInputs) { input in
                            Button(action: { insertVariable(input.name) }) {
                                HStack {
                                    Text(input.name)
                                        .font(.system(.body, design: .monospaced))
                                    Spacer()
                                    Text(input.label)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    } else {
                        Text("No inputs defined yet")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Math Functions") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(["sqrt()", "abs()", "pow(,)", "min(,)", "max()", "round()", "sin()", "cos()"], id: \.self) { func_ in
                                Button(func_) {
                                    insertFunction(func_)
                                }
                                .font(.system(.caption, design: .monospaced))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Formula")
            .navigationBarTitleDisplayModeCompat(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onSave(formula)
                        dismiss()
                    }
                    .disabled(formula.name.isEmpty || formula.expression.isEmpty)
                }
            }
        }
    }

    private func insertVariable(_ name: String) {
        formula.expression += name
    }

    private func insertFunction(_ function: String) {
        formula.expression += function
    }
}

// MARK: - Output Editor

struct OutputEditor: View {
    @Environment(\.dismiss) var dismiss
    @State private var output: CalculatorOutput
    let availableFormulas: [CalculatorFormula]
    let onSave: (CalculatorOutput) -> Void

    init(output: CalculatorOutput?, availableFormulas: [CalculatorFormula], onSave: @escaping (CalculatorOutput) -> Void) {
        _output = State(initialValue: output ?? CalculatorOutput(
            label: "",
            formulaName: availableFormulas.first?.name ?? "",
            format: .decimal2
        ))
        self.availableFormulas = availableFormulas
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Basic Info") {
                    TextField("Label", text: $output.label)
                    Picker("Formula", selection: $output.formulaName) {
                        ForEach(availableFormulas, id: \.name) { formula in
                            Text(formula.name).tag(formula.name)
                        }
                    }
                    Picker("Format", selection: $output.format) {
                        ForEach(CalculatorOutput.OutputFormat.allCases, id: \.self) { format in
                            Text(format.rawValue).tag(format)
                        }
                    }
                }

                Section("Options") {
                    TextField("Unit (optional)", text: Binding(
                        get: { output.unit ?? "" },
                        set: { output.unit = $0.isEmpty ? nil : $0 }
                    ))
                    Toggle("Show in Results", isOn: $output.showInResult)
                }
            }
            .navigationTitle("Output")
            .navigationBarTitleDisplayModeCompat(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onSave(output)
                        dismiss()
                    }
                    .disabled(output.label.isEmpty)
                }
            }
        }
    }
}

#Preview {
    CalculatorBuilder()
        .environmentObject(CalculatorStore())
}
