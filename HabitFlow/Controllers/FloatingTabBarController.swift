import UIKit

final class FloatingTabBarController: UIViewController {
    private let store = HabitsStore()
    static let tabBarTotalHeight: CGFloat = 96

    private enum Tab: Int, CaseIterable {
        case habits
        case analytics
        case settings

        var title: String {
            switch self {
            case .habits: return "Habits"
            case .analytics: return "Analytics"
            case .settings: return "Settings"
            }
        }

        var imageName: String {
            switch self {
            case .habits: return "square.grid.2x2"
            case .analytics: return "chart.bar"
            case .settings: return "gearshape"
            }
        }

        var selectedImageName: String {
            switch self {
            case .habits: return "square.grid.2x2.fill"
            case .analytics: return "chart.bar.fill"
            case .settings: return "gearshape.fill"
            }
        }
    }

    private let contentContainer = UIView()

    private let blurBackground: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.layer.cornerRadius = 28
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }()

    private let floatingBar: UIView = {
        let view = UIView()
        view.backgroundColor = AppAppearance.cardSurface.withAlphaComponent(0.7)
        view.layer.cornerRadius = 28
        view.layer.cornerCurve = .continuous
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.10
        view.layer.shadowRadius = 24
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
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

    private lazy var controllers: [UINavigationController] = [
        makeNavigationController(rootViewController: HabitsListViewController(store: store)),
        makeNavigationController(rootViewController: AnalyticsViewController(store: store)),
        makeNavigationController(rootViewController: SettingsViewController())
    ]

    private var selectedTab: Tab = .habits
    private var selectedController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppAppearance.background

        view.addSubview(contentContainer)
        view.addSubview(blurBackground)
        view.addSubview(floatingBar)
        floatingBar.addSubview(buttonStack)

        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        blurBackground.translatesAutoresizingMaskIntoConstraints = false
        floatingBar.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: view.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            blurBackground.leadingAnchor.constraint(equalTo: floatingBar.leadingAnchor),
            blurBackground.trailingAnchor.constraint(equalTo: floatingBar.trailingAnchor),
            blurBackground.topAnchor.constraint(equalTo: floatingBar.topAnchor),
            blurBackground.bottomAnchor.constraint(equalTo: floatingBar.bottomAnchor),

            floatingBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            floatingBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            floatingBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            floatingBar.heightAnchor.constraint(equalToConstant: 64),

            buttonStack.topAnchor.constraint(equalTo: floatingBar.topAnchor, constant: 6),
            buttonStack.leadingAnchor.constraint(equalTo: floatingBar.leadingAnchor, constant: 6),
            buttonStack.trailingAnchor.constraint(equalTo: floatingBar.trailingAnchor, constant: -6),
            buttonStack.bottomAnchor.constraint(equalTo: floatingBar.bottomAnchor, constant: -6)
        ])

        updateSelection(for: .habits)
    }

    @objc private func selectTabFromView(_ sender: FloatingTabBarItemView) {
        guard let tab = Tab(rawValue: sender.tag) else { return }
        guard tab != selectedTab else { return }
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

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            for currentTab in Tab.allCases {
                let button = self.tabViews[currentTab.rawValue]
                let isSelected = currentTab == tab
                button.configure(
                    title: currentTab.title,
                    imageName: isSelected ? currentTab.selectedImageName : currentTab.imageName,
                    isSelected: isSelected
                )
            }
        }
    }

    private func makeNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.setNavigationBarHidden(true, animated: false)
        return nav
    }
}

private final class FloatingTabBarItemView: UIControl {
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = AppAppearance.secondaryText
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .center
        label.textColor = AppAppearance.secondaryText
        return label
    }()

    private lazy var stack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [iconView, titleLabel])
        s.axis = .vertical
        s.alignment = .center
        s.spacing = 2
        s.isUserInteractionEnabled = false
        return s
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, imageName: String, isSelected: Bool) {
        titleLabel.text = title
        iconView.image = UIImage(systemName: imageName)
        let tint = isSelected ? AppAppearance.primaryText : AppAppearance.secondaryText.withAlphaComponent(0.65)
        titleLabel.textColor = tint
        iconView.tintColor = tint
        backgroundColor = isSelected ? AppAppearance.background.withAlphaComponent(0.85) : .clear
        transform = isSelected ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
    }
}
