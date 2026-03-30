import UIKit

final class SettingsViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        return view
    }()

    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = AppAppearance.primaryText
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Fine tune your cozy routine space."
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppAppearance.secondaryText
        label.numberOfLines = 0
        return label
    }()

    private let profileCard = AnalyticsCardView(
        title: "Profile",
        value: "HabitFlow",
        caption: "your calm premium tracker"
    )

    private let preferencesCard = AnalyticsCardView(
        title: "Preferences",
        value: "Daily reminders",
        caption: "coming soon"
    )

    private let aboutCard = AnalyticsCardView(
        title: "Version",
        value: "1.0",
        caption: "build foundation is ready"
    )

    private lazy var cardsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileCard, preferencesCard, aboutCard])
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

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppAppearance.screenPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppAppearance.screenPadding),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            cardsStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            cardsStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            cardsStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            cardsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
}
