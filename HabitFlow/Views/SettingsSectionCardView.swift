import UIKit

final class SettingsSectionCardView: UIView {
    let contentStack = UIStackView()

    private let titleLabel = UILabel()

    init(title: String) {
        super.init(frame: .zero)

        backgroundColor = AppAppearance.cardSurface
        layer.cornerRadius = AppAppearance.cardCornerRadius
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = AppAppearance.cardShadowOpacity
        layer.shadowRadius = AppAppearance.cardShadowRadius
        layer.shadowOffset = AppAppearance.cardShadowOffset

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = AppAppearance.secondaryText

        contentStack.axis = .vertical
        contentStack.spacing = 0

        addSubview(titleLabel)
        addSubview(contentStack)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),

            contentStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
