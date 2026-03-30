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

        accentBar.layer.cornerRadius = 3
        accentBar.layer.cornerCurve = .continuous

        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = AppAppearance.primaryText
        nameLabel.numberOfLines = 2

        statusLabel.font = .systemFont(ofSize: 13, weight: .medium)
        statusLabel.textColor = AppAppearance.secondaryText

        completeButton.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)), for: .normal)
        completeButton.layer.cornerRadius = 18
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
            accentBar.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            accentBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            accentBar.widthAnchor.constraint(equalToConstant: 4),
            accentBar.heightAnchor.constraint(equalToConstant: 28),

            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: accentBar.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -12),

            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            completeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            completeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            completeButton.widthAnchor.constraint(equalToConstant: 36),
            completeButton.heightAnchor.constraint(equalToConstant: 36),
            completeButton.topAnchor.constraint(greaterThanOrEqualTo: statusLabel.bottomAnchor, constant: 12),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
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
            completeButton.layer.borderColor = accent.withAlphaComponent(0.4).cgColor
        }
    }
}
