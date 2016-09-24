//
//  ViewController.swift
//  CalcDemo
//
//  Created by Michael Galperin on 23.09.16.
//
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var geometryStackView: UIStackView!
    @IBOutlet weak var btnFuncs: UIButton!
    @IBOutlet weak var algebraStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
}

extension ViewController {
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

