import UIKit

final class HabitDetailViewController: UIViewController {
    private let store: HabitsStore
    private let habitID: UUID

    private var habit: HabitModel? {
        store.habit(id: habitID)
    }

    init(store: HabitsStore, habitID: UUID) {
        self.store = store
        self.habitID = habitID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.alwaysBounceVertical = true
        return s
    }()

    private let contentView = UIView()

    private lazy var backButton: UIButton = {
        let b = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        b.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        b.tintColor = AppAppearance.primaryText
        b.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        return b
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 28, weight: .bold)
        l.textColor = AppAppearance.primaryText
        l.numberOfLines = 0
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .medium)
        l.textColor = AppAppearance.secondaryText
        l.numberOfLines = 0
        return l
    }()

    private let previewCard = HabitPreviewCardView()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 18
        button.layer.cornerCurve = .continuous
        button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
        return button
    }()

    private let todayCard = AnalyticsCardView(title: "Today", value: "--", caption: "--")
    private let paceCard = AnalyticsCardView(title: "Progress", value: "--", caption: "--")
    private let focusCard = AnalyticsCardView(title: "Focus", value: "--", caption: "--")

    private let reflectionCard: UIView = {
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

    private let reflectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Routine note"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = AppAppearance.secondaryText
        return label
    }()

    private let reflectionBodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = AppAppearance.primaryText
        label.numberOfLines = 0
        return label
    }()

    private lazy var statsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [todayCard, paceCard, focusCard])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppAppearance.background

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(previewCard)
        contentView.addSubview(actionButton)
        contentView.addSubview(statsStack)
        contentView.addSubview(reflectionCard)
        reflectionCard.addSubview(reflectionTitleLabel)
        reflectionCard.addSubview(reflectionBodyLabel)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        previewCard.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        reflectionCard.translatesAutoresizingMaskIntoConstraints = false
        reflectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        reflectionBodyLabel.translatesAutoresizingMaskIntoConstraints = false

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

            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppAppearance.screenPadding - 4),

            nameLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppAppearance.screenPadding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppAppearance.screenPadding),

            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            previewCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            previewCard.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            previewCard.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            actionButton.topAnchor.constraint(equalTo: previewCard.bottomAnchor, constant: 16),
            actionButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            statsStack.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 16),
            statsStack.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statsStack.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            reflectionCard.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 16),
            reflectionCard.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            reflectionCard.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            reflectionCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),

            reflectionTitleLabel.topAnchor.constraint(equalTo: reflectionCard.topAnchor, constant: 18),
            reflectionTitleLabel.leadingAnchor.constraint(equalTo: reflectionCard.leadingAnchor, constant: 18),
            reflectionTitleLabel.trailingAnchor.constraint(equalTo: reflectionCard.trailingAnchor, constant: -18),

            reflectionBodyLabel.topAnchor.constraint(equalTo: reflectionTitleLabel.bottomAnchor, constant: 10),
            reflectionBodyLabel.leadingAnchor.constraint(equalTo: reflectionTitleLabel.leadingAnchor),
            reflectionBodyLabel.trailingAnchor.constraint(equalTo: reflectionTitleLabel.trailingAnchor),
            reflectionBodyLabel.bottomAnchor.constraint(equalTo: reflectionCard.bottomAnchor, constant: -18)
        ])

        actionButton.addTarget(self, action: #selector(toggleCompletion), for: .touchUpInside)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadContent),
            name: .habitsStoreDidUpdate,
            object: store
        )
        reloadContent()
    }

    @objc private func tapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func toggleCompletion() {
        store.toggleHabitCompletion(id: habitID)
    }

    @objc private func reloadContent() {
        guard let habit else {
            navigationController?.popViewController(animated: true)
            return
        }

        let accent = AppAppearance.habitAccent(hex: habit.colorHex)
        let totalHabits = store.habits.count
        let completedHabits = store.habits.filter(\.completedToday).count
        let completionRate = totalHabits == 0 ? 0 : Int((Double(completedHabits) / Double(totalHabits) * 100).rounded())
        let openHabits = max(totalHabits - completedHabits, 0)

        nameLabel.text = habit.name
        subtitleLabel.text = habit.completedToday
            ? "This habit is already completed for today."
            : "Your routine is waiting for one more small action."
        previewCard.configure(name: habit.name, colorHex: habit.colorHex, completedToday: habit.completedToday)

        actionButton.setTitle(habit.completedToday ? "Mark as Open" : "Mark as Done", for: .normal)
        actionButton.backgroundColor = accent
        actionButton.tintColor = .white

        todayCard.update(
            value: habit.completedToday ? "Done" : "Open",
            caption: habit.completedToday ? "logged for today" : "still waiting today"
        )
        paceCard.update(
            value: "\(completionRate)%",
            caption: "of your habits are complete today"
        )
        focusCard.update(
            value: "\(openHabits)",
            caption: openHabits == 1 ? "habit still open today" : "habits still open today"
        )

        reflectionBodyLabel.text = habit.completedToday
            ? "Nice work. This habit already supports your daily flow, so you can keep your energy for the remaining routines."
            : "A small action on this habit will push your daily progress forward and keep the screen feeling balanced."
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
