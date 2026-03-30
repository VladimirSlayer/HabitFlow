import UIKit

final class CreateHabitViewController: UIViewController {
    var onSave: ((HabitModel) -> Void)?

    private let colorOptions = ["#FF9500", "#34C759", "#007AFF", "#AF52DE", "#FF2D55", "#A2845E"]
    private var selectedColorHex = "#FF9500"

    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.alwaysBounceVertical = true
        s.keyboardDismissMode = .onDrag
        return s
    }()

    private let contentView = UIView()

    private lazy var backButton: UIButton = {
        let b = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        b.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        b.tintColor = AppAppearance.primaryText
        b.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        return b
    }()

    private let screenTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "New Habit"
        l.font = .systemFont(ofSize: 26, weight: .bold)
        l.textColor = AppAppearance.primaryText
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Shape the card before you save it."
        l.font = .systemFont(ofSize: 15, weight: .medium)
        l.textColor = AppAppearance.secondaryText
        l.numberOfLines = 0
        return l
    }()

    private let previewTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Preview"
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = AppAppearance.secondaryText
        return l
    }()

    private let previewCard = HabitPreviewCardView()

    private let formCard: UIView = {
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

    private let nameSectionLabel: UILabel = {
        let l = UILabel()
        l.text = "Name"
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = AppAppearance.secondaryText
        return l
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Habit name"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 17, weight: .semibold)
        textField.textColor = AppAppearance.primaryText
        return textField
    }()

    private let textFieldCard: UIView = {
        let view = UIView()
        view.backgroundColor = AppAppearance.background
        view.layer.cornerRadius = 14
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let colorSectionLabel: UILabel = {
        let l = UILabel()
        l.text = "Color"
        l.font = .systemFont(ofSize: 13, weight: .semibold)
        l.textColor = AppAppearance.secondaryText
        return l
    }()

    private lazy var colorsGrid: UIStackView = {
        let row = UIStackView(arrangedSubviews: colorButtons)
        row.axis = .horizontal
        row.spacing = 10
        row.distribution = .fillEqually
        return row
    }()

    private let completedLabel: UILabel = {
        let l = UILabel()
        l.text = "Done today"
        l.textColor = AppAppearance.primaryText
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        return l
    }()

    private let completedSwitch: UISwitch = {
        let s = UISwitch()
        s.onTintColor = AppAppearance.accent
        return s
    }()

    private let saveButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Save", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        b.backgroundColor = AppAppearance.accent
        b.tintColor = .white
        b.layer.cornerRadius = 16
        b.layer.cornerCurve = .continuous
        b.contentEdgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        return b
    }()

    private let rowSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = AppAppearance.background
        return view
    }()

    private let switchStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    private lazy var colorButtons: [ColorOptionButton] = colorOptions.map { hex in
        let button = ColorOptionButton(color: AppAppearance.habitAccent(hex: hex), hex: hex)
        button.addTarget(self, action: #selector(didTapColorOption(_:)), for: .touchUpInside)
        return button
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppAppearance.background

        let switchSpacer = UIView()
        switchSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        switchStack.addArrangedSubview(completedLabel)
        switchStack.addArrangedSubview(switchSpacer)
        switchStack.addArrangedSubview(completedSwitch)
        textFieldCard.addSubview(nameTextField)
        stackView.addArrangedSubview(nameSectionLabel)
        stackView.addArrangedSubview(textFieldCard)
        stackView.addArrangedSubview(colorSectionLabel)
        stackView.addArrangedSubview(colorsGrid)
        stackView.addArrangedSubview(rowSeparator)
        stackView.addArrangedSubview(switchStack)
        stackView.addArrangedSubview(saveButton)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(screenTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(previewTitleLabel)
        contentView.addSubview(previewCard)
        contentView.addSubview(formCard)
        formCard.addSubview(stackView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        screenTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        previewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        previewCard.translatesAutoresizingMaskIntoConstraints = false
        formCard.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldCard.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        rowSeparator.translatesAutoresizingMaskIntoConstraints = false

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

            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppAppearance.screenPadding - 4),

            screenTitleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 14),
            screenTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppAppearance.screenPadding),
            screenTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppAppearance.screenPadding),

            subtitleLabel.topAnchor.constraint(equalTo: screenTitleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: screenTitleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: screenTitleLabel.trailingAnchor),

            previewTitleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            previewTitleLabel.leadingAnchor.constraint(equalTo: screenTitleLabel.leadingAnchor),
            previewTitleLabel.trailingAnchor.constraint(equalTo: screenTitleLabel.trailingAnchor),

            previewCard.topAnchor.constraint(equalTo: previewTitleLabel.bottomAnchor, constant: 10),
            previewCard.leadingAnchor.constraint(equalTo: screenTitleLabel.leadingAnchor),
            previewCard.trailingAnchor.constraint(equalTo: screenTitleLabel.trailingAnchor),

            formCard.topAnchor.constraint(equalTo: previewCard.bottomAnchor, constant: 16),
            formCard.leadingAnchor.constraint(equalTo: screenTitleLabel.leadingAnchor),
            formCard.trailingAnchor.constraint(equalTo: screenTitleLabel.trailingAnchor),
            formCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),

            stackView.topAnchor.constraint(equalTo: formCard.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: formCard.bottomAnchor, constant: -16),

            textFieldCard.heightAnchor.constraint(equalToConstant: 52),
            nameTextField.leadingAnchor.constraint(equalTo: textFieldCard.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: textFieldCard.trailingAnchor, constant: -16),
            nameTextField.centerYAnchor.constraint(equalTo: textFieldCard.centerYAnchor),

            rowSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])

        nameTextField.addTarget(self, action: #selector(handleFormChanged), for: .editingChanged)
        completedSwitch.addTarget(self, action: #selector(handleSwitchChanged(_:)), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        updatePreview()
        updateSelectedColorUI()
    }

    @objc private func tapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapColorOption(_ sender: ColorOptionButton) {
        selectedColorHex = sender.hex
        updateSelectedColorUI()
        updatePreview()
    }

    @objc private func handleFormChanged() {
        updatePreview()
    }

    @objc private func handleSwitchChanged(_ sender: UISwitch) {
        saveButton.backgroundColor = sender.isOn ? AppAppearance.habitAccent(hex: selectedColorHex) : AppAppearance.accent
        updatePreview()
    }

    @objc private func saveTapped() {
        let trimmedName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !trimmedName.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "No text in name field", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
            return
        }

        let habit = HabitModel(id: UUID(), name: trimmedName, colorHex: selectedColorHex, completedToday: completedSwitch.isOn)

        onSave?(habit)
        navigationController?.popViewController(animated: true)
    }

    private func updatePreview() {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        previewCard.configure(name: name, colorHex: selectedColorHex, completedToday: completedSwitch.isOn)
    }

    private func updateSelectedColorUI() {
        colorButtons.forEach { button in
            button.setSelected(button.hex == selectedColorHex)
        }
        saveButton.backgroundColor = completedSwitch.isOn ? AppAppearance.habitAccent(hex: selectedColorHex) : AppAppearance.accent
    }
}

