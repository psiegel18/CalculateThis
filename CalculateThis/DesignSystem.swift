//
//  DesignSystem.swift
//  CalculateThis
//
//  Design system for consistent styling across the app
//

import SwiftUI

// MARK: - Colors
extension Color {
    struct Theme {
        // Primary Colors
        static let primary = Color.blue
        static let primaryLight = Color.blue.opacity(0.1)
        static let primaryMedium = Color.blue.opacity(0.2)

        // Accent Colors
        static let accent = Color.purple
        static let accentLight = Color.purple.opacity(0.1)

        // Semantic Colors
        static let success = Color.green
        static let successLight = Color.green.opacity(0.1)

        static let warning = Color.orange
        static let warningLight = Color.orange.opacity(0.1)

        static let error = Color.red
        static let errorLight = Color.red.opacity(0.1)

        static let info = Color.blue
        static let infoLight = Color.blue.opacity(0.1)

        // Neutral Colors
        static let cardBackground = Color.systemGray6
        static let secondaryBackground = Color(UIColor.secondarySystemBackground)
        static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)

        // Text Colors
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        static let textTertiary = Color(UIColor.tertiaryLabel)

        // Category Colors
        static let calculator1 = Color.blue
        static let calculator2 = Color.green
        static let calculator3 = Color.red
        static let calculator4 = Color.orange
        static let calculator5 = Color.purple
        static let calculator6 = Color.pink

        // Gradient Backgrounds
        static let primaryGradient = LinearGradient(
            colors: [Color.blue, Color.purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let accentGradient = LinearGradient(
            colors: [Color.purple, Color.pink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Typography
extension Font {
    struct Theme {
        // Display
        static let displayLarge = Font.system(size: 57, weight: .bold, design: .default)
        static let displayMedium = Font.system(size: 45, weight: .bold, design: .default)
        static let displaySmall = Font.system(size: 36, weight: .bold, design: .default)

        // Headline
        static let headlineLarge = Font.system(size: 32, weight: .semibold, design: .default)
        static let headlineMedium = Font.system(size: 28, weight: .semibold, design: .default)
        static let headlineSmall = Font.system(size: 24, weight: .semibold, design: .default)

        // Title
        static let titleLarge = Font.system(size: 22, weight: .medium, design: .default)
        static let titleMedium = Font.system(size: 18, weight: .medium, design: .default)
        static let titleSmall = Font.system(size: 16, weight: .medium, design: .default)

        // Body
        static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
        static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
        static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)

        // Label
        static let labelLarge = Font.system(size: 14, weight: .semibold, design: .default)
        static let labelMedium = Font.system(size: 12, weight: .semibold, design: .default)
        static let labelSmall = Font.system(size: 11, weight: .semibold, design: .default)

        // Caption
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        static let captionSmall = Font.system(size: 11, weight: .regular, design: .default)

        // Monospace (for calculations)
        static let monoLarge = Font.system(size: 16, weight: .regular, design: .monospaced)
        static let monoMedium = Font.system(size: 14, weight: .regular, design: .monospaced)
        static let monoSmall = Font.system(size: 12, weight: .regular, design: .monospaced)
    }
}

// MARK: - Spacing
extension CGFloat {
    struct Spacing {
        static let xxsmall: CGFloat = 4
        static let xsmall: CGFloat = 8
        static let small: CGFloat = 12
        static let medium: CGFloat = 16
        static let large: CGFloat = 20
        static let xlarge: CGFloat = 24
        static let xxlarge: CGFloat = 32
        static let xxxlarge: CGFloat = 40
    }
}

// MARK: - Corner Radius
extension CGFloat {
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 20
        static let full: CGFloat = 1000 // Creates pill shape
    }
}

// MARK: - Shadows
struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    static let small = ShadowStyle(
        color: Color.black.opacity(0.05),
        radius: 4,
        x: 0,
        y: 2
    )

    static let medium = ShadowStyle(
        color: Color.black.opacity(0.08),
        radius: 8,
        x: 0,
        y: 4
    )

    static let large = ShadowStyle(
        color: Color.black.opacity(0.12),
        radius: 16,
        x: 0,
        y: 8
    )
}

// MARK: - View Modifiers
extension View {
    /// Apply a card style with background, corner radius, and shadow
    func cardStyle(backgroundColor: Color = Color.Theme.cardBackground, shadow: ShadowStyle = .medium) -> some View {
        self
            .background(backgroundColor)
            .cornerRadius(.CornerRadius.large)
            .shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }

    /// Apply a primary button style
    func primaryButtonStyle() -> some View {
        self
            .font(.Theme.titleMedium)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.Spacing.medium)
            .background(Color.Theme.primary)
            .cornerRadius(.CornerRadius.medium)
    }

    /// Apply a secondary button style
    func secondaryButtonStyle() -> some View {
        self
            .font(.Theme.titleMedium)
            .foregroundColor(.Theme.primary)
            .frame(maxWidth: .infinity)
            .padding(.Spacing.medium)
            .background(Color.Theme.primaryLight)
            .cornerRadius(.CornerRadius.medium)
    }

    /// Apply a result card style with colored background
    func resultCardStyle(color: Color = .Theme.primary) -> some View {
        self
            .padding(.Spacing.large)
            .background(color.opacity(0.1))
            .cornerRadius(.CornerRadius.large)
            .overlay(
                RoundedRectangle(cornerRadius: .CornerRadius.large)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
    }

    /// Apply an input container style
    func inputContainerStyle() -> some View {
        self
            .padding(.Spacing.medium)
            .background(Color.Theme.cardBackground)
            .cornerRadius(.CornerRadius.medium)
    }
}

// MARK: - Icon Configuration
struct IconConfig {
    static let smallSize: CGFloat = 20
    static let mediumSize: CGFloat = 24
    static let largeSize: CGFloat = 32
    static let xlargeSize: CGFloat = 48
}

// MARK: - Animation Presets
extension Animation {
    static let theme = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let themeQuick = Animation.spring(response: 0.2, dampingFraction: 0.8)
    static let themeSlow = Animation.spring(response: 0.5, dampingFraction: 0.7)
}
