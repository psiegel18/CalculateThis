//
//  UIComponents.swift
//  CalculateThis
//
//  Reusable UI components for consistent design
//

import SwiftUI

// MARK: - Input Components

/// A styled text field with label
struct ThemedTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: .Spacing.xsmall) {
            Text(label)
                .font(.Theme.labelLarge)
                .foregroundColor(.Theme.textSecondary)

            TextField(placeholder, text: $text)
                .font(.Theme.titleLarge)
                .keyboardTypeCompat(keyboardType)
                .padding(.Spacing.small)
                .background(Color.Theme.secondaryBackground)
                .cornerRadius(.CornerRadius.small)
        }
        .padding(.Spacing.medium)
        .background(Color.Theme.cardBackground)
        .cornerRadius(.CornerRadius.medium)
    }
}

/// A styled number input with label
struct NumberInputField: View {
    let label: String
    let placeholder: String
    @Binding var value: String
    var unit: String?

    var body: some View {
        VStack(alignment: .leading, spacing: .Spacing.xsmall) {
            Text(label)
                .font(.Theme.labelLarge)
                .foregroundColor(.Theme.textSecondary)

            HStack {
                TextField(placeholder, text: $value)
                    .font(.Theme.titleLarge)
                    .keyboardTypeCompat(.decimalPad)

                if let unit = unit {
                    Text(unit)
                        .font(.Theme.titleSmall)
                        .foregroundColor(.Theme.textTertiary)
                }
            }
            .padding(.Spacing.small)
            .background(Color.Theme.secondaryBackground)
            .cornerRadius(.CornerRadius.small)
        }
        .padding(.Spacing.medium)
        .background(Color.Theme.cardBackground)
        .cornerRadius(.CornerRadius.medium)
    }
}

// MARK: - Result Components

/// A card displaying a result with label and value
struct ResultCard: View {
    let label: String
    let value: String
    var color: Color = .Theme.primary
    var icon: String?

    var body: some View {
        HStack(spacing: .Spacing.medium) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: IconConfig.largeSize))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: .Spacing.xxsmall) {
                Text(label)
                    .font(.Theme.labelMedium)
                    .foregroundColor(.Theme.textSecondary)

                Text(value)
                    .font(.Theme.headlineSmall)
                    .foregroundColor(.Theme.textPrimary)
                    .fontWeight(.semibold)
            }

            Spacer()
        }
        .padding(.Spacing.large)
        .background(color.opacity(0.1))
        .cornerRadius(.CornerRadius.large)
        .overlay(
            RoundedRectangle(cornerRadius: .CornerRadius.large)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

/// A prominent result display for main calculations
struct PrimaryResultCard: View {
    let title: String
    let value: String
    let subtitle: String?
    var color: Color = .Theme.primary

    init(title: String, value: String, subtitle: String? = nil, color: Color = .Theme.primary) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.color = color
    }

    var body: some View {
        VStack(spacing: .Spacing.small) {
            Text(title)
                .font(.Theme.labelLarge)
                .foregroundColor(.Theme.textSecondary)

            Text(value)
                .font(.Theme.displaySmall)
                .foregroundColor(color)
                .fontWeight(.bold)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.Theme.bodySmall)
                    .foregroundColor(.Theme.textTertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.Spacing.xlarge)
        .background(
            RoundedRectangle(cornerRadius: .CornerRadius.large)
                .fill(color.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: .CornerRadius.large)
                .stroke(color.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: color.opacity(0.1), radius: 12, x: 0, y: 4)
    }
}

/// A row displaying label and value
struct InfoRow: View {
    let label: String
    let value: String
    var icon: String?

    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: IconConfig.smallSize))
                    .foregroundColor(.Theme.textTertiary)
                    .frame(width: 24)
            }

            Text(label)
                .font(.Theme.bodyMedium)
                .foregroundColor(.Theme.textSecondary)

            Spacer()

            Text(value)
                .font(.Theme.bodyMedium)
                .foregroundColor(.Theme.textPrimary)
                .fontWeight(.semibold)
        }
        .padding(.vertical, .Spacing.xsmall)
    }
}

// MARK: - Button Components

/// A primary action button
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: .Spacing.small) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: IconConfig.mediumSize))
                }
                Text(title)
                    .font(.Theme.titleMedium)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.Spacing.medium)
            .background(Color.Theme.primary)
            .cornerRadius(.CornerRadius.medium)
            .shadow(color: Color.Theme.primary.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

/// A secondary action button
struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: .Spacing.small) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: IconConfig.mediumSize))
                }
                Text(title)
                    .font(.Theme.titleMedium)
            }
            .foregroundColor(.Theme.primary)
            .frame(maxWidth: .infinity)
            .padding(.Spacing.medium)
            .background(Color.Theme.primaryLight)
            .cornerRadius(.CornerRadius.medium)
        }
    }
}

/// A quick action button (e.g., for tip percentages)
struct QuickActionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.Theme.titleSmall)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : .Theme.primary)
                .padding(.horizontal, .Spacing.large)
                .padding(.vertical, .Spacing.small)
                .background(isSelected ? Color.Theme.primary : Color.Theme.primaryLight)
                .cornerRadius(.CornerRadius.full)
                .overlay(
                    RoundedRectangle(cornerRadius: .CornerRadius.full)
                        .stroke(Color.Theme.primary.opacity(isSelected ? 0 : 0.3), lineWidth: 1)
                )
        }
        .animation(.theme, value: isSelected)
    }
}

// MARK: - Section Components

/// A section container with title
struct SectionContainer<Content: View>: View {
    let title: String
    let icon: String?
    let content: Content

    init(_ title: String, icon: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .Spacing.medium) {
            HStack(spacing: .Spacing.small) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: IconConfig.mediumSize))
                        .foregroundColor(.Theme.primary)
                }

                Text(title)
                    .font(.Theme.titleLarge)
                    .fontWeight(.semibold)
            }

            content
        }
    }
}

/// A card container for grouping content
struct CardContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: .Spacing.medium) {
            content
        }
        .padding(.Spacing.large)
        .background(Color.Theme.cardBackground)
        .cornerRadius(.CornerRadius.large)
        .shadow(color: ShadowStyle.medium.color, radius: ShadowStyle.medium.radius, x: 0, y: ShadowStyle.medium.y)
    }
}

// MARK: - Divider

/// A themed divider
struct ThemedDivider: View {
    var body: some View {
        Divider()
            .background(Color.Theme.textTertiary.opacity(0.3))
    }
}

// MARK: - Empty State

/// An empty state view
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: .Spacing.large) {
            Image(systemName: icon)
                .font(.system(size: IconConfig.xlargeSize))
                .foregroundColor(.Theme.textTertiary)

            VStack(spacing: .Spacing.xsmall) {
                Text(title)
                    .font(.Theme.titleLarge)
                    .fontWeight(.semibold)

                Text(message)
                    .font(.Theme.bodyMedium)
                    .foregroundColor(.Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.Spacing.xxlarge)
    }
}

// MARK: - Badges

/// A badge for displaying status or categories
struct Badge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.Theme.labelSmall)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, .Spacing.small)
            .padding(.vertical, .Spacing.xxsmall)
            .background(color)
            .cornerRadius(.CornerRadius.small)
    }
}
