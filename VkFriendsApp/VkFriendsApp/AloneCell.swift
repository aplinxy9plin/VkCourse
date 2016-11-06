import UIKit

class AloneCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView! {
        didSet {
            img.image = #imageLiteral(resourceName: "alone")
        }
    }
    
}
