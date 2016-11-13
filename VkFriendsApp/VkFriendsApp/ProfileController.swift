import UIKit
import SwiftyVK
import SVProgressHUD
import Alamofire

typealias CountItem = (num: String, subtitle: String)
class ProfileController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblContent: UILabel! {
        didSet {
            lblContent.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        }
    }
    @IBOutlet weak var lblFio: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var collectionViewCounts: UICollectionView!
    
    var user: VkUser!
    var counters = [CountItem]()
    fileprivate let cellId = "countercellid"
    
    var task = VK.API.Users.get()
    
}

// MARK: - LifeCycle
extension ProfileController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if counters.count > 0 { return } //prevent twice loading
        
        lblFio.text = user.fio
        lblSubtitle.text = user.city
        if user.imageAvatar != nil {
            avatarImageView.image = user.imageAvatar
        } else {
            avatarImageView.image = #imageLiteral(resourceName: "camera_200")
            
            Alamofire.request(user.avatarLink).responseData(completionHandler: { (data) in
                if let imgData = data.data,
                   let img = UIImage(data: imgData){
                    self.user.imageAvatar = img
                    DispatchQueue.main.async {
                        self.avatarImageView.image = img
                    }
                }
            })
        }
        
        SVProgressHUD.show()
        task.addParameters([VK.Arg.userId: user.id, VK.Arg.fields: "photo_400_orig,counters"])
        task.send(method: HTTPMethods.GET, onSuccess: { [unowned self] json in
            
            let item = json.first!.1["counters"]
            self.counters.append(CountItem(item["friends"].stringValue, "friends"))
            self.counters.append(CountItem(item["photos"].stringValue, "photos"))
            self.counters.append(CountItem(item["videos"].stringValue, "video"))
            self.counters.append(CountItem(item["audios"].stringValue, "audio"))
            self.counters.append(CountItem(item["pages"].stringValue, "pages"))
            self.counters.append(CountItem(item["followers"].stringValue, "followers"))
            self.counters.append(CountItem(item["subscriptions"].stringValue, "subscriptions"))
            
            DispatchQueue.main.async {
                self.collectionViewCounts.reloadData()
            }
            
            SVProgressHUD.dismiss()
        }, onError: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        task.cancel()
        SVProgressHUD.dismiss()
    }
    
    @IBAction func btnSendTapped() {
        let alert = UIAlertController(title: "Not implemented yet", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - CollectionView
extension ProfileController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return counters.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = counters[indexPath.row].num
        (cell.viewWithTag(2) as! UILabel).text = counters[indexPath.row].subtitle
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let str = counters[indexPath.row].subtitle
        let rect = (str as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 50), options: NSStringDrawingOptions(), attributes: nil, context: nil)
        let multiplier: CGFloat = str.characters.count <= 6 ? 1.7 : 1.25
        return CGSize(width: rect.width * multiplier, height: 50)
    }
}
