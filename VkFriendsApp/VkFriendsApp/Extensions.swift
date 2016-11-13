import Foundation
import MapKit

extension CGRect {
    func toMKMapRect() -> MKMapRect {
        let x = Double(self.origin.x)
        let y = Double(self.origin.y)
        let origin = MKMapPoint(x: x, y: y)
        
        let width = Double(self.size.width)
        let height = Double(self.size.height)
        let size = MKMapSize(width: width, height: height)
        
        return MKMapRect(origin: origin, size: size)
    }
}
