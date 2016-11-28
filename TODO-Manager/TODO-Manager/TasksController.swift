import UIKit
import RealmSwift

class TasksController: UITableViewController {

    @IBOutlet weak var btnRemove: UIBarButtonItem! {
        didSet {
            btnRemove.title = NSLocalizedString("REMOVE_ALL", comment: "удаление задач")
        }
    }
    
    fileprivate struct CellIds {
        static let noTasks = "noTasksCellId"
        static let task = "taskCellId"
    }
    var data: Results<Task>! {
        didSet {
            btnRemove.isEnabled = data.count > 0
        }
    }
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 52
        tableView.rowHeight = UITableViewAutomaticDimension
        updateInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show newTaskVC", let dest = segue.destination as? NewTaskController {
            dest.homeController = self
        }
    }
    
    @IBAction func removeTapped(_ sender: UIBarButtonItem) {
        try! realm.write {
            realm.deleteAll()
        }
        updateInfo()
    }
    
}


// MARK: - Realm
extension TasksController {
    func updateInfo(loadOnly: Bool = false){
        data = realm.objects(Task.self).sorted(byProperty: "date", ascending: false)
        if !loadOnly {
            tableView.reloadData()
        }
    }
    
    func addTask(_ task: Task){
        try! realm.write {
            realm.add(task)
        }
    }
}


// MARK: - Delegate, Datasource
extension TasksController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.isEmpty ? 1 : data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if data.isEmpty {
            return tableView.dequeueReusableCell(withIdentifier: CellIds.noTasks, for: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.task, for: indexPath) as! TaskCell
        cell.task = data[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !data.isEmpty
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let btnTitle = NSLocalizedString("DONE", comment: "done")
	//RmxhZzogU0FSQ0FTTV9JU19JTlNJREVfUkVBRE1FIMKvXF8o44OEKV8vwq8gIA==
        let doneAction = UITableViewRowAction(style: .default, title: btnTitle) {_, _ in
            if self.data.count == 1 {//last
                self.removeTapped(self.btnRemove)
                return
            }
            try! self.realm.write {
                self.realm.delete(self.data[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateInfo(loadOnly: true)
        }
        doneAction.backgroundColor = AppDelegate().myGreen
        return [doneAction]
    }
}

