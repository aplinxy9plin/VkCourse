//
//  ViewController.swift
//  CalcDemo
//
//  Created by Michael Galperin on 23.09.16.
//
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var geometryStackView: UIStackView!
    @IBOutlet weak var btnFuncs: UIButton!
    @IBOutlet weak var algebraStackView: UIStackView!
    @IBOutlet weak var display: TextfieldInset!
    
    fileprivate var brain = CalcBrain()
    fileprivate var isInMiddleOfTyping = false
    fileprivate var displayValue: Double {
        get { return Double(display.text!)! }
        set { display.text = String(newValue) }
    }
    fileprivate let lblInfo: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        lbl.textColor = .red
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.text = "Функция"
        return lbl
    }()
}

extension CalculatorViewController {//user contacted
    @IBAction func touchedDigit(_ sender: UIButton) {
        guard let digit = sender.currentTitle else { return }
        if isInMiddleOfTyping {
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
            lblInfo.text = "Операция"
            setFuncTitle(with: symbol)
        }
        displayValue = brain.result
    }
    
    fileprivate func setFuncTitle(with title: String){
        btnFuncs.setTitle("\"\(title)\"", for: .normal)
        btnFuncs.setTitleColor(rgb(128, 0, 0), for: .normal)
        btnFuncs.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightLight)
    }
    
    @IBAction func touchedHelpers(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        setFuncTitle(with: title)
        switch title {
            case "C":
                displayValue = 0
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
        
        display.isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        setupBtnFuncsInfoLabel()
    }
    private func setupBtnFuncsInfoLabel(){
        btnFuncs.addSubview(lblInfo)
        lblInfo.topAnchor.constraint(equalTo: btnFuncs.topAnchor, constant: 6).isActive = true
        lblInfo.centerXAnchor.constraint(equalTo: btnFuncs.centerXAnchor).isActive = true
    }
    func orientationChanged(){
        let isLandscape = UIDevice.current.orientation.isLandscape
        geometryStackView.isHidden = isLandscape
        algebraStackView.isHidden = isLandscape
        
        let operationBtnColor = rgb(0, 122, 255)
        btnFuncs.setTitle(isLandscape ? "×" : "", for: .normal)
        btnFuncs.setTitleColor(isLandscape ? operationBtnColor : .black, for: .normal)
        btnFuncs.titleLabel?.font = UIFont.boldSystemFont(ofSize: isLandscape ? 35 : 15)
        btnFuncs.backgroundColor = isLandscape ? rgb(215, 215, 215) : rgb(233, 233, 233)
        lblInfo.text = isLandscape ? "" : "Функция"
    }
}

