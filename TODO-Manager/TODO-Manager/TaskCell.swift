import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskTextLabel: UILabel!
    @IBOutlet weak var priorityView: UIView!
    
    private let priorityColors = [0: AppDelegate().myGreen, 1: .clear, 2: .red]
    
    var task: Task! {
        didSet {
            taskTextLabel.text = task.text
            priorityView.backgroundColor = priorityColors[task.priority]
        }
    }
    
}
