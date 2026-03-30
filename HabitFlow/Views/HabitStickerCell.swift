import UIKit

final class HabitStickerCell: UICollectionViewCell {
    static let reuseIdentifier = "HabitStickerCell"

    var onTapComplete: (() -> Void)?

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = AppAppearance.cardSurface
        v.layer.cornerRadius = AppAppearance.cardCornerRadius
        v.layer.cornerCurve = .continuous
        v.clipsToBounds = false
        return v
    }()

    private let accentBar: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 3
        v.layer.cornerCurve = .continuous
        return v
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = AppAppearance.primaryText
        l.numberOfLines = 2
        return l
    }()

    private let statusLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .medium)
        l.textColor = AppAppearance.secondaryText
        l.numberOfLines = 1
        return l
    }()

    private let completeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)), for: .normal)
        b.tintColor = .white
        b.backgroundColor = AppAppearance.accent
        b.layer.cornerRadius = 18
        b.layer.cornerCurve = .continuous
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = AppAppearance.cardShadowOpacity
        cardView.layer.shadowRadius = AppAppearance.cardShadowRadius
        cardView.layer.shadowOffset = AppAppearance.cardShadowOffset
        cardView.layer.masksToBounds = false

        completeButton.addTarget(self, action: #selector(tapComplete), for: .touchUpInside)

        contentView.addSubview(cardView)
        cardView.addSubview(accentBar)
        cardView.addSubview(nameLabel)
        cardView.addSubview(statusLabel)
        cardView.addSubview(completeButton)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        accentBar.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false

        let pad: CGFloat = 14
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            accentBar.topAnchor.constraint(equalTo: cardView.topAnchor, constant: pad),
            accentBar.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: pad),
            accentBar.widthAnchor.constraint(equalToConstant: 4),
            accentBar.heightAnchor.constraint(equalToConstant: 28),

            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: pad),
            nameLabel.leadingAnchor.constraint(equalTo: accentBar.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -pad),

            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            completeButton.widthAnchor.constraint(equalToConstant: 36),
            completeButton.heightAnchor.constraint(equalToConstant: 36),
            completeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -pad),
            completeButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -pad)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: AppAppearance.cardCornerRadius).cgPath
    }

    func configure(with habit: HabitModel) {
        nameLabel.text = habit.name
        statusLabel.text = habit.completedToday ? "Done" : "Tap to complete"
        accentBar.backgroundColor = AppAppearance.habitAccent(hex: habit.colorHex)

        let accent = AppAppearance.habitAccent(hex: habit.colorHex)
        if habit.completedToday {
            completeButton.backgroundColor = accent
            completeButton.tintColor = .white
            completeButton.layer.borderWidth = 0
            cardView.backgroundColor = AppAppearance.cardSurface
        } else {
            completeButton.backgroundColor = AppAppearance.cardSurface
            completeButton.tintColor = accent
            completeButton.layer.borderWidth = 2
            completeButton.layer.borderColor = accent.withAlphaComponent(0.4).cgColor
            cardView.backgroundColor = AppAppearance.cardSurface
        }
    }

    @objc private func tapComplete() {
        onTapComplete?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onTapComplete = nil
        completeButton.layer.borderWidth = 0
    }
}
