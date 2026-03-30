import UIKit

enum AppAppearance {
    static let background = UIColor(red: 0.97, green: 0.95, blue: 0.91, alpha: 1)
    static let cardSurface = UIColor(red: 1, green: 0.99, blue: 0.97, alpha: 1)
    static let secondaryText = UIColor(red: 0.45, green: 0.42, blue: 0.38, alpha: 1)
    static let primaryText = UIColor(red: 0.22, green: 0.2, blue: 0.18, alpha: 1)

    static let cardCornerRadius: CGFloat = 22
    static let cardShadowOpacity: Float = 0.09
    static let cardShadowRadius: CGFloat = 14
    static let cardShadowOffset = CGSize(width: 0, height: 6)
    static let gridSpacing: CGFloat = 14

    static let screenPadding: CGFloat = 20

    static func habitAccent(hex: String) -> UIColor {
        UIColor(hex: hex) ?? UIColor(red: 0.55, green: 0.48, blue: 0.42, alpha: 1)
    }
}
