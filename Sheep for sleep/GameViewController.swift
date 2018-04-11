//
//  GameViewController.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 18.03.18.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import Hero

class GameViewController: UIViewController {
    var sheepView: SheepView?
    @IBOutlet weak var textSwipe: UIImageView!
    @IBOutlet weak var circleView: UIView!

    @IBOutlet weak var fonImage: UIImageView!
    @IBOutlet weak var countLable: UILabel!
    
   
    @IBOutlet weak var firstMountain: UIView!
    @IBOutlet weak var secondMountain: UIView!
    @IBOutlet weak var thirdMountain: UIView!
    @IBOutlet weak var fourthMountain: UIView!
    @IBOutlet var starsBig: [StarBig]!
    
    @IBOutlet var starsSmall: [StarSmall]!
    
    var soundIsSwitchOn: Bool = true
    var player: AVAudioPlayer?
    
    var location: CGPoint = CGPoint(x: 0, y: 0)
    
    var p0 : CGPoint!
    var p1 : CGPoint!
    var p2 : CGPoint!
    var emojiCenter: CGPoint!
    var isFirst: Bool = true
    var countCheep: Int = 0
    
   // let currentSheep: UIImage = UIImage(named: "")!;
    
    
    var bezierPath = UIBezierPath()
    var bezierPathXMax: CGFloat!
    
    
    
    var startp0 : CGPoint!
    var startp1 : CGPoint!
    var startp2 : CGPoint!
    var startEmojiCenter: CGPoint!
    
    var startbezierPath = UIBezierPath()
    var startbezierPathXMax: CGFloat!
    
    
    var finishp0 : CGPoint!
    var finishp1 : CGPoint!
    var finishp2 : CGPoint!
    var finishEmojiCenter: CGPoint!
    
    //first
    var finishbezierPath = UIBezierPath()
    //last
    var thirdBezierPath = UIBezierPath()
    
  
    var fourthBezierPath = UIBezierPath()
    
    var finishbezierPathXMax: CGFloat!
    
    
    var arrow: Arrow!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        drawBezierPath()
        createNewSheep()
       // startPlaySound()
    
        drawBezierPathStart()
        
        //moveSheep()

        
        let arrow: Arrow = UIView.instantiateFromNib()
        let sheepFrame = sheepView?.sheepImage.frame ?? CGRect.zero
        let originY = self.view.frame.height - sheepFrame.height - 120
        
