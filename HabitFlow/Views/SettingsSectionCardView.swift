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

        titleLabel.text = title.uppercased()
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = AppAppearance.secondaryText.withAlphaComponent(0.7)

        contentStack.axis = .vertical
        contentStack.spacing = 0

        addSubview(titleLabel)
        addSubview(contentStack)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            contentStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
