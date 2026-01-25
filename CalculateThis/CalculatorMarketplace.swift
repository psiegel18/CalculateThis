//
//  CalculatorMarketplace.swift
//  CalculateThis
//
//  Browse and download community-created calculators
//

import SwiftUI

struct CalculatorMarketplace: View {
    @EnvironmentObject var store: CalculatorStore
    @State private var searchText = ""
    @State private var selectedCategory: CustomCalculator.CalculatorCategory?
    @State private var selectedCalculator: CustomCalculator?
    @State private var showingDetail = false

    private var filteredCalculators: [CustomCalculator] {
        var calculators = store.marketplaceCalculators

        // Filter by search
        if !searchText.isEmpty {
            calculators = calculators.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Filter by category
        if let category = selectedCategory {
            calculators = calculators.filter { $0.category == category }
        }

        return calculators.sorted { $0.downloads > $1.downloads }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: .Spacing.large) {
                // Header
                VStack(alignment: .leading, spacing: .Spacing.small) {
                    Text("Calculator Marketplace")
                        .font(.Theme.displayMedium)
                        .fontWeight(.bold)

                    Text("Discover calculators created by the community")
                        .font(.Theme.bodyLarge)
                        .foregroundColor(.Theme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, .Spacing.large)

                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.Theme.textSecondary)
                    TextField("Search calculators...", text: $searchText)
                        .textInputAutocapitalization(.never)
                }
                .padding(.Spacing.medium)
                .background(Color.Theme.cardBackground)
                .cornerRadius(.CornerRadius.medium)
                .padding(.horizontal, .Spacing.large)

                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: .Spacing.small) {
                        CategoryChip(
                            title: "All",
                            icon: "square.grid.2x2",
                            isSelected: selectedCategory == nil
                        ) {
                            selectedCategory = nil
                        }

                        ForEach(CustomCalculator.CalculatorCategory.allCases, id: \.self) { category in
                            CategoryChip(
                                title: category.rawValue,
                                icon: category.icon,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, .Spacing.large)
                }

                // Calculator Grid
                if filteredCalculators.isEmpty {
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "No Calculators Found",
                        message: "Try adjusting your search or filters"
                    )
                    .padding(.top, .Spacing.xxlarge)
                } else {
                    LazyVStack(spacing: .Spacing.medium) {
                        ForEach(filteredCalculators) { calculator in
                            MarketplaceCalculatorCard(calculator: calculator) {
                                selectedCalculator = calculator
                                showingDetail = true
                            }
                        }
                    }
                    .padding(.horizontal, .Spacing.large)
                }
            }
            .padding(.vertical, .Spacing.large)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Marketplace")
        .navigationBarTitleDisplayModeCompat(.inline)
        .sheet(isPresented: $showingDetail) {
            if let calculator = selectedCalculator {
                CalculatorDetailSheet(calculator: calculator)
            }
        }
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: .Spacing.xxsmall) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(title)
                    .font(.Theme.labelLarge)
            }
            .foregroundColor(isSelected ? .white : .Theme.primary)
            .padding(.horizontal, .Spacing.medium)
            .padding(.vertical, .Spacing.small)
            .background(isSelected ? Color.Theme.primary : Color.Theme.primaryLight)
            .cornerRadius(.CornerRadius.full)
        }
    }
}

// MARK: - Marketplace Calculator Card

struct MarketplaceCalculatorCard: View {
    let calculator: CustomCalculator
    let action: () -> Void

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
        Button(action: action) {
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
                        Text(calculator.name)
                            .font(.Theme.titleMedium)
                            .fontWeight(.semibold)
                            .foregroundColor(.Theme.textPrimary)

                        Text(calculator.description)
                            .font(.Theme.bodySmall)
                            .foregroundColor(.Theme.textSecondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.Theme.textTertiary)
                }

                // Metadata
                HStack(spacing: .Spacing.large) {
                    HStack(spacing: .Spacing.xxsmall) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", calculator.rating))
                            .font(.Theme.labelSmall)
                            .foregroundColor(.Theme.textSecondary)
                        Text("(\(calculator.ratingCount))")
                            .font(.Theme.labelSmall)
                            .foregroundColor(.Theme.textTertiary)
                    }

                    HStack(spacing: .Spacing.xxsmall) {
                        Image(systemName: "arrow.down.circle")
                            .font(.system(size: 12))
                        Text("\(calculator.downloads)")
                            .font(.Theme.labelSmall)
                            .foregroundColor(.Theme.textSecondary)
                    }

                    Spacer()

