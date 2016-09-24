//
//  ViewController.swift
//  CalcDemo
//
//  Created by Michael Galperin on 23.09.16.
//
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var geometryStackView: UIStackView!
    @IBOutlet weak var btnFuncs: UIButton!
    @IBOutlet weak var algebraStackView: UIStackView!
    @IBOutlet weak var display: TextfieldInset!
    
//    var displayValue: Double {
//        get {
//            return Double(display.text!)!
//        }
//        set {
//            display.text = String(newValue)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        display.isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @IBAction func touchedDigit(_ sender: UIButton) {
        
    }
    
    @IBAction func touchedHelpers(_ sender: UIButton) {
        let title = sender.currentTitle!
        switch title {
            case "C": display.text = "0"
            case "⬅︎": display.text = display.text!.characters.count > 1 ? String(display.text!.characters.dropLast()) : "0"
        default: break
        }
    }
    
}


//-Actions
extension CalculatorViewController {
    func orientationChanged(){
        let isLandscape = UIDevice.current.orientation.isLandscape
        geometryStackView.isHidden = isLandscape
        algebraStackView.isHidden = isLandscape
        
        let operationBtnColor = rgb(0, 122, 255)
        btnFuncs.setTitle(isLandscape ? "×" : "Funcs", for: .normal)
        btnFuncs.setTitleColor(isLandscape ? operationBtnColor : .black, for: .normal)
        btnFuncs.titleLabel?.font = UIFont.boldSystemFont(ofSize: isLandscape ? 35 : 15)
    }
}

