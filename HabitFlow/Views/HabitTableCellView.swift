import UIKit

final class HabitTableCellView: UITableViewCell {
    static let reuseIdentifier = "HabitTableViewCell"
    
    private let colorView = UIView()
    private let nameLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func configure(with habit: HabitModel) {
        nameLabel.text = habit.name
        statusLabel.text = habit.completedToday == true ? "Done today" : "Not done yet"
    }
    
    private func setupViews() {
        nameLabel.font = .systemFont(ofSize: 17)
        nameLabel.textColor = .label
        
        statusLabel.font = .systemFont(ofSize: 17)
        statusLabel.textColor = .label
        
        colorView.backgroundColor = .red
        colorView.layer.cornerRadius = 8
    }
    
    private func setupHierarchy() {
        contentView.addSubview(colorView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
    }
    
    private func setupLayout() {
        colorView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
