import UIKit

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

            if let url = URL(string: user.avatarLink){
                URLSession.shared.dataTask(with: url, completionHandler: { (data, resp, error) in
                    if error != nil { print(error!); return }
                    
                    guard let data = data else { return }
                    if let img = UIImage(data: data){
                        DispatchQueue.main.async { self.imgAvatar.image = img }
                    }
                }).resume()
            }
        }
    }
    
    override func prepareForReuse() {
        imgAvatar.image = #imageLiteral(resourceName: "camera_100")
    }
    
}
