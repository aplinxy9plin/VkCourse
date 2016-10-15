import UIKit

class BankPlacesController: UIViewController {
    
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var frontView: UIImageView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    fileprivate let cellId = "cellID"
    
    var bank: Bank!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = bank.iconColor
        backView.image = UIImage(named: bank.imageName)
        frontView.image = backView.image
    }
    
}

extension BankPlacesController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bank.places.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let place = bank.places[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = bank.iconColor
        cell.textLabel?.text = place.street
        cell.detailTextLabel?.text = "\(place.distance) м. ··· Время работы: \(place.workTime)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//next here might be an MCV with Google map for each address and its description
