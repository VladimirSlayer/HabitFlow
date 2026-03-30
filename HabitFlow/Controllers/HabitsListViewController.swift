import UIKit

final class HabitsListViewController: UIViewController {
    
    private var habitsMock: [HabitModel] = [
        HabitModel(id: UUID(), name: "Чтение", colorHex: "#FF9500", completedToday: false),
        HabitModel(id: UUID(), name: "Тренировка", colorHex: "#34C759", completedToday: true),
        HabitModel(id: UUID(), name: "Вода", colorHex: "#007AFF", completedToday: false)
    ]
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Привычки"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapAdd))
        setupTableView()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HabitTableCellView.self, forCellReuseIdentifier: HabitTableCellView.reuseIdentifier)
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupLayout(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            
        ])
    }
    
    @objc private func didTapAdd(){
        print("Tapped add")
        let createHabitVC = CreateHabitViewController()
        createHabitVC.onSave = { [weak self] newHabit in
            self?.habitsMock.append(newHabit)
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(createHabitVC, animated: true)
    }
}

extension HabitsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        habitsMock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitTableCellView.reuseIdentifier, for: indexPath) as! HabitTableCellView
        let habit = habitsMock[indexPath.row]
        
        cell.configure(with: habit)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habitsMock[indexPath.row]
        let habitVC = HabitDetailViewController(selectedHabit: habit)
        navigationController?.pushViewController(habitVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

