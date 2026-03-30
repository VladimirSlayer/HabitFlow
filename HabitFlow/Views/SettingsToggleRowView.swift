import UIKit

final class SettingsToggleRowView: UIView {
    var onValueChanged: ((Bool) -> Void)?

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let toggleSwitch = UISwitch()

    init(title: String, subtitle: String) {
        super.init(frame: .zero)

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = AppAppearance.primaryText

        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = AppAppearance.secondaryText
        subtitleLabel.numberOfLines = 0

        toggleSwitch.onTintColor = AppAppearance.accent
        toggleSwitch.addTarget(self, action: #selector(handleSwitchValueChanged(_:)), for: .valueChanged)

        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 2

        addSubview(labelsStack)
        addSubview(toggleSwitch)

        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelsStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            labelsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            toggleSwitch.leadingAnchor.constraint(greaterThanOrEqualTo: labelsStack.trailingAnchor, constant: 12),
            toggleSwitch.trailingAnchor.constraint(equalTo: trailingAnchor),
            toggleSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setOn(_ isOn: Bool) {
        toggleSwitch.isOn = isOn
    }

    @objc private func handleSwitchValueChanged(_ sender: UISwitch) {
        onValueChanged?(sender.isOn)
    }
}
