import Foundation
import CoreLocation

class VkUser {
    let fio: String
    let city: String //might be city OR university OR online
    let avatarLink: String
    var location: CLLocation?
    
    init(fio: String, city: String, avaLink: String) {
        self.fio = fio
        self.city = city
        self.avatarLink = avaLink
    }
}
