import UIKit

final class HabitPreviewCardView: UIView {
    private let accentBar = UIView()
    private let nameLabel = UILabel()
    private let statusLabel = UILabel()
    private let completeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = AppAppearance.cardSurface
        layer.cornerRadius = AppAppearance.cardCornerRadius
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = AppAppearance.cardShadowOpacity
        layer.shadowRadius = AppAppearance.cardShadowRadius
        layer.shadowOffset = AppAppearance.cardShadowOffset

        accentBar.layer.cornerRadius = 5
        accentBar.layer.cornerCurve = .continuous

        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textColor = AppAppearance.primaryText
        nameLabel.numberOfLines = 2

        statusLabel.font = .systemFont(ofSize: 14, weight: .medium)
        statusLabel.textColor = AppAppearance.secondaryText

        completeButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        completeButton.layer.cornerRadius = 24
        completeButton.layer.cornerCurve = .continuous
        completeButton.isUserInteractionEnabled = false

        addSubview(accentBar)
        addSubview(nameLabel)
        addSubview(statusLabel)
        addSubview(completeButton)

        accentBar.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            accentBar.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            accentBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            accentBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            accentBar.heightAnchor.constraint(equalToConstant: 6),

            nameLabel.topAnchor.constraint(equalTo: accentBar.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            nameLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -12),

            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            completeButton.topAnchor.constraint(greaterThanOrEqualTo: statusLabel.bottomAnchor, constant: 12),
            completeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            completeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            completeButton.widthAnchor.constraint(equalToConstant: 48),
            completeButton.heightAnchor.constraint(equalToConstant: 48),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 168)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: AppAppearance.cardCornerRadius).cgPath
    }

    func configure(name: String, colorHex: String, completedToday: Bool) {
        let accent = AppAppearance.habitAccent(hex: colorHex)
        accentBar.backgroundColor = accent
        nameLabel.text = name.isEmpty ? "Your new habit" : name
        statusLabel.text = completedToday ? "Done today" : "Ready for today"

        if completedToday {
            completeButton.backgroundColor = accent
            completeButton.tintColor = .white
            completeButton.layer.borderWidth = 0
        } else {
            completeButton.backgroundColor = AppAppearance.cardSurface
            completeButton.tintColor = accent
            completeButton.layer.borderWidth = 2
            completeButton.layer.borderColor = accent.withAlphaComponent(0.45).cgColor
        }
    }
}
