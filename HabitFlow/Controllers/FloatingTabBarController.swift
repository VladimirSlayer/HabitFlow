import UIKit

final class FloatingTabBarController: UIViewController {
    private let store = HabitsStore()

    private enum Tab: Int, CaseIterable {
        case habits
        case analytics
        case settings

        var title: String {
            switch self {
            case .habits:
                return "Habits"
            case .analytics:
                return "Analytics"
            case .settings:
                return "Settings"
            }
        }

        var imageName: String {
            switch self {
            case .habits:
                return "square.grid.2x2"
            case .analytics:
                return "chart.bar"
            case .settings:
                return "gearshape"
            }
        }

        var selectedImageName: String {
            switch self {
            case .habits:
                return "square.grid.2x2.fill"
            case .analytics:
                return "chart.bar.fill"
            case .settings:
                return "gearshape.fill"
            }
        }
    }

    private let contentContainer = UIView()

    private let floatingBar: UIView = {
        let view = UIView()
        view.backgroundColor = AppAppearance.cardSurface.withAlphaComponent(0.96)
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 18
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        return view
    }()

    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: tabViews)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var tabViews: [FloatingTabBarItemView] = Tab.allCases.map { tab in
        let itemView = FloatingTabBarItemView()
        itemView.tag = tab.rawValue
        itemView.addTarget(self, action: #selector(selectTabFromView(_:)), for: .touchUpInside)
        return itemView
    }

    private lazy var controllers: [UINavigationController] = {
        let bottomInset: CGFloat = 108
        return [
            makeNavigationController(rootViewController: HabitsListViewController(store: store), bottomInset: bottomInset),
            makeNavigationController(rootViewController: AnalyticsViewController(store: store), bottomInset: bottomInset),
            makeNavigationController(rootViewController: SettingsViewController(), bottomInset: bottomInset)
        ]
    }()

    private var selectedTab: Tab = .habits
    private var selectedController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppAppearance.background

        view.addSubview(contentContainer)
        view.addSubview(floatingBar)
        floatingBar.addSubview(buttonStack)

        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        floatingBar.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: view.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            floatingBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            floatingBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            floatingBar.heightAnchor.constraint(equalToConstant: 72),

            buttonStack.topAnchor.constraint(equalTo: floatingBar.topAnchor, constant: 8),
            buttonStack.leadingAnchor.constraint(equalTo: floatingBar.leadingAnchor, constant: 8),
            buttonStack.trailingAnchor.constraint(equalTo: floatingBar.trailingAnchor, constant: -8),
            buttonStack.bottomAnchor.constraint(equalTo: floatingBar.bottomAnchor, constant: -8)
        ])

        updateSelection(for: .habits)
    }

    @objc private func selectTabFromView(_ sender: FloatingTabBarItemView) {
        guard let tab = Tab(rawValue: sender.tag) else { return }
        updateSelection(for: tab)
    }

    private func updateSelection(for tab: Tab) {
        let controller = controllers[tab.rawValue]

        if let selectedController {
            selectedController.willMove(toParent: nil)
            selectedController.view.removeFromSuperview()
            selectedController.removeFromParent()
        }

        addChild(controller)
        contentContainer.addSubview(controller.view)
        controller.view.frame = contentContainer.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.didMove(toParent: self)
        selectedController = controller
        selectedTab = tab

        for currentTab in Tab.allCases {
            let button = tabViews[currentTab.rawValue]
            let isSelected = currentTab == tab
            button.configure(
                title: currentTab.title,
                imageName: isSelected ? currentTab.selectedImageName : currentTab.imageName,
                isSelected: isSelected
            )
        }
    }

    private func makeNavigationController(rootViewController: UIViewController, bottomInset: CGFloat) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.additionalSafeAreaInsets.bottom = bottomInset
        return navigationController
    }
}

private final class FloatingTabBarItemView: UIControl {

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppAppearance.secondaryText
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.textColor = AppAppearance.secondaryText
        return label
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.isUserInteractionEnabled = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 22
        layer.cornerCurve = .continuous

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            iconView.widthAnchor.constraint(equalToConstant: 18)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, imageName: String, isSelected: Bool) {
        titleLabel.text = title
        iconView.image = UIImage(systemName: imageName)
        let tint = isSelected ? AppAppearance.primaryText : AppAppearance.secondaryText
        titleLabel.textColor = tint
        iconView.tintColor = tint
        backgroundColor = isSelected ? AppAppearance.background.withAlphaComponent(0.95) : .clear
    }
}
