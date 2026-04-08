import SwiftUI

enum KaelGhueauTheme {
    enum KaelColor {
        static let kaelMainBg: Color = Color(red: 253/255, green: 250/255, blue: 213/255)
        static let kaelMainYellow: Color = Color(red: 245/255, green: 205/255, blue: 98/255)
        static let kaelButtonYellow: Color = Color(red: 221/255, green: 123/255, blue: 15/255)
        static let kealBgBlack: Color = Color(red: 44/255, green: 44/255, blue: 44/255)
    }
    
    enum KaelFont {
        enum GhueaHuraWeight {
            case regular
            case medium
            case extraBold
        }

      // MARK: - MiSans
        static func jetBrainsMono(_ size: CGFloat, weight: GhueaHuraWeight = .regular) -> Font {
            let fontName: String

            switch weight {
            case .regular:
                fontName = "JetBrainsMono-Regular"
            case .medium:
                fontName = "JetBrainsMono-Medium"
            case .extraBold:
                fontName = "JetBrainsMono-ExtraBold"
            }
            return .custom(fontName, size: size)
      }
    }
}
