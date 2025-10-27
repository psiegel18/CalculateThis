//
//  MyCalculators.swift
//  CalculateThis
//
//  Manage user's custom calculators
//

import SwiftUI

struct MyCalculators: View {
    @EnvironmentObject var store: CalculatorStore
    @State private var showingBuilder = false
    @State private var editingCalculator: CustomCalculator?
    @State private var selectedCalculator: CustomCalculator?
    @State private var showingActionSheet = false

    var body: some View {
        Group {
            if store.myCalculators.isEmpty {
                emptyState
            } else {
                calculatorList
            }
        }
        .navigationTitle("My Calculators")
        .navigationBarTitleDisplayModeCompat(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingBuilder = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingBuilder) {
            CalculatorBuilder(calculator: editingCalculator)
                .onDisappear {
                    editingCalculator = nil
                }
        }
        .sheet(item: $selectedCalculator) { calculator in
            NavigationView {
                CustomCalculatorRunner(calculator: calculator)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") {
                                selectedCalculator = nil
                            }
                        }
                    }
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: .Spacing.large) {
            Spacer()

            Image(systemName: "plus.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.Theme.primary)

            VStack(spacing: .Spacing.small) {
                Text("No Custom Calculators")
                    .font(.Theme.headlineMedium)
                    .fontWeight(.bold)

                Text("Create your first calculator or browse the marketplace for inspiration")
                    .font(.Theme.bodyMedium)
                    .foregroundColor(.Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, .Spacing.xxlarge)

            VStack(spacing: .Spacing.small) {
                Button(action: { showingBuilder = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create Calculator")
                            .fontWeight(.semibold)
                    }
                }
                .primaryButtonStyle()
                .padding(.horizontal, .Spacing.xxlarge)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
    }

    // MARK: - Calculator List

    private var calculatorList: some View {
        ScrollView {
            LazyVStack(spacing: .Spacing.medium) {
                ForEach(store.myCalculators) { calculator in
                    MyCalculatorCard(
                        calculator: calculator,
                        onTap: {
                            selectedCalculator = calculator
                        },
                        onEdit: {
                            editingCalculator = calculator
                            showingBuilder = true
                        },
                        onDuplicate: {
                            _ = store.duplicateCalculator(calculator)
                        },
                        onPublish: {
                            publishCalculator(calculator)
                        },
                        onDelete: {
                            store.deleteCalculator(calculator)
                        }
                    )
                }
            }
            .padding(.Spacing.large)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    private func publishCalculator(_ calculator: CustomCalculator) {
        Task {
            do {
                try await store.publishCalculator(calculator)
            } catch {
                // Handle error
            }
        }
    }
}

// MARK: - My Calculator Card

struct MyCalculatorCard: View {
    let calculator: CustomCalculator
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDuplicate: () -> Void
    let onPublish: () -> Void
    let onDelete: () -> Void

    @State private var showingActions = false

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
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: .Spacing.medium) {
                HStack(spacing: .Spacing.medium) {
                    // Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: .CornerRadius.medium)
                            .fill(calculatorColor.opacity(0.15))
                            .frame(width: 56, height: 56)

                        Image(systemName: calculator.icon)
                            .font(.system(size: IconConfig.largeSize))
                            .foregroundColor(calculatorColor)
                    }

                    // Info
                    VStack(alignment: .leading, spacing: .Spacing.xxsmall) {
                        HStack(spacing: .Spacing.small) {
                            Text(calculator.name)
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)
                                .foregroundColor(.Theme.textPrimary)

                            if calculator.isPublished {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.Theme.success)
                            }
                        }

                        Text(calculator.description.isEmpty ? "No description" : calculator.description)
                            .font(.Theme.bodySmall)
                            .foregroundColor(.Theme.textSecondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    // Actions Menu
                    Button(action: { showingActions = true }) {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(calculatorColor)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                // Metadata
                HStack(spacing: .Spacing.large) {
                    Label("\(calculator.inputs.count)", systemImage: "arrow.down.square")
                        .font(.Theme.labelSmall)
                        .foregroundColor(.Theme.textSecondary)

                    Label("\(calculator.formulas.count)", systemImage: "function")
                        .font(.Theme.labelSmall)
                        .foregroundColor(.Theme.textSecondary)

                    Label("\(calculator.outputs.count)", systemImage: "arrow.up.square")
                        .font(.Theme.labelSmall)
                        .foregroundColor(.Theme.textSecondary)

                    Spacer()

                    Text(calculator.createdDate, style: .date)
                        .font(.Theme.caption)
                        .foregroundColor(.Theme.textTertiary)
                }
            }
            .padding(.Spacing.medium)
            .background(Color.Theme.cardBackground)
            .cornerRadius(.CornerRadius.large)
            .shadow(color: ShadowStyle.small.color, radius: ShadowStyle.small.radius, x: 0, y: ShadowStyle.small.y)
        }
        .buttonStyle(PlainButtonStyle())
        .confirmationDialog("Calculator Actions", isPresented: $showingActions, titleVisibility: .hidden) {
            Button("Run") { onTap() }
            Button("Edit") { onEdit() }
            Button("Duplicate") { onDuplicate() }
            if !calculator.isPublished {
                Button("Publish to Marketplace") { onPublish() }
            }
            Button("Delete", role: .destructive) { onDelete() }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    NavigationView {
        MyCalculators()
            .environmentObject(CalculatorStore())
    }
}
