//
//  UIColor.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 03.04.18.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(intRed: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let r: CGFloat = CGFloat(intRed) / 255.0
        let g: CGFloat = CGFloat(green) / 255.0
        let b: CGFloat = CGFloat(blue) / 255.0
        let a: CGFloat = CGFloat(alpha) / 255.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    class func whiteSheep() -> UIColor {
        return UIColor(intRed: 255, green: 255, blue: 255, alpha: 150)
    }
    
    // //UIColor(red: 107, green: 163, blue: 36, alpha: 1).cgColor
    class func green4() -> UIColor {
        return UIColor(intRed: 107, green: 163, blue: 36, alpha: 255)
    }
}