                    Badge(text: calculator.category.rawValue, color: calculatorColor)
                }
            }
            .padding(.Spacing.medium)
            .background(Color.Theme.cardBackground)
            .cornerRadius(.CornerRadius.large)
            .shadow(color: ShadowStyle.small.color, radius: ShadowStyle.small.radius, x: 0, y: ShadowStyle.small.y)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Calculator Detail Sheet

struct CalculatorDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: CalculatorStore
    @State private var showingRunner = false
    @State private var isDownloading = false

    let calculator: CustomCalculator

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
        NavigationView {
            ScrollView {
                VStack(spacing: .Spacing.large) {
                    // Header
                    VStack(spacing: .Spacing.medium) {
                        ZStack {
                            Circle()
                                .fill(calculatorColor.opacity(0.15))
                                .frame(width: 80, height: 80)

                            Image(systemName: calculator.icon)
                                .font(.system(size: 40))
                                .foregroundColor(calculatorColor)
                        }

                        Text(calculator.name)
                            .font(.Theme.headlineLarge)
                            .fontWeight(.bold)

                        Text(calculator.description)
                            .font(.Theme.bodyMedium)
                            .foregroundColor(.Theme.textSecondary)
                            .multilineTextAlignment(.center)

                        // Stats
                        HStack(spacing: .Spacing.xlarge) {
                            VStack(spacing: .Spacing.xxsmall) {
                                HStack(spacing: .Spacing.xxsmall) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(String(format: "%.1f", calculator.rating))
                                        .fontWeight(.semibold)
                                }
                                Text("\(calculator.ratingCount) ratings")
                                    .font(.Theme.caption)
                                    .foregroundColor(.Theme.textSecondary)
                            }

                            VStack(spacing: .Spacing.xxsmall) {
                                HStack(spacing: .Spacing.xxsmall) {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .foregroundColor(calculatorColor)
                                    Text("\(calculator.downloads)")
                                        .fontWeight(.semibold)
                                }
                                Text("downloads")
                                    .font(.Theme.caption)
                                    .foregroundColor(.Theme.textSecondary)
                            }
                        }
                    }
                    .padding(.top, .Spacing.large)

                    // Author Info
                    CardContainer {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.Theme.textSecondary)

                            VStack(alignment: .leading, spacing: .Spacing.xxsmall) {
                                Text("Created by")
                                    .font(.Theme.labelSmall)
                                    .foregroundColor(.Theme.textSecondary)
                                Text(calculator.author)
                                    .font(.Theme.titleSmall)
                                    .fontWeight(.semibold)
                            }

                            Spacer()

                            Badge(text: calculator.category.rawValue, color: calculatorColor)
                        }
                    }

                    // Details
                    CardContainer {
                        VStack(alignment: .leading, spacing: .Spacing.medium) {
                            Text("Calculator Details")
                                .font(.Theme.titleMedium)
                                .fontWeight(.semibold)

                            InfoRow(
                                label: "Inputs",
                                value: "\(calculator.inputs.count)",
                                icon: "arrow.down.square"
                            )
                            ThemedDivider()
                            InfoRow(
                                label: "Formulas",
                                value: "\(calculator.formulas.count)",
                                icon: "function"
                            )
                            ThemedDivider()
                            InfoRow(
                                label: "Outputs",
                                value: "\(calculator.outputs.count)",
                                icon: "arrow.up.square"
                            )
                            ThemedDivider()
                            InfoRow(
                                label: "Version",
                                value: calculator.version,
                                icon: "number"
                            )
                        }
                    }

                    // Action Buttons
                    VStack(spacing: .Spacing.small) {
                        Button(action: { showingRunner = true }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Try Calculator")
                                    .fontWeight(.semibold)
                            }
                        }
                        .primaryButtonStyle()

                        Button(action: downloadCalculator) {
                            HStack {
                                if isDownloading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .Theme.primary))
                                } else {
                                    Image(systemName: "arrow.down.circle.fill")
                                    Text("Download & Save")
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                        .secondaryButtonStyle()
                        .disabled(isDownloading)
                    }
                }
                .padding(.Spacing.large)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitleDisplayModeCompat(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingRunner) {
                NavigationView {
                    CustomCalculatorRunner(calculator: calculator)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Done") {
                                    showingRunner = false
                                }
                            }
                        }
                }
            }
        }
    }

    private func downloadCalculator() {
        isDownloading = true
        Task {
            do {
                try await store.downloadCalculator(calculator)
                await MainActor.run {
                    isDownloading = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isDownloading = false
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        CalculatorMarketplace()
            .environmentObject(CalculatorStore())
    }
}
