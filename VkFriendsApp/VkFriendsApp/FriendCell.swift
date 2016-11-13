import UIKit
import Alamofire

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var imgAvatar: UIImageView! {
        didSet {
            imgAvatar.layer.masksToBounds = true
            imgAvatar.layer.cornerRadius = 32.5
        }
    }
    @IBOutlet weak var lblFio: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    var user: VkUser! {
        didSet {
            lblFio.text = user.fio
            lblCity.text = user.city

            Alamofire.request(user.avatarLink).responseData { (data) in
                if let imgData = data.data,
                   let img = UIImage(data: imgData){
                    self.user.imageAvatar = img
                    DispatchQueue.main.async { self.imgAvatar.image = img }
                }
            }
        }
    }
    
    override func prepareForReuse() {
        imgAvatar.image = #imageLiteral(resourceName: "camera_100")
    }
    
}
