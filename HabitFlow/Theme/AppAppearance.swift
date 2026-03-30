import UIKit

enum AppAppearance {
    static let background = UIColor(red: 0.96, green: 0.94, blue: 0.90, alpha: 1)
    static let cardSurface = UIColor.white
    static let secondaryText = UIColor(red: 0.48, green: 0.44, blue: 0.40, alpha: 1)
    static let primaryText = UIColor(red: 0.15, green: 0.13, blue: 0.12, alpha: 1)
    static let accent = UIColor(red: 0.45, green: 0.36, blue: 0.30, alpha: 1)

    static let cardCornerRadius: CGFloat = 20
    static let cardShadowOpacity: Float = 0.06
    static let cardShadowRadius: CGFloat = 16
    static let cardShadowOffset = CGSize(width: 0, height: 4)
    static let gridSpacing: CGFloat = 12

    static let screenPadding: CGFloat = 20
    static let tabBarBottomInset: CGFloat = FloatingTabBarController.tabBarTotalHeight

    static func habitAccent(hex: String) -> UIColor {
        UIColor(hex: hex) ?? accent
    }
}
