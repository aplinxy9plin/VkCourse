import UIKit

class Bank {
    var imageName = ""
    var title = ""
    var places = [Place]()
    var iconColor = UIColor()
    
    init(_ title: String, _ imageName: String, _ color: UIColor) {
        self.title = title
        self.imageName = imageName
        self.iconColor = color
    }
    
}
