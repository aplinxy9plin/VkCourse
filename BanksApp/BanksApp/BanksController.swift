import UIKit
import SwiftyJSON

class BanksController: UITableViewController {
    
    fileprivate let cellID = "bankLogoCell"
    fileprivate var data = [Bank]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "show about bank vc",
           let vc = segue.destination as? BankPlacesController,
           let path = tableView.indexPath(for: sender as! UITableViewCell)
        {
            let bank = data[path.row]
            vc.title = bank.title
            vc.bank = bank
        }
    }
    
}

extension BanksController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseBankData()
    }
    
    func parseBankData(){
        guard
            let path = Bundle.main.url(forResource: "ProjectData", withExtension: "json"),
            let jsonData = try? Data(contentsOf: path)
            else { return }
        let json = JSON(data: jsonData)
        
        _ = json["banks"].arrayValue.map {
            let rgb: [CGFloat] = $0["color"].stringValue.components(separatedBy: " ").map {CGFloat(Double($0)!) / 255}
            let bank = Bank($0["title"].stringValue, $0["imageName"].stringValue, UIColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1))
            let places = $0["places"].arrayValue.map { Place($0["street"].stringValue, $0["distance"].intValue, $0["workTime"].stringValue) }
            bank.places = places
            data.append(bank)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

extension BanksController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: data[indexPath.row].imageName) //just not for making a subclass
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height / CGFloat(data.count)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
