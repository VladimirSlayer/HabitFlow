import UIKit

final class CreateHabitViewController: UIViewController {
    var onSave: ((HabitModel) -> Void)?
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название привычки"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let completedLabel: UILabel = {
        let completedLabel = UILabel()
        completedLabel.text = "Выполнено сегодня"
        completedLabel.textColor = .label
        return completedLabel
    }()
    
    private let completedSwitch = UISwitch()
    
    private let saveButton: UIButton = {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17)
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
        view.backgroundColor = .white
        title = "New Habit"
        setupHierarchy()
        setupLayout()
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    private func setupHierarchy() {
        switchStack.addArrangedSubview(completedLabel)
        switchStack.addArrangedSubview(completedSwitch)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(switchStack)
        stackView.addArrangedSubview(saveButton)
        view.addSubview(stackView)
    }
    
    private func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func saveTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        
        let habit = HabitModel(id: UUID(), name: name, colorHex: "#FFFFFF", completedToday: completedSwitch.isOn)
        
        onSave?(habit)
        navigationController?.popViewController(animated: true)
    }
}
