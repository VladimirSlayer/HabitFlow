import UIKit

final class HabitTableCellView: UITableViewCell {
    static let reuseIdentifier = "HabitTableViewCell"
    
    var onTapComplete: (() -> Void)?
    
    private let colorView = UIView()
    private let nameLabel = UILabel()
    private let statusLabel = UILabel()
    private let changeCompletionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.backgroundColor = .systemBlue
        button.imageView?.tintColor = .white
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBlue.cgColor
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupHierarchy()
        setupLayout()
        changeCompletionButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func configure(with habit: HabitModel) {
        nameLabel.text = habit.name
        statusLabel.text = habit.completedToday == true ? "Done today" : "Not done yet"
        changeCompletionButtonAppearance(habitCompleted: habit.completedToday)
        colorView.backgroundColor = UIColor(hex: habit.colorHex) ?? .tertiaryLabel
    }
    
    private func changeCompletionButtonAppearance(habitCompleted: Bool) {
        changeCompletionButton.backgroundColor = habitCompleted ? .systemBlue : .clear
        changeCompletionButton.imageView?.tintColor = habitCompleted ? .white : .systemBlue
    }
    
    @objc private func didTapComplete() {
        onTapComplete?()
    }
    
    private func setupViews() {
        nameLabel.font = .systemFont(ofSize: 17)
        nameLabel.textColor = .label
        
        statusLabel.font = .systemFont(ofSize: 17)
        statusLabel.textColor = .label
        
        colorView.layer.cornerRadius = 8
    }
    
    private func setupHierarchy() {
        contentView.addSubview(colorView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(changeCompletionButton)
    }
    
    private func setupLayout() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        changeCompletionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 16),
            colorView.heightAnchor.constraint(equalToConstant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            changeCompletionButton.widthAnchor.constraint(equalToConstant: 44),
            changeCompletionButton.heightAnchor.constraint(equalToConstant: 44),
            changeCompletionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            changeCompletionButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }
}