private final class ColorOptionButton: UIControl {
    let hex: String

    private let colorView = UIView()
    private let selectionRing = UIView()

    init(color: UIColor, hex: String) {
        self.hex = hex
        super.init(frame: .zero)

        selectionRing.layer.cornerRadius = 16
        selectionRing.layer.cornerCurve = .continuous
        selectionRing.layer.borderWidth = 2
        selectionRing.layer.borderColor = UIColor.clear.cgColor

        colorView.backgroundColor = color
        colorView.layer.cornerRadius = 12
        colorView.layer.cornerCurve = .continuous

        addSubview(selectionRing)
        selectionRing.addSubview(colorView)

        selectionRing.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48),

            selectionRing.topAnchor.constraint(equalTo: topAnchor),
            selectionRing.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionRing.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectionRing.bottomAnchor.constraint(equalTo: bottomAnchor),

            colorView.topAnchor.constraint(equalTo: selectionRing.topAnchor, constant: 4),
            colorView.leadingAnchor.constraint(equalTo: selectionRing.leadingAnchor, constant: 4),
            colorView.trailingAnchor.constraint(equalTo: selectionRing.trailingAnchor, constant: -4),
            colorView.bottomAnchor.constraint(equalTo: selectionRing.bottomAnchor, constant: -4)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSelected(_ isSelected: Bool) {
        selectionRing.layer.borderColor = isSelected
            ? AppAppearance.primaryText.cgColor
            : UIColor.clear.cgColor
        selectionRing.backgroundColor = isSelected
            ? AppAppearance.primaryText.withAlphaComponent(0.06)
            : .clear
    }
}
