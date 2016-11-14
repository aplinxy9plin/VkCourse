import UIKit
import SwiftyVK
import MapKit
import Fakery

extension UISegmentedControl {
    var index: Int { get { return self.selectedSegmentIndex } }
}

class MainController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let refresh = UIRefreshControl()
            refresh.addTarget(self, action: #selector(self.fetchFriends(refresh:)), for: .valueChanged)
            tableView.addSubview(refresh)
        }
    }
    @IBOutlet weak var btnExit: UIBarButtonItem!
    
    //TableView
    fileprivate struct CellIDs {
        static let vkList = "vklistCellID"
        static let alone = "vkAloneCellID"
    }
    fileprivate var tableData = [VkUser]()
    
    var executingUpdate: Bool = false
    enum AppObject { case Map, List }
    
    func performDisplay(object: AppObject){
        _ = [mapView, tableView].map{ $0.isHidden = true }
        switch object {
        case .Map:
            mapView.isHidden = false
            if mapView.annotations.count == 0 {
                friendsToMap()
            }
        case .List:
            tableView.isHidden = false
            if tableData.count == 0 {
                fetchFriends()
            }
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        performDisplay(object: sender.index == 0 ? .Map : .List)
    }
    
    @IBAction func btnExitTapped(_ sender: UIBarButtonItem) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Test alone mode", style: .default){act in
            self.mapView.removeAnnotations(self.tableData)
            self.tableData.removeAll()
            self.tableView.reloadData()
        })
        sheet.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
            VK.logOut()
            VK.logIn()
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in }))
        present(sheet, animated: true, completion: nil)
    }
}

// MARK: - Lifecycle
extension MainController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if VK.state != .authorized {
            VK.logIn()
        } else {
            btnExit.isEnabled = true
            segmentValueChanged(segmentedControl)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAuth), name: notif("auth_proceeded"), object: nil)
        
    }
    func handleAuth(){
        segmentValueChanged(segmentedControl)
        btnExit.isEnabled = true
        fetchFriends()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show profile screen", let dest = segue.destination as? ProfileController {
            dest.user = sender as! VkUser
            dest.title = "Profile"
            
            let back = UIBarButtonItem()
            back.title = mapView.isHidden ? "List" : "Map"
            navigationItem.backBarButtonItem = back
        }
    }
}

// MARK: - TableView
extension MainController: UITableViewDelegate, UITableViewDataSource {
    func fetchFriends(refresh: UIRefreshControl? = nil){//because it's datasource
        if VK.state != .authorized || executingUpdate { return }
        
        executingUpdate = true
        let faker = Faker(locale: "ru-RU")
        
        _ = VK.API.Friends.get([VK.Arg.fields: "city,photo_200,education"]).send(method: .GET, onSuccess: { (json) in
            
            DispatchQueue.main.async(execute: {
                refresh?.endRefreshing()
            })
            self.executingUpdate = false
            
            if json["items"].count > 0 {
                self.mapView.removeAnnotations(self.tableData)
                self.tableData.removeAll()
                
                for user in json["items"].arrayValue {
                    var city = user["city"]["title"].stringValue
                    if city == "" {
                        city = user["university_name"].stringValue
                        if city == "" {
                            city = user["online"].intValue == 0 ? "Offline" : "Online"
                        }
                    }
                    let location = CLLocationCoordinate2D(latitude: faker.address.latitude(), longitude: faker.address.longitude())
                    let friend = VkUser(id: user["id"].stringValue,fio: "\(user["first_name"].stringValue) \(user["last_name"].stringValue)", city: city, avaLink: user["photo_200"].stringValue, coords: location)
                    self.tableData.append(friend)
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.friendsToMap()
                })
            }
            }, onError: { (err) in
                print(err)
                DispatchQueue.main.async(execute: {
                    refresh?.endRefreshing()
                })
                self.executingUpdate = false
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count > 0 ? tableData.count : 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableData.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: CellIDs.alone, for: indexPath) as! AloneCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIDs.vkList, for: indexPath) as! FriendCell
        cell.user = tableData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableData.count > 0 {
            performSegue(withIdentifier: "show profile screen", sender: tableData[indexPath.row])
        }
   
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var itemsAtScreen: CGFloat = 7
        switch UIScreen.main.bounds.size.height {
            case 568: itemsAtScreen = 5 //5s
            case 1...567: itemsAtScreen = 4
            default: break
        }
        return tableView.frame.size.height / itemsAtScreen
    }
}

// MARK: - MKMapViewDelegate
extension MainController: MKMapViewDelegate {
    func friendsToMap(){
        
        if tableData.count > 0 {
            for user in tableData {
                if !mapView.annotations.contains(where: {$0.title! == user.title!}) {
                    mapView.addAnnotation(user)
                }
            }
            
            let lat = tableData.sorted(by: { (user1, user2) -> Bool in
                return user1.coordinate.latitude < user2.coordinate.latitude
            })
            let minLat = lat.first!.coordinate.latitude
            let maxLat = lat.last!.coordinate.latitude
            
            let lng = tableData.sorted(by: { (user1, user2) -> Bool in
                return user1.coordinate.longitude < user2.coordinate.longitude
            })
            let minLng = lng.first!.coordinate.longitude
            let maxLng = lng.last!.coordinate.longitude
            
            let center = CLLocationCoordinate2DMake((minLat + maxLat) / 2.0, (minLng + maxLng) / 2.0)
            mapView.setRegion(MKCoordinateRegionMake(center, MKCoordinateSpanMake(maxLat - minLat, maxLng - minLng)), animated: true)
            
        }
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let id = "pin"
        let btnInfo = UIButton.init(type: .detailDisclosure)
        
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView {
            view.rightCalloutAccessoryView = btnInfo
            view.canShowCallout = true
            view.annotation = annotation
            return view
        }
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
        view.canShowCallout = true
        view.rightCalloutAccessoryView = btnInfo
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let user = tableData.filter { (vk) -> Bool in
            return vk.title! + vk.subtitle! == view.annotation!.title!! + view.annotation!.subtitle!!
        }.first!
        performSegue(withIdentifier: "show profile screen", sender: user)
    }
}

