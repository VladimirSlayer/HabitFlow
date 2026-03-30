import UIKit

final class CreateHabitViewController: UIViewController {
    var onSave: ((HabitModel) -> Void)?

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

    private let screenTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "New Habit"
        l.font = .systemFont(ofSize: 28, weight: .bold)
        l.textColor = AppAppearance.primaryText
        return l
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Habit name"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let completedLabel: UILabel = {
        let completedLabel = UILabel()
        completedLabel.text = "Done today"
        completedLabel.textColor = AppAppearance.primaryText
        return completedLabel
    }()

    private let completedSwitch = UISwitch()

    private let saveButton: UIButton = {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        return saveButton
    }()

    private let switchStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppAppearance.background

        switchStack.addArrangedSubview(completedLabel)
        switchStack.addArrangedSubview(completedSwitch)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(switchStack)
        stackView.addArrangedSubview(saveButton)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(screenTitleLabel)
        contentView.addSubview(stackView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        screenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

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

            screenTitleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            screenTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppAppearance.screenPadding),
            screenTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppAppearance.screenPadding),

            stackView.topAnchor.constraint(equalTo: screenTitleLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppAppearance.screenPadding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppAppearance.screenPadding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])

        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    @objc private func tapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "No text in name field", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
            return
        }

        let habit = HabitModel(id: UUID(), name: name, colorHex: "#FFFFFF", completedToday: completedSwitch.isOn)

        onSave?(habit)
        navigationController?.popViewController(animated: true)
    }
}
