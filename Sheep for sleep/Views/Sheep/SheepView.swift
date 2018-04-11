//
//  SheepView.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 18.03.18.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

class SheepView: UIView {
    var  lastLocation = CGPoint ( x : 0 , y : 0 )
    @IBOutlet weak var sheepImage: UIImageView!
    //defoult - 120 move - 180
    @IBOutlet weak var widthConstaraint: NSLayoutConstraint!
    var widthDefoult: CGFloat = 120
    var widthMove: CGFloat = 185
    var p0: CGPoint!
    var p1: CGPoint!
    var p2: CGPoint!
    var emojiCenter: CGPoint!

    var bezierPath: UIBezierPath!
    var bezierPathXMax: CGFloat!
    var active: Bool = true
    weak var delegate: MovedSheep?
    var isMoving: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.superview)
        self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
    }
    
    override func touchesBegan(_ touches: (Set<UITouch>!), with event: UIEvent!) {
        super.touchesBegan(touches, with: event)

        delegate?.firstTouch()

 
        sheepImage.image = UIImage(named: "MovingSheep")
        widthConstaraint.constant = widthMove
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let point = touches.first!.location(in: superview!)
        let distanceX = point.x - emojiCenter.x
        if point.x < 35 {
            return
        }
        
        var distanceXInRange = distanceX / bezierPathXMax
        distanceXInRange = distanceXInRange > 0 ? distanceXInRange : -distanceXInRange
        print(distanceXInRange)
        if distanceXInRange >= 1 || distanceXInRange <= 0 {
            return
        }
  
        let newY = getPointAtPercent(t: Float(distanceXInRange), start: Float(p0.y) , c1: Float(p1.y), end: Float(p2.y))
        
        let newX = getPointAtPercent(t: Float(distanceXInRange), start: Float(p0.x) , c1: Float(p1.x), end: Float(p2.x))
        
        if distanceXInRange > 0.6 && active {
            active = false

            automaticMoving(x: newX, y: newY)
        } else {
            
            // set the newLocation of the emojiview
            self.center = CGPoint(x: CGFloat(newX), y: CGFloat(newY))
        }
        
    }
    
    private func automaticMoving(x: Float, y: Float) {

        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.center = self.p2
            self.sheepLeave()
        })
        let animation = CAKeyframeAnimation(keyPath: "position")
        let newBezierPath = UIBezierPath()
        newBezierPath.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
        newBezierPath.addLine(to: p2)
        animation.path = newBezierPath.cgPath

        animation.fillMode              = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration              = 0.8
        animation.timingFunction        = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)

        self.layer.add(animation, forKey:"trash")
        
        CATransaction.commit()
    }
    
    private func sheepLeave() {
        var newPosition = p2
        newPosition?.x = 1000
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
            self.center = newPosition!
            self.delegate?.endMove(view: self)
        })
        let animation = CAKeyframeAnimation(keyPath: "position")
        let newBezierPath = UIBezierPath()
        newBezierPath.move(to: p2)
        
        newBezierPath.addLine(to: newPosition!)
        animation.path = newBezierPath.cgPath
        // The other animations properties
        animation.fillMode              = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration              = 1.5
        animation.timingFunction        = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        // Apply it
        self.layer.add(animation, forKey:"trash")
        
        CATransaction.commit()
        
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if active {
            UIView.animate(withDuration: 0.3, animations: {
                self.center = self.p0
            })
            sheepImage.loadGif(name: "sheep_1@3x")
            widthConstaraint.constant = widthDefoult
        }
    }
    
    func getPointAtPercent(t: Float, start: Float, c1: Float, end: Float ) -> Float {
        let t_: Float = (1.0 - t)
        let tt_: Float = t_ * t_
        let tt: Float = t * t
        
        return start * tt_
            + 2.0 * c1 * t_ * t
            + end * tt
    }
    
}

protocol MovedSheep: class {
    func endMove(view: UIView)
    func firstTouch()
}
