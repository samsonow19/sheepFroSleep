//
//  Mountains.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 11.04.18.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

class Mountains: UIView {
    var startp0 : CGPoint!
    var startp1 : CGPoint!
    var startp2 : CGPoint!

    
    var startbezierPath = UIBezierPath()
    var startbezierPathXMax: CGFloat!
    
    
    
    func firstMountain() {
        /*
        guard let view = self.superview else { return }
        
        let newshapeLayer = CAShapeLayer()
        startp0 = CGPoint(x: -100, y: view.frame.maxY )
        startp2  = CGPoint(x: view.frame.maxX * 2 , y: view.frame.maxY)
        startp1 = CGPoint(x: view.frame.maxX/1.2, y: view.frame.maxY/20)
        startbezierPathXMax = startp2.x - startp0.x
        
        thirdBezierPath.move(to: startp0)
        thirdBezierPath.addQuadCurve(to: startp2, controlPoint: startp1)
        newshapeLayer.path = thirdBezierPath.cgPath
        
        newshapeLayer.fillColor =  UIColor(intRed: 120, green: 176, blue: 48, alpha: 255).cgColor
        newshapeLayer.strokeColor =  UIColor(intRed: 120, green: 176, blue: 48, alpha: 255).cgColor
        newshapeLayer.shadowRadius = 3
        newshapeLayer.shadowOpacity = 0.3
        newshapeLayer.lineWidth = 3.0
        
        self.layer.addSublayer(newshapeLayer)*/
    }
    
}
