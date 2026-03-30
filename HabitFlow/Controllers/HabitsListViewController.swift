import UIKit

final class HabitsListViewController: UIViewController {

    private var habitsMock: [HabitModel] = [
        HabitModel(id: UUID(), name: "Reading", colorHex: "#FF9500", completedToday: false),
        HabitModel(id: UUID(), name: "Workout", colorHex: "#34C759", completedToday: true),
        HabitModel(id: UUID(), name: "Water", colorHex: "#007AFF", completedToday: false)
    ]

    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.alwaysBounceVertical = true
        s.showsVerticalScrollIndicator = true
        return s
    }()

    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Habits"
        l.font = .systemFont(ofSize: 34, weight: .bold)
        l.textColor = AppAppearance.primaryText
        l.numberOfLines = 1
        return l
    }()

    private lazy var addButton: UIButton = {
        let b = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        b.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: config), for: .normal)
        b.tintColor = AppAppearance.habitAccent(hex: "#6B5B4F")
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

    private var collectionHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppAppearance.background

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerRow)
        contentView.addSubview(collectionView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerRow.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let collectionHeight = collectionView.heightAnchor.constraint(equalToConstant: 400)
        collectionHeightConstraint = collectionHeight

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

            headerRow.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            headerRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppAppearance.screenPadding),
            headerRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppAppearance.screenPadding),

            collectionView.topAnchor.constraint(equalTo: headerRow.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            collectionHeight
        ])
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

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let spacing = AppAppearance.gridSpacing
        let rowHeight: CGFloat = 158

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
            leading: 16 - spacing / 2,
            bottom: 8,
            trailing: 16 - spacing / 2
        )

        return UICollectionViewCompositionalLayout(section: section)
    }

    @objc private func didTapAdd() {
        let createHabitVC = CreateHabitViewController()
        createHabitVC.onSave = { [weak self] newHabit in
            self?.habitsMock.append(newHabit)
            self?.collectionView.reloadData()
            self?.syncCollectionHeight()
        }
        navigationController?.pushViewController(createHabitVC, animated: true)
    }
}

extension HabitsListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        habitsMock.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitStickerCell.reuseIdentifier, for: indexPath) as! HabitStickerCell
        let habit = habitsMock[indexPath.item]
        cell.configure(with: habit)
        cell.onTapComplete = { [weak self] in
            self?.habitsMock[indexPath.item].completedToday.toggle()
            self?.collectionView.reloadItems(at: [indexPath])
            self?.syncCollectionHeight()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let habit = habitsMock[indexPath.item]
        let habitVC = HabitDetailViewController(selectedHabit: habit)
        navigationController?.pushViewController(habitVC, animated: true)
    }
}
