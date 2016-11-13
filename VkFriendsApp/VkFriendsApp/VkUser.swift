import Foundation
import CoreLocation
import MapKit

class VkUser: NSObject, MKAnnotation {

    public var coordinate: CLLocationCoordinate2D
    let id: String
    let fio: String
    let city: String //might be city OR university OR online
    let avatarLink: String
    var imageAvatar: UIImage?
    
    init(id: String, fio: String, city: String, avaLink: String, coords: CLLocationCoordinate2D) {
        self.id = id
        self.fio = fio
        self.city = city
        self.avatarLink = avaLink
        self.coordinate = coords
    }
    var title: String? {
        return fio
    }
    var subtitle: String? {
        return city
    }
}
