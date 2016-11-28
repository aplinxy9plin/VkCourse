import UIKit
import RealmSwift

class NewTaskController: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var txtTask: UITextField!
    
    var homeController: TasksController?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        txtTask.becomeFirstResponder()
    }
    
    @IBAction func btnSaveTapped(_ sender: UIBarButtonItem) {
        guard let text = txtTask.text, text != "" else {
            let alertTitle = NSLocalizedString("ENTER_DESC", comment: "введите задачу")
            let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let dict = [0: TaskPriority.Low, 1: .Average, 2: .High]
        let task = Task(date: NSDate(), text: text, priority: dict[segment.selectedSegmentIndex]!)
        
        homeController?.addTask(task)
        homeController?.updateInfo()
        
        txtTask.resignFirstResponder()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15){[unowned self] in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
