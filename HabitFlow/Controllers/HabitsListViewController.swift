import UIKit

final class HabitsListViewController: UIViewController {
    private let store: HabitsStore

    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.alwaysBounceVertical = true
        s.contentInset.bottom = AppAppearance.tabBarBottomInset
        s.verticalScrollIndicatorInsets.bottom = AppAppearance.tabBarBottomInset
        return s
    }()

    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Habits"
        l.font = .systemFont(ofSize: 32, weight: .bold)
        l.textColor = AppAppearance.primaryText
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Your daily flow."
        l.font = .systemFont(ofSize: 15, weight: .medium)
        l.textColor = AppAppearance.secondaryText
        return l
    }()

    private lazy var addButton: UIButton = {
        let b = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium)
        b.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: config), for: .normal)
        b.tintColor = AppAppearance.accent
        b.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        return b
    }()

    private lazy var headerRow: UIStackView = {
        let row = UIStackView(arrangedSubviews: [titleLabel, addButton])
        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .equalSpacing
        return row
    }()

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: Self.makeLayout())
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(HabitStickerCell.self, forCellWithReuseIdentifier: HabitStickerCell.reuseIdentifier)
        return cv
    }()

    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "Tap + to create your first habit"
        l.font = .systemFont(ofSize: 16, weight: .medium)
        l.textColor = AppAppearance.secondaryText
        l.textAlignment = .center
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    private var collectionHeightConstraint: NSLayoutConstraint?

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
        contentView.addSubview(headerRow)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(emptyLabel)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerRow.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        let collectionHeight = collectionView.heightAnchor.constraint(equalToConstant: 400)
        collectionHeightConstraint = collectionHeight

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

            headerRow.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppAppearance.screenPadding),
            headerRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppAppearance.screenPadding),

            subtitleLabel.topAnchor.constraint(equalTo: headerRow.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerRow.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerRow.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            collectionHeight,

            emptyLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 60),
            emptyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            emptyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        syncCollectionHeight()
        updateEmptyState()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        syncCollectionHeight()
    }

    private func syncCollectionHeight() {
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionHeightConstraint?.constant = max(height, 1)
        view.layoutIfNeeded()
    }

    private func updateEmptyState() {
        let isEmpty = store.habits.isEmpty
        emptyLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let spacing = AppAppearance.gridSpacing
        let rowHeight: CGFloat = 148

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(rowHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: spacing / 2,
            bottom: spacing,
            trailing: spacing / 2
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(rowHeight + spacing)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: AppAppearance.screenPadding - spacing / 2,
            bottom: 8,
            trailing: AppAppearance.screenPadding - spacing / 2
        )

        return UICollectionViewCompositionalLayout(section: section)
    }

    @objc private func didTapAdd() {
        let createHabitVC = CreateHabitViewController()
        createHabitVC.onSave = { [weak self] newHabit in
            self?.store.addHabit(newHabit)
            self?.collectionView.reloadData()
            self?.syncCollectionHeight()
            self?.updateEmptyState()
        }
        navigationController?.pushViewController(createHabitVC, animated: true)
    }
}

extension HabitsListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        store.habits.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitStickerCell.reuseIdentifier, for: indexPath) as! HabitStickerCell
        let habit = store.habits[indexPath.item]
        cell.configure(with: habit)
        cell.onTapComplete = { [weak self] in
            self?.store.toggleHabitCompletion(id: habit.id)
            self?.collectionView.reloadItems(at: [indexPath])
            self?.syncCollectionHeight()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let habit = store.habits[indexPath.item]
        let habitVC = HabitDetailViewController(store: store, habitID: habit.id)
        navigationController?.pushViewController(habitVC, animated: true)
    }
}
