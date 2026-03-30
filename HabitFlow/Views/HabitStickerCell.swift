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
        v.layer.cornerRadius = 5
        v.layer.cornerCurve = .continuous
        return v
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 17, weight: .semibold)
        l.textColor = AppAppearance.primaryText
        l.numberOfLines = 2
        return l
    }()

    private let statusLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .medium)
        l.textColor = AppAppearance.secondaryText
        l.numberOfLines = 1
        return l
    }()

    private let completeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "checkmark"), for: .normal)
        b.tintColor = .white
        b.backgroundColor = UIColor(red: 0.42, green: 0.38, blue: 0.34, alpha: 1)
        b.layer.cornerRadius = 22
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
            accentBar.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -pad),
            accentBar.heightAnchor.constraint(equalToConstant: 5),

            nameLabel.topAnchor.constraint(equalTo: accentBar.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: pad),
            nameLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -8),

            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            completeButton.topAnchor.constraint(greaterThanOrEqualTo: statusLabel.bottomAnchor, constant: 8),

            completeButton.widthAnchor.constraint(equalToConstant: 44),
            completeButton.heightAnchor.constraint(equalToConstant: 44),
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
        statusLabel.text = habit.completedToday ? "Done today" : "Tap to complete"
        accentBar.backgroundColor = AppAppearance.habitAccent(hex: habit.colorHex)

        let accent = AppAppearance.habitAccent(hex: habit.colorHex)
        if habit.completedToday {
            completeButton.backgroundColor = accent
            completeButton.tintColor = .white
            completeButton.layer.borderWidth = 0
        } else {
            completeButton.backgroundColor = AppAppearance.cardSurface
            completeButton.tintColor = accent
            completeButton.layer.borderWidth = 2
            completeButton.layer.borderColor = accent.withAlphaComponent(0.55).cgColor
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
