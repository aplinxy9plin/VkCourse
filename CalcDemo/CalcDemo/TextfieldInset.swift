import UIKit

class TextfieldInset: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x - 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
}
