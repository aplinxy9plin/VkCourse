//
//  Library.swift
//  CalcDemo
//
//  Created by Michael Galperin on 24.09.16.
//
//

import UIKit

func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
    return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
}
