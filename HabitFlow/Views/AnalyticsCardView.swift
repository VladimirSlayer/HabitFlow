import UIKit

final class AnalyticsCardView: UIView {

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

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = AppAppearance.secondaryText

        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 30, weight: .bold)
        valueLabel.textColor = AppAppearance.primaryText

        captionLabel.text = caption
        captionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        captionLabel.textColor = AppAppearance.secondaryText
        captionLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel, captionLabel])
        stack.axis = .vertical
        stack.spacing = 6

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
