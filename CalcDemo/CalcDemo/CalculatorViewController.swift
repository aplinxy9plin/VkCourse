//
//  ViewController.swift
//  CalcDemo
//
//  Created by Michael Galperin on 23.09.16.
//
//

import UIKit

class CalculatorViewController: UIViewController {
    
    //
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var portraitStack: UIStackView!
    @IBOutlet weak var btnEquals: UIButton!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var landscapeUnderlayerView: UIView!
    @IBOutlet weak var landscapeBtnEquals: UIButton!
    @IBOutlet weak var landscapeBtnClear: UIButton!
    
    fileprivate var brain = CalcBrain()
    fileprivate var isInMiddleOfTyping = false
    fileprivate var displayValue: Double {
        get { return Double(display.text!)! }
        set {
            display.text = ["nan", "inf"].contains(String(newValue)) ? "Ошибка" : String(newValue)
            if display.text == "Ошибка" { isInMiddleOfTyping = false }
        }
    }
    /*fileprivate let lblInfo: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        lbl.textColor = .red
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.text = "Функция"
        return lbl
    }()*/
    var isPortrait: Bool { get { return UIApplication.shared.statusBarOrientation == .portrait }}
}

extension CalculatorViewController {//user contacted
    @IBAction func touchedDigit(_ sender: UIButton) {
        guard let digit = sender.currentTitle else { return }
        if isInMiddleOfTyping {
            if digit == "0" && display.text == "0" { return }
            if digit == "." {
                if !display.text!.contains("."){
                    display.text = display.text! + digit
                }
            } else {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
        }
        isInMiddleOfTyping = true
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        print(sender.currentTitle)
        if isInMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            isInMiddleOfTyping = false
        }
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol: symbol)
        }
        displayValue = brain.result
    }
    
    @IBAction func touchedHelpers(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        switch title {
            case "C":
                displayValue = 0
                brain.nullify()
            case "⬅︎":
                if display.text == "0.0" { break }
                display.text = display.text!.characters.count > 1 ? String(display.text!.characters.dropLast()) : "0.0"
        default: break
        }
        if display.text == "0.0" {
            isInMiddleOfTyping = false
        }
    }
}


extension CalculatorViewController {//View
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        setupLandscapeButtons()
        
    }
    private func setupLandscapeButtons(){
        landscapeBtnEquals.layer.borderColor = rgb(0, 121, 107).cgColor
        landscapeBtnEquals.layer.borderWidth = 1
        landscapeBtnClear.layer.borderColor = landscapeBtnEquals.layer.borderColor
        landscapeBtnClear.layer.borderWidth = landscapeBtnEquals.layer.borderWidth
    }
    func orientationChanged(){
        //Portrait
        portraitStack.isHidden = !isPortrait
        bottomStack.isHidden = !isPortrait
        btnEquals.isHidden = !isPortrait
        //Landscape
        landscapeUnderlayerView.isHidden = isPortrait //UnderlayerView
    }
}

