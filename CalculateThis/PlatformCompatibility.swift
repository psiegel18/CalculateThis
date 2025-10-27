import SwiftUI

// MARK: - Cross-Platform Extensions

extension Color {
    static var systemGray6: Color {
        #if os(iOS)
        return Color(UIColor.systemGray6)
        #else
        return Color(NSColor.controlBackgroundColor)
        #endif
    }
}

extension View {
    func keyboardTypeCompat(_ type: KeyboardType) -> some View {
        #if os(iOS)
        return self.keyboardType(type.uiKitType)
        #else
        return self
        #endif
    }
    
    func navigationBarTitleDisplayModeCompat(_ mode: NavigationBarTitleDisplayMode) -> some View {
        #if os(iOS)
        return self.navigationBarTitleDisplayMode(mode.uiKitMode)
        #else
        return self
        #endif
    }
}

extension NavigationView {
    func navigationViewStyleCompat() -> some View {
        #if os(iOS)
        return self.navigationViewStyle(StackNavigationViewStyle())
        #else
        return self
        #endif
    }
}

// MARK: - Platform-Specific Types

enum KeyboardType {
    case `default`
    case decimalPad
    case numberPad
    
    #if os(iOS)
    var uiKitType: UIKeyboardType {
        switch self {
        case .default: return .default
        case .decimalPad: return .decimalPad
        case .numberPad: return .numberPad
        }
    }
    #endif
}

enum NavigationBarTitleDisplayMode {
    case automatic
    case inline
    case large
    
    #if os(iOS)
    var uiKitMode: SwiftUI.NavigationBarTitleDisplayMode {
        switch self {
        case .automatic: return .automatic
        case .inline: return .inline
        case .large: return .large
        }
    }
    #endif
}