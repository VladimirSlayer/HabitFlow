import UIKit

final class AnalyticsCardView: UIView {
    private let accentStripe = UIView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let captionLabel = UILabel()

    init(title: String, value: String, caption: String) {
        super.init(frame: .zero)

        backgroundColor = AppAppearance.cardSurface
        layer.cornerRadius = AppAppearance.cardCornerRadius
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = AppAppearance.cardShadowOpacity
        layer.shadowRadius = AppAppearance.cardShadowRadius
        layer.shadowOffset = AppAppearance.cardShadowOffset

        accentStripe.backgroundColor = AppAppearance.accent.withAlphaComponent(0.15)
        accentStripe.layer.cornerRadius = 3
        accentStripe.layer.cornerCurve = .continuous

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = AppAppearance.secondaryText

        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 28, weight: .bold)
        valueLabel.textColor = AppAppearance.primaryText

        captionLabel.text = caption
        captionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        captionLabel.textColor = AppAppearance.secondaryText
        captionLabel.numberOfLines = 0

        addSubview(accentStripe)
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(captionLabel)

        accentStripe.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            accentStripe.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            accentStripe.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            accentStripe.widthAnchor.constraint(equalToConstant: 4),
            accentStripe.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: accentStripe.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            captionLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            captionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    func update(value: String, caption: String) {
        valueLabel.text = value
        captionLabel.text = caption
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
