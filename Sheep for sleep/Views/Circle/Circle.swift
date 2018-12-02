//
//  Circle.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 31.03.18.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

class Circle: UIView {
    @IBOutlet weak var circleView: UIView!
    //defoult - 120 move - 180
    @IBOutlet weak var countLable: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircle()
    }
    
    func createCircle() {
        let circlePath = UIBezierPath(arcCenter: circleView.center, radius: CGFloat(circleView.frame.width/2), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3.0
        circleView.layer.addSublayer(shapeLayer)
    }
    
    func checkDarkColor() {
        countLable.textColor = UIColor(red: 153, green: 124, blue: 184, alpha: 255)
        circleView.backgroundColor = UIColor(red: 153, green: 124, blue: 184, alpha: 255)
    }
    
}

