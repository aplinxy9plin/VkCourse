//
//  CalcButton.swift
//  CalcDemo
//
//  Created by Michael Galperin on 29.09.16.
//
//

import UIKit

class CalcButton: UIButton {
    
    private var defaultColor: UIColor!
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = .gray
            } else {
                backgroundColor = defaultColor
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultColor = backgroundColor
    }
}
