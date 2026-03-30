import UIKit

final class AnalyticsViewController: UIViewController {
    private let store: HabitsStore

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        return view
    }()

    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Analytics"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = AppAppearance.primaryText
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Track your rhythm and daily consistency."
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = AppAppearance.secondaryText
        label.numberOfLines = 0
        return label
    }()

    private let summaryCard = AnalyticsCardView(
        title: "Today",
        value: "3 / 5",
        caption: "habits completed"
    )

    private let streakCard = AnalyticsCardView(
        title: "Best streak",
        value: "7 days",
        caption: "keep your momentum"
    )

    private let progressCard = AnalyticsCardView(
        title: "Completion rate",
        value: "0%",
        caption: "for today"
    )

    private let pendingCard = AnalyticsCardView(
        title: "Pending",
        value: "0",
        caption: "habits left today"
    )

    private let focusCard: UIView = {
        let view = UIView()
        view.backgroundColor = AppAppearance.cardSurface
        view.layer.cornerRadius = AppAppearance.cardCornerRadius
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = AppAppearance.cardShadowOpacity
        view.layer.shadowRadius = AppAppearance.cardShadowRadius
        view.layer.shadowOffset = AppAppearance.cardShadowOffset
        return view
    }()

    private let focusTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily focus"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = AppAppearance.secondaryText
        return label
    }()

    private let focusValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = AppAppearance.primaryText
        label.numberOfLines = 0
        return label
    }()

    private let progressTrackView: UIView = {
        let view = UIView()
        view.backgroundColor = AppAppearance.background
        view.layer.cornerRadius = 7
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let progressFillView: UIView = {
        let view = UIView()
        view.backgroundColor = AppAppearance.habitAccent(hex: "#7C6455")
        view.layer.cornerRadius = 7
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let focusCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = AppAppearance.secondaryText
        label.numberOfLines = 0
        return label
    }()

    private lazy var cardsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [summaryCard, streakCard, progressCard, pendingCard, focusCard])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    private var progressFillWidthConstraint: NSLayoutConstraint?

    init(store: HabitsStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppAppearance.background

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(cardsStack)
        focusCard.addSubview(focusTitleLabel)
        focusCard.addSubview(focusValueLabel)
        focusCard.addSubview(progressTrackView)
        progressTrackView.addSubview(progressFillView)
        focusCard.addSubview(focusCaptionLabel)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardsStack.translatesAutoresizingMaskIntoConstraints = false
        focusTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        focusValueLabel.translatesAutoresizingMaskIntoConstraints = false
        progressTrackView.translatesAutoresizingMaskIntoConstraints = false
        progressFillView.translatesAutoresizingMaskIntoConstraints = false
        focusCaptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let progressFillWidthConstraint = progressFillView.widthAnchor.constraint(equalToConstant: 0)
        self.progressFillWidthConstraint = progressFillWidthConstraint

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
            cardsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),

            focusTitleLabel.topAnchor.constraint(equalTo: focusCard.topAnchor, constant: 18),
            focusTitleLabel.leadingAnchor.constraint(equalTo: focusCard.leadingAnchor, constant: 18),
            focusTitleLabel.trailingAnchor.constraint(equalTo: focusCard.trailingAnchor, constant: -18),

            focusValueLabel.topAnchor.constraint(equalTo: focusTitleLabel.bottomAnchor, constant: 8),
            focusValueLabel.leadingAnchor.constraint(equalTo: focusTitleLabel.leadingAnchor),
            focusValueLabel.trailingAnchor.constraint(equalTo: focusTitleLabel.trailingAnchor),

            progressTrackView.topAnchor.constraint(equalTo: focusValueLabel.bottomAnchor, constant: 16),
            progressTrackView.leadingAnchor.constraint(equalTo: focusTitleLabel.leadingAnchor),
            progressTrackView.trailingAnchor.constraint(equalTo: focusTitleLabel.trailingAnchor),
            progressTrackView.heightAnchor.constraint(equalToConstant: 14),

            progressFillView.topAnchor.constraint(equalTo: progressTrackView.topAnchor),
            progressFillView.leadingAnchor.constraint(equalTo: progressTrackView.leadingAnchor),
            progressFillView.bottomAnchor.constraint(equalTo: progressTrackView.bottomAnchor),
            progressFillWidthConstraint,

            focusCaptionLabel.topAnchor.constraint(equalTo: progressTrackView.bottomAnchor, constant: 14),
            focusCaptionLabel.leadingAnchor.constraint(equalTo: focusTitleLabel.leadingAnchor),
            focusCaptionLabel.trailingAnchor.constraint(equalTo: focusTitleLabel.trailingAnchor),
            focusCaptionLabel.bottomAnchor.constraint(equalTo: focusCard.bottomAnchor, constant: -18)
        ])

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadStats),
            name: .habitsStoreDidUpdate,
            object: store
        )

        reloadStats()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateProgressBar()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func reloadStats() {
        let habits = store.habits
        let totalCount = habits.count
        let completedCount = habits.filter(\.completedToday).count
        let pendingCount = max(totalCount - completedCount, 0)
        let completionRate = totalCount == 0 ? 0 : Int((Double(completedCount) / Double(totalCount) * 100).rounded())
        let bestStreak = completedCount == totalCount && totalCount > 0 ? completedCount + 2 : max(completedCount, 1)

        summaryCard.update(
            value: "\(completedCount) / \(totalCount)",
            caption: totalCount == 0 ? "add your first habit" : "habits completed today"
        )
        streakCard.update(
            value: "\(bestStreak) days",
            caption: totalCount == 0 ? "start your first streak" : "your current best pace"
        )
        progressCard.update(
            value: "\(completionRate)%",
            caption: totalCount == 0 ? "progress will appear here" : "for today"
        )
        pendingCard.update(
            value: "\(pendingCount)",
            caption: pendingCount == 1 ? "habit left today" : "habits left today"
        )

        if totalCount == 0 {
            focusValueLabel.text = "No habits yet"
            focusCaptionLabel.text = "Create a habit in the Habits tab to unlock your daily insights."
        } else if pendingCount == 0 {
            focusValueLabel.text = "Everything is done"
            focusCaptionLabel.text = "You completed every habit for today. Great job keeping the streak alive."
        } else {
            focusValueLabel.text = "\(pendingCount) habits still waiting"
            focusCaptionLabel.text = "You already closed \(completedCount) habits today. Keep the flow going."
        }

        updateProgressBar()
    }

    private func updateProgressBar() {
        let totalCount = store.habits.count
        let completedCount = store.habits.filter(\.completedToday).count
        let progress = totalCount == 0 ? 0 : CGFloat(completedCount) / CGFloat(totalCount)
        let availableWidth = progressTrackView.bounds.width
        progressFillWidthConstraint?.constant = availableWidth * progress
        progressTrackView.layoutIfNeeded()
    }
}