        arrow.frame = CGRect(x: sheepFrame.width - 70, y: originY, width: 45, height: 65)
        self.view.addSubview(arrow)
        self.arrow = arrow
        
    }
    
    
    func startPlaySound() {
        guard let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.play()
            player.numberOfLoops = -1
        } catch let error {
            print(error.localizedDescription)
        }
    }
    

    @IBAction func SoundTurn(_ sender: UIButton) {
        soundIsSwitchOn = !soundIsSwitchOn
        if soundIsSwitchOn {
            sender.setImage(UIImage(named: "SoundOff"), for: .normal)
            player?.play()
        } else {
            sender.setImage(UIImage(named: "SoundOn"), for: .normal)
            player?.stop()
        }
    }
    
    func createCircle() {

        let desiredLineWidth: CGFloat = 4    // your desired value
        let hw :CGFloat = desiredLineWidth/2
        let circlePath = UIBezierPath(ovalIn: circleView.bounds.insetBy(dx:hw,dy:hw))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.whiteSheep().cgColor
        shapeLayer.lineWidth = 10
        circleView.layer.addSublayer(shapeLayer)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func createNewSheep() {
        let sheepView: SheepView = UIView.instantiateFromNib()
        sheepView.bezierPath = bezierPath
        sheepView.p0 = p0
        sheepView.p1 = p1
        sheepView.p2 = p2
        sheepView.emojiCenter = p0
        sheepView.bezierPathXMax = bezierPathXMax
        
        sheepView.sheepImage.loadGif(name: "sheep_1@3x")
        
        sheepView.frame = CGRect(x: -100, y:  -100, width: 180, height: 2000)
        sheepView.center = CGPoint(x: p0.x - 100, y: p0.y)
        sheepView.delegate = self
        
        self.sheepView = sheepView
        self.view.addSubview(sheepView)
        moveToStart(view: sheepView)
    }
    

    
    
    
    func moveToStart(view: UIView) {
        UIView.animate(withDuration: 1.2, animations: {
            view.center = self.p0
        })
    }
    
    //TODO: remove
    func moveToEnd(view: UIView) {
        var newCenter = view.center
        newCenter.x = self.view.frame.width + 120
        UIView.animate(withDuration: 2, animations: {
            view.center = newCenter
            self.view.layoutIfNeeded()
        }) { (_) in
            view.isHidden = true
            //view.removeFromSuperview()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    
    func moveSheep() {
        let image = UIImage(named: "MovingSheep")
        let newSheep = UIImageView(image: image)
        newSheep.frame = CGRect(origin: finishp0, size: CGSize(width: 50, height: 50))
        newSheep.transform = CGAffineTransform(scaleX: -1, y: 1)
        self.secondMountain.addSubview(newSheep)
        automaticMoving(view: newSheep)
    }
    
    private func automaticMoving(view: UIView) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            view.center = self.p2
            //self.sheepLeave()
        })
        let animation = CAKeyframeAnimation(keyPath: "position")
        let newBezierPath = UIBezierPath()

        newBezierPath.move(to: finishp2)
        let distanceXInRange = 0.6
        
        let finishX = getPointAtPercent(t: Float(distanceXInRange), start: Float(finishp2.x) , c1: Float(finishp1.x), end: Float(finishp0.x))
        let finishY = getPointAtPercent(t: Float(distanceXInRange), start: Float(finishp2.y) , c1: Float(finishp1.y), end: Float(finishp0.y))
        let finishPoint = CGPoint(x: CGFloat(finishX), y: CGFloat(finishY))
        
        let controlPoint = CGPoint(x: self.view.frame.maxX/1.8, y: self.view.frame.maxY/3.5)
    
  
        
        newBezierPath.addQuadCurve(to: finishPoint, controlPoint: controlPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = newBezierPath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 3.0
        self.view.layer.addSublayer(shapeLayer)
        
        
   //finishp0
      
        animation.path = newBezierPath.cgPath
        
        animation.fillMode              = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration              = 10
        animation.timingFunction        = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        
        view.layer.add(animation, forKey:"trash")
        
        CATransaction.commit()
    }
    
    
    
    private func sheepLeave() {
        let image = UIImage(named: "MovingSheep")
        let newSheep = UIImageView(image: image)
        newSheep.frame = CGRect(origin: finishp0, size: CGSize(width: 50, height: 50))
        thirdMountain.addSubview(newSheep)

        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
           
        })
        let animation = CAKeyframeAnimation(keyPath: "position")
        let newBezierPath = UIBezierPath()
        newBezierPath.move(to: startp0)
        newBezierPath.addQuadCurve(to: startp2, controlPoint: startp1)
        animation.path = newBezierPath.cgPath
        // The other animations properties
        animation.fillMode              = kCAFillModeForwards
        //kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration              = 10
        animation.timingFunction        = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        // Apply it
        newSheep.layer.add(animation, forKey:"trash")
        
        CATransaction.commit()
        
    }
    
    
    func drawBezierPathStart() {
/*
        //2
        var shapeLayer = CAShapeLayer()
        var newshapeLayer = CAShapeLayer()

        shapeLayer = CAShapeLayer()
       
        finishp0 = CGPoint(x: -250, y: self.view.frame.maxY )
        finishp2  = CGPoint(x: self.view.frame.maxX + 100 , y: self.view.frame.maxY )
        finishp1 = CGPoint(x: self.view.frame.maxX/1.8, y: self.view.frame.maxY/4)
        
        finishbezierPath.move(to: finishp0)
        finishbezierPath.addQuadCurve(to: finishp2, controlPoint: finishp1)
        startbezierPathXMax = finishp2.x - finishp0.x
        

        shapeLayer.path = finishbezierPath.cgPath
        shapeLayer.fillColor = UIColor(intRed: 132, green: 192, blue: 58, alpha: 255).cgColor
        shapeLayer.strokeColor = UIColor(intRed: 132, green: 192, blue: 58, alpha: 255).cgColor
        
        firstMountain.layer.addSublayer(shapeLayer)
        
        //1
        newshapeLayer = CAShapeLayer()
        startp0 = CGPoint(x: -50, y: self.view.frame.maxY )
        startp2  = CGPoint(x: self.view.frame.maxX + 100 , y: self.view.frame.maxY )
        startp1 = CGPoint(x: self.view.frame.maxX/2, y: self.view.frame.maxY - 255)
        
        startbezierPath.move(to: startp0)
        startbezierPath.addQuadCurve(to: startp2, controlPoint: startp1)
        
        
        newshapeLayer.path = startbezierPath.cgPath

        newshapeLayer.fillColor = UIColor(intRed: 152, green: 217, blue: 71, alpha: 255).cgColor
        
        newshapeLayer.strokeColor = UIColor(intRed: 152, green: 217, blue: 71, alpha: 255).cgColor

        secondMountain.layer.addSublayer(newshapeLayer)
        
        
        
        //4
        newshapeLayer = CAShapeLayer()
        startp0 = CGPoint(x: -100, y: self.view.frame.maxY )
        startp2  = CGPoint(x: self.view.frame.maxX * 2 , y: self.view.frame.maxY)
        startp1 = CGPoint(x: self.view.frame.maxX/1.2, y: self.view.frame.maxY/20)
        startbezierPathXMax = startp2.x - startp0.x
        
        thirdBezierPath.move(to: startp0)
        thirdBezierPath.addQuadCurve(to: startp2, controlPoint: startp1)
        newshapeLayer.path = thirdBezierPath.cgPath
        
        
        newshapeLayer.fillColor =  UIColor(intRed: 120, green: 176, blue: 48, alpha: 255).cgColor
        newshapeLayer.strokeColor =  UIColor(intRed: 120, green: 176, blue: 48, alpha: 255).cgColor
        newshapeLayer.lineWidth = 3.0
        
        thirdMountain.layer.addSublayer(newshapeLayer)
        
        //3
        newshapeLayer = CAShapeLayer()
        let p0 = CGPoint(x: self.view.frame.maxX * -1.5, y: self.view.frame.maxY )
        let p2  = CGPoint(x: self.view.frame.maxX , y: self.view.frame.maxY)
        let p1 = CGPoint(x: self.view.frame.maxX/3, y: self.view.frame.maxY/20)
        
        fourthBezierPath.move(to: p0)
        fourthBezierPath.addQuadCurve(to: p2, controlPoint: p1)
        newshapeLayer.path = fourthBezierPath.cgPath
        
        newshapeLayer.fillColor = UIColor.green4().cgColor
        newshapeLayer.strokeColor = UIColor.green4().cgColor
        
        fourthMountain.layer.addSublayer(newshapeLayer)*/
    }
    

    func drawBezierPath() {

        p0 = CGPoint(x: self.view.frame.origin.x - 5, y: self.view.frame.maxY - 150 )
        
        p2  = CGPoint(x: self.view.frame.maxX - 60 , y: self.view.frame.maxY - 120 )

        p1 = CGPoint(x: self.view.frame.width/3, y: self.view.frame.height/2)
        
        bezierPath.move(to: p0)
        bezierPath.addQuadCurve(to: p2, controlPoint: p1)
        bezierPathXMax = p2.x - p0.x
        
        /*
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 3.0
        view.layer.addSublayer(shapeLayer)*/
    }
    
    func halfPoint1D(p0: CGFloat, p2: CGFloat, control: CGFloat) -> CGFloat {
        return 2 * control - p0 / 2 - p2 / 2
    }
    var delay: CGFloat = 0.2
    
    func changeeBackground() {
        if countCheep >= 60 {
            UIView.transition(with: fonImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: { self.fonImage.image = UIImage(named: "GameFon6") },
                              completion: nil)
            Hero.shared.defaultAnimation = .fade
            let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC3")
            greenVC.hero.isEnabled = true
            performSegue(withIdentifier: "second", sender: nil)
            
            return
        }
        if countCheep >= 50 {
            UIView.transition(with: fonImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: { self.fonImage.image = UIImage(named: "GameFon5") },
                              completion: nil)
            return
        }
        if countCheep >= 40 {
            UIView.transition(with: fonImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: { self.fonImage.image = UIImage(named: "GameFon4") },
                              completion: nil)
            starsBig.forEach({
                delay *= 7
                let cdelay = floor(delay)
                let starDelay = delay - cdelay
                $0.startAnimation(with: starDelay)}
            )
            starsSmall.forEach({
                delay *= 7
                let cdelay = floor(delay)
                let starDelay = delay - cdelay
                $0.startAnimation(with: starDelay)
                
            })
          
            return
        }
        if countCheep >= 30 {
            UIView.transition(with: fonImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: { self.fonImage.image = UIImage(named: "GameFon3") },
                              completion: nil)
            
            Hero.shared.defaultAnimation = .fade
            let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC2")
            greenVC.hero.isEnabled = true
            performSegue(withIdentifier: "first", sender: nil)
   
            //self.hero.replaceViewController(with: greenVC)
            
            return
        }
        if countCheep >= 20 {
            UIView.transition(with: fonImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: { self.fonImage.image = UIImage(named: "GameFon2") },
                              completion: nil)
            
           
          
            return
        }
        if countCheep >= 10 {
            
            fonImage.image = UIImage(named: "GameFon1")
            
        }
    }
    
}




extension GameViewController: MovedSheep {
    func endMove(view: UIView) {
        self.sheepView?.removeFromSuperview()
       // moveToEnd(view: view)
        createNewSheep()
        moveSheep()
        countCheep += 5
        countLable.text = "\(countCheep)"
        if countCheep < 61 &&  countCheep % 10 == 0 {
            changeeBackground()
        }
    }
    
    func firstTouch() {
        if isFirst {
            isFirst = false
            UIView.animate(withDuration: 0.7, animations: {
                self.arrow.alpha = 0
                self.textSwipe.alpha = 0
            }) { (_) in
                self.arrow.removeFromSuperview()
                self.textSwipe.removeFromSuperview()
                self.createCircle()
                self.countLable.isHidden = false
            }
        }
    }
}
