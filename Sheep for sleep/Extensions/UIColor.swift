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
    
    
    class func greenColor1() -> UIColor {
        return UIColor(intRed: 107, green: 164, blue: 37, alpha: 255)
    }
    
    class func greenColor11() -> UIColor {
        return UIColor(intRed: 120, green: 177, blue: 49, alpha: 255)
    }
    
    
    class func greenColor2() -> UIColor {
        return UIColor(intRed: 97, green: 136, blue: 55, alpha: 255)
    }
    class func greenColor22() -> UIColor {
        return UIColor(intRed: 107, green: 147, blue: 65, alpha: 255)
    }
    
    class func greenColor3() -> UIColor {
        return UIColor(intRed: 94, green: 131, blue: 60, alpha: 255)
    }
    class func greenColor33() -> UIColor {
        return UIColor(intRed: 104, green: 141, blue: 69, alpha: 255)
    }
    
    class func greenColor4() -> UIColor {
        return UIColor(intRed: 76, green: 115, blue: 101, alpha: 255)
    }
    class func greenColor44() -> UIColor {
        return UIColor(intRed: 85, green: 124, blue: 109, alpha: 255)
    }
    
    class func greenColor5() -> UIColor {
        return UIColor(intRed: 36, green: 103, blue: 104, alpha: 255)
    }
    class func greenColor55() -> UIColor {
        return UIColor(intRed: 45, green: 109, blue: 112, alpha: 255)
    }
    
    class func greenColor6() -> UIColor {
        return UIColor(intRed: 17, green: 92, blue: 90, alpha: 255)
    }
    class func greenColor66() -> UIColor {
        return UIColor(intRed: 29, green: 80, blue: 88, alpha: 255)
    }
    
    //in last screen
    class func greenColor7() -> UIColor {
        return UIColor(intRed: 1, green: 93, blue: 90, alpha: 255)
    }
    
    
    /*

 (225 222 216); овца2 (177 185 191); овца3 (186 177 191); овца4 (196 158 207); овца5 (150 115 160)
 */
    
    class func sheepColor1() -> UIColor {
        return UIColor(intRed: 255, green: 255, blue: 255, alpha: 255)
    }
    
    class func sheepColor2() -> UIColor {
        return UIColor(intRed: 225, green: 222, blue: 216, alpha: 255)
    }
    
    class func sheepColor3() -> UIColor {
        return UIColor(intRed: 177, green: 185, blue: 191, alpha: 255)
    }
    
    class func sheepColor4() -> UIColor {
        return UIColor(intRed: 186, green: 177, blue: 191, alpha: 255)
    }
    
    class func sheepColor5() -> UIColor {
        return UIColor(intRed: 196, green: 158, blue: 207, alpha: 255)
    }
    
    class func sheepColor6() -> UIColor {
        return UIColor(intRed: 150, green: 115, blue: 160, alpha: 255)
    }
    
    
    class func firstDayColor () -> UIColor {
        return UIColor(intRed: 93, green: 106, blue: 115, alpha: 255)
    }
    
    class func defoultSheepPointCellColor () -> UIColor {
        return UIColor(intRed: 184, green: 231, blue: 236, alpha: 255)
    }
    
    
    
    
    
}

extension UIColor {
   
    static func == (l: UIColor, r: UIColor) -> Bool {
        let approximation: CGFloat = 0.1
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        l.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        r.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        var aboutR = r2 - r1
        if aboutR < 0 { aboutR = aboutR * -1 }
        var aboutG = g2 - g1
        if aboutG < 0 { aboutG = aboutG * -1 }
        var aboutB = b2 - b1
        if aboutB < 0 { aboutB = aboutB * -1 }
        
        return aboutR < approximation && aboutG < approximation && aboutB < approximation
            //r1 == r2 && g1 == g2 && b1 == b2
    }
}
func == (l: UIColor?, r: UIColor?) -> Bool {
    let l = l ?? .clear
    let r = r ?? .clear
    return l == r
}
