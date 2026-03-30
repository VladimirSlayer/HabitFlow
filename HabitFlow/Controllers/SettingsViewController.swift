import UIKit

final class SettingsViewController: UIViewController {
    private let settingsStore = SettingsStore()

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.contentInset.bottom = AppAppearance.tabBarBottomInset
        view.verticalScrollIndicatorInsets.bottom = AppAppearance.tabBarBottomInset
        return view
    }()

    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = AppAppearance.primaryText
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Fine tune your cozy routine space."
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = AppAppearance.secondaryText
        label.numberOfLines = 0
        return label
    }()

    private let heroCard: UIView = {
        let view = UIView()
        view.backgroundColor = AppAppearance.accent
        view.layer.cornerRadius = AppAppearance.cardCornerRadius
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = AppAppearance.cardShadowOpacity
        view.layer.shadowRadius = AppAppearance.cardShadowRadius
        view.layer.shadowOffset = AppAppearance.cardShadowOffset
        return view
    }()

    private let heroBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "Cozy Premium"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()

    private let heroTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "HabitFlow"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let heroSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "A warm daily space for habits, focus, and calm progress."
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.numberOfLines = 0
        return label
    }()

    private let preferencesSection = SettingsSectionCardView(title: "Preferences")
    private let appSection = SettingsSectionCardView(title: "App")

    private let remindersRow = SettingsToggleRowView(
        title: "Daily reminders",
        subtitle: "Get a gentle nudge to stay consistent."
    )

    private let soundsRow = SettingsToggleRowView(
        title: "Cozy sounds",
        subtitle: "Keep soft feedback for small wins."
    )

    private lazy var appearanceRow = SettingsInfoRowView(
        title: "Appearance",
        value: "Cozy Premium"
    )

    private lazy var versionRow = SettingsInfoRowView(
        title: "Version",
        value: settingsStore.appVersion
    )

    private lazy var buildRow = SettingsInfoRowView(
        title: "Build",
        value: settingsStore.buildNumber
    )

    private lazy var cardsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heroCard, preferencesSection, appSection])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppAppearance.background

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(cardsStack)
        heroCard.addSubview(heroBadgeLabel)
        heroCard.addSubview(heroTitleLabel)
        heroCard.addSubview(heroSubtitleLabel)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardsStack.translatesAutoresizingMaskIntoConstraints = false
        heroBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        heroTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        heroSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppAppearance.screenPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppAppearance.screenPadding),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            cardsStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            cardsStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            cardsStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            cardsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            heroBadgeLabel.topAnchor.constraint(equalTo: heroCard.topAnchor, constant: 18),
            heroBadgeLabel.leadingAnchor.constraint(equalTo: heroCard.leadingAnchor, constant: 18),
            heroBadgeLabel.trailingAnchor.constraint(equalTo: heroCard.trailingAnchor, constant: -18),

            heroTitleLabel.topAnchor.constraint(equalTo: heroBadgeLabel.bottomAnchor, constant: 8),
            heroTitleLabel.leadingAnchor.constraint(equalTo: heroBadgeLabel.leadingAnchor),
            heroTitleLabel.trailingAnchor.constraint(equalTo: heroBadgeLabel.trailingAnchor),

            heroSubtitleLabel.topAnchor.constraint(equalTo: heroTitleLabel.bottomAnchor, constant: 8),
            heroSubtitleLabel.leadingAnchor.constraint(equalTo: heroBadgeLabel.leadingAnchor),
            heroSubtitleLabel.trailingAnchor.constraint(equalTo: heroBadgeLabel.trailingAnchor),
            heroSubtitleLabel.bottomAnchor.constraint(equalTo: heroCard.bottomAnchor, constant: -18)
        ])

        configureSections()
        bindRows()
    }

    private func configureSections() {
        remindersRow.setOn(settingsStore.dailyRemindersEnabled)
        soundsRow.setOn(settingsStore.cozySoundsEnabled)

        preferencesSection.contentStack.addArrangedSubview(remindersRow)
        preferencesSection.contentStack.addArrangedSubview(makeSeparator())
        preferencesSection.contentStack.addArrangedSubview(soundsRow)

        appSection.contentStack.addArrangedSubview(appearanceRow)
        appSection.contentStack.addArrangedSubview(makeSeparator())
        appSection.contentStack.addArrangedSubview(versionRow)
        appSection.contentStack.addArrangedSubview(makeSeparator())
        appSection.contentStack.addArrangedSubview(buildRow)
    }

    private func bindRows() {
        remindersRow.onValueChanged = { [weak self] isOn in
            self?.settingsStore.dailyRemindersEnabled = isOn
        }

        soundsRow.onValueChanged = { [weak self] isOn in
            self?.settingsStore.cozySoundsEnabled = isOn
        }
    }

    private func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = AppAppearance.background
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
}
