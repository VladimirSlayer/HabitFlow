import UIKit

final class CreateHabitViewController: UIViewController {
    var onSave: ((HabitModel) -> Void)?

    private let colorOptions = ["#FF9500", "#34C759", "#007AFF", "#AF52DE", "#FF2D55", "#A2845E"]
    private var selectedColorHex = "#FF9500"

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

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Shape the card before you save it."
        l.font = .systemFont(ofSize: 16, weight: .medium)
        l.textColor = AppAppearance.secondaryText
        l.numberOfLines = 0
        return l
    }()

    private let previewTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Preview"
        l.font = .systemFont(ofSize: 15, weight: .semibold)
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
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        l.textColor = AppAppearance.secondaryText
        return l
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Habit name"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 18, weight: .semibold)
        textField.textColor = AppAppearance.primaryText
        return textField
    }()

    private let textFieldCard: UIView = {
        let view = UIView()
        view.backgroundColor = AppAppearance.background
        view.layer.cornerRadius = 18
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let colorSectionLabel: UILabel = {
        let l = UILabel()
        l.text = "Color"
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        l.textColor = AppAppearance.secondaryText
        return l
    }()

    private lazy var colorsGrid: UIStackView = {
        let firstRow = UIStackView(arrangedSubviews: Array(colorButtons.prefix(3)))
        firstRow.axis = .horizontal
        firstRow.spacing = 12
        firstRow.distribution = .fillEqually

        let secondRow = UIStackView(arrangedSubviews: Array(colorButtons.suffix(3)))
        secondRow.axis = .horizontal
        secondRow.spacing = 12
        secondRow.distribution = .fillEqually

        let grid = UIStackView(arrangedSubviews: [firstRow, secondRow])
        grid.axis = .vertical
        grid.spacing = 12
        return grid
    }()

    private let completedLabel: UILabel = {
        let completedLabel = UILabel()
        completedLabel.text = "Done today"
        completedLabel.textColor = AppAppearance.primaryText
        completedLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        return completedLabel
    }()

    private let completedSwitch = UISwitch()

    private let saveButton: UIButton = {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        saveButton.backgroundColor = AppAppearance.habitAccent(hex: "#7C6455")
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 18
        saveButton.layer.cornerCurve = .continuous
        saveButton.contentEdgeInsets = UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
        return saveButton
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
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        return stackView
    }()

    private lazy var colorButtons: [ColorOptionButton] = colorOptions.map { hex in
        let button = ColorOptionButton(color: AppAppearance.habitAccent(hex: hex), hex: hex)
        button.addTarget(self, action: #selector(didTapColorOption(_:)), for: .touchUpInside)
        return button
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppAppearance.background
        completedSwitch.onTintColor = AppAppearance.habitAccent(hex: "#7C6455")

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

            subtitleLabel.topAnchor.constraint(equalTo: screenTitleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: screenTitleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: screenTitleLabel.trailingAnchor),

            previewTitleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            previewTitleLabel.leadingAnchor.constraint(equalTo: screenTitleLabel.leadingAnchor),
            previewTitleLabel.trailingAnchor.constraint(equalTo: screenTitleLabel.trailingAnchor),

            previewCard.topAnchor.constraint(equalTo: previewTitleLabel.bottomAnchor, constant: 12),
            previewCard.leadingAnchor.constraint(equalTo: screenTitleLabel.leadingAnchor),
            previewCard.trailingAnchor.constraint(equalTo: screenTitleLabel.trailingAnchor),

            formCard.topAnchor.constraint(equalTo: previewCard.bottomAnchor, constant: 18),
            formCard.leadingAnchor.constraint(equalTo: screenTitleLabel.leadingAnchor),
            formCard.trailingAnchor.constraint(equalTo: screenTitleLabel.trailingAnchor),
            formCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),

            stackView.topAnchor.constraint(equalTo: formCard.topAnchor, constant: 18),
            stackView.leadingAnchor.constraint(equalTo: formCard.leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(equalTo: formCard.trailingAnchor, constant: -18),
            stackView.bottomAnchor.constraint(equalTo: formCard.bottomAnchor, constant: -18),

            textFieldCard.heightAnchor.constraint(equalToConstant: 58),
            nameTextField.leadingAnchor.constraint(equalTo: textFieldCard.leadingAnchor, constant: 18),
            nameTextField.trailingAnchor.constraint(equalTo: textFieldCard.trailingAnchor, constant: -18),
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
        saveButton.backgroundColor = sender.isOn ? AppAppearance.habitAccent(hex: selectedColorHex) : AppAppearance.habitAccent(hex: "#7C6455")
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
        saveButton.backgroundColor = completedSwitch.isOn ? AppAppearance.habitAccent(hex: selectedColorHex) : AppAppearance.habitAccent(hex: "#7C6455")
    }
}

private final class ColorOptionButton: UIControl {
    let hex: String

    private let colorView = UIView()
    private let selectionRing = UIView()

    init(color: UIColor, hex: String) {
        self.hex = hex
        super.init(frame: .zero)

        selectionRing.layer.cornerRadius = 18
        selectionRing.layer.cornerCurve = .continuous
        selectionRing.layer.borderWidth = 2
        selectionRing.layer.borderColor = AppAppearance.primaryText.withAlphaComponent(0.18).cgColor

        colorView.backgroundColor = color
        colorView.layer.cornerRadius = 14
        colorView.layer.cornerCurve = .continuous

        addSubview(selectionRing)
        selectionRing.addSubview(colorView)

        selectionRing.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56),

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
            : AppAppearance.primaryText.withAlphaComponent(0.18).cgColor
        selectionRing.backgroundColor = isSelected
            ? AppAppearance.primaryText.withAlphaComponent(0.06)
            : .clear
    }
}
