import Foundation

class Place {
    var street = ""
    var distance = 0
    var workTime = ""
    
    init(_ street: String, _ distance: Int, _ workTime: String){
        self.street = street
        self.distance = distance
        self.workTime = workTime
    }
    
}
