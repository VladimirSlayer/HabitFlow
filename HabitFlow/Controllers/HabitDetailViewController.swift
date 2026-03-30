import UIKit

final class HabitDetailViewController: UIViewController {
    private let selectedHabit: HabitModel
    
    init(selectedHabit: HabitModel) {
        self.selectedHabit = selectedHabit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = selectedHabit.name
    }
}
