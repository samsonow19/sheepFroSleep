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
import CoreData
import PromiseKit


extension GameViewController: HandlerApp {
    func appDidBecomeActive() {
        if countCheep >= 40 {
            startAnimationStars()
        }
    }
}

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
    @IBOutlet weak var containerSheeps: UIView!
    
    @IBOutlet weak var viewForSheeps: UIView!
    var defaultSheepImageName: String = "DefaultSheepDark1"
    var movingSheepImageName: String = "MovingSheepDark1"
    let durationAutomaticMoving: CFTimeInterval = 4
    
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
    
    var lastXforHeard: Int = 0
    var topforHeard: CGFloat = -20
    var leftforHeard: Int = 0
    var topLastRow: CGFloat = 0
    let densityHeard = 25
    var indentHerd: Int = 0
    
    var rowHeard: Int = 1
    var firstInHeard: Bool = true
    var nextRowStart = 20
    
    var currentGifForSheep: String = "sheep_1@3x"
    var currenSheepRun: String = "sheepRun1"
    var currentHerdSheep: String = "HerdSheep1"
    
    var conteinerViewSheep: [UIImageView] = []
    var conteinerViewSheepIsHiden: [Bool] = []

    
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
    
    var topThirdRow: CGFloat = 0
    var topFourthRow: CGFloat = 0
    var topNextRow: CGFloat = 0

    @IBAction func fastStart(_ sender: Any) {
        performSegue(withIdentifier: "nextGame", sender: nil)
        
    }
    override func viewDidLoad() {
        HandlerAppDelegate.sharedInstance.delegate = self
        super.viewDidLoad()
        startSheepInHerd(0)
        lastXforHeard = Int(UIScreen.main.bounds.width - CGFloat(indentHerd))
            //Int(fonImage.frame.width) - 50
        
        self.navigationController?.navigationBar.isHidden = true
        drawBezierPath()
        createNewSheep()
        startPlaySound()

    }
    

    
    private func startSheepInHerd(_ count: Int) {
        
        var wight = Int(UIScreen.main.bounds.width / 2)
        var count = count
        while true {
            wight -= densityHeard
            if wight < 0 {
                break
            }
            count += 1
        }
        
        let lenghtHerd = densityHeard * count * 2
        
        indentHerd = (Int(UIScreen.main.bounds.width) - lenghtHerd) / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        player(with: soundIsSwitchOn)
        
        if countCheep >= 40 {
            startAnimationStars()
        }
        self.navigationController?.navigationBar.isHidden = true

       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.stop()
    }
    
    private func addSheepInHerd() {
        
        let maxY = viewForSheeps.frame.origin.y
        let maxX = lastXforHeard
        lastXforHeard -= densityHeard
        let startPoint = CGPoint(x: maxX, y: Int(maxY))
        self.addTo(point: findGrinPicksell(point: startPoint), maxX: maxX)

    }
    
    private func addTo(point: CGPoint, maxX: Int) {

        let image = UIImage(named: currentHerdSheep)!
        let newSheep = UIImageView(image: image)
        newSheep.isHidden = true
        conteinerViewSheep.append(newSheep)
        conteinerViewSheepIsHiden.append(true)
        newSheep.frame = CGRect.zero
        
        self.thirdMountain.insertSubview(newSheep, at: 200)
        
        var findPoint = point
        let size = CGSize(width: 50, height: 50)
      
        
        findPoint.y += topforHeard
        
        if rowHeard == 3 {
            findPoint.y = topThirdRow
        }
        
        if rowHeard == 4 {
            findPoint.y = topFourthRow
        }
        
        if rowHeard > 4 {
            findPoint.y = topNextRow
        }
        
        if maxX < indentHerd + 10 {
            rowHeard += 1
            if rowHeard == 4 {
                topLastRow = 0
                startSheepInHerd(0)
                lastXforHeard = Int(UIScreen.main.bounds.width - CGFloat(indentHerd))
                topFourthRow = findPoint.y - 25

            }
            
            if rowHeard == 3 {
                startSheepInHerd(0)
                lastXforHeard = Int(UIScreen.main.bounds.width - CGFloat(indentHerd))
                topThirdRow = findPoint.y - 5
            }
            if rowHeard == 2 {
                startSheepInHerd(0)
                lastXforHeard = Int(UIScreen.main.bounds.width - CGFloat(indentHerd))
                topforHeard -= 25
            }
            
            if rowHeard > 4 {
                
                let indent: CGFloat
                if rowHeard % 2 == 0 {
                    indent = CGFloat(indentHerd)
                } else {
                    indent = CGFloat(indentHerd - 12)
                }
                
                startSheepInHerd(0)
                lastXforHeard = Int(UIScreen.main.bounds.width - indent)
                topNextRow = findPoint.y - 25
                createCircle(color: #colorLiteral(red: 0.6, green: 0.4862745098, blue: 0.7215686275, alpha: 1))
                countLable.textColor = #colorLiteral(red: 0.6, green: 0.4862745098, blue: 0.7215686275, alpha: 1)
                
                if findPoint.y < viewForSheeps.frame.origin.y {
                    performSegue(withIdentifier: "nextGame", sender: nil)
                    return
                }
                
            }
            
        }
        newSheep.frame = CGRect(origin: findPoint, size: size)
        newSheep.center = findPoint
        self.thirdMountain.sendSubview(toBack: newSheep)
    }
    
    private func findGrinPicksell(point: CGPoint) -> CGPoint {
        var nextPoint = point
        nextPoint.y += 3
        let color = fonImage.layer.colorOfPoint(point: point)

        let currentColorFirst = currentColorMountainFirst()
        let currentColorSecond = currentColorMountainSecond()

        if nextPoint.y > UIScreen.main.bounds.height {
            return point
        }
        
        // sheepColorInView == currentSheepColor
        if color == currentColorFirst || color == UIColor.greenColor7() || color == currentColorSecond {
            return point
        } else {
            return findGrinPicksell(point: nextPoint)
        }
    }
    
    private func currentColorMountainFirst() -> UIColor {
        if countCheep >= 60 {
            return UIColor.greenColor6()
        }
        if countCheep >= 50 {
            return UIColor.greenColor5()
        }
        if countCheep >= 40 {
            return UIColor.greenColor4()
        }
        if countCheep >= 30 {
            return UIColor.greenColor3()
        }
        if countCheep >= 20 {
            return UIColor.greenColor2()
        }
        return UIColor.greenColor1()
    }
    
    private func currentColorMountainSecond() -> UIColor {
        if countCheep >= 60 {
            return UIColor.greenColor66()
        }
        if countCheep >= 50 {
            return UIColor.greenColor55()
        }
        if countCheep >= 40 {
            return UIColor.greenColor44()
        }
        if countCheep >= 30 {
            return UIColor.greenColor33()
        }
        if countCheep >= 20 {
            return UIColor.greenColor22()
        }
        return UIColor.greenColor11()
    }
    
    private func currentColorSheep() -> UIColor {
        if countCheep >= 60 {
            return UIColor.sheepColor6()
        }
        if countCheep >= 50 {
            return UIColor.sheepColor5()
        }
        if countCheep >= 40 {
            return UIColor.sheepColor4()
        }
        if countCheep >= 30 {
            return UIColor.sheepColor3()
        }
        if countCheep >= 20 {
            return UIColor.sheepColor2()
        }
        return UIColor.sheepColor1()
    }
    
    
    /*
    func moc() {
        var sheepRecords = SheepRecords(context: SheepDataService.context)
        sheepRecords.points = 23
        var date = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var dateString = dateFormatter.string(from: date as! Date)
        sheepRecords.date = dateString
        SheepDataService.saveContext()

    }*/
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstWey()
        secondWey()
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
            player.volume = 0.5
            //0.006
        } catch let error {
            print(error.localizedDescription)
        }
    }
    

    @IBAction func SoundTurn(_ sender: UIButton) {
        soundIsSwitchOn = !soundIsSwitchOn
        if soundIsSwitchOn {
            sender.setImage(UIImage(named: "SoundOn"), for: .normal)

        } else {
            sender.setImage(UIImage(named: "SoundOff"), for: .normal)
        }
        player(with: soundIsSwitchOn)
    }
    
    
    private func player(with state: Bool) {
        if soundIsSwitchOn {
  
            player?.play()
        } else {

            player?.stop()
        }
    }
    
    func createCircle(color: UIColor = UIColor.whiteSheep()) {

        let desiredLineWidth: CGFloat = 4
        let hw :CGFloat = desiredLineWidth/2
        let circlePath = UIBezierPath(ovalIn: circleView.bounds.insetBy(dx:hw,dy:hw))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 11
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
        
        sheepView.sheepImage.loadGif(name: currentGifForSheep)
        
        sheepView.movingSheepImageName = movingSheepImageName
        sheepView.defaultSheepImageName = defaultSheepImageName
        sheepView.sheepMainGif = currentGifForSheep
        
        sheepView.frame = CGRect(x: -100, y:  -100, width: 180, height: 2000)
        sheepView.center = CGPoint(x: p0.x - 100, y: p0.y)
        sheepView.delegate = self

        self.sheepView = sheepView
        self.view.addSubview(sheepView)
        moveToStart(view: sheepView)
        
    }

    func moveToStart(view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.center = self.p0
        }) { (_) in
            self.addSheepInHerd()
        }
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
            //TODO: Remove
            //view.removeFromSuperview()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    
    func moveSheep() {
        let image = UIImage(named: defaultSheepImageName)

        let newSheep = UIImageView(image: image)
        newSheep.loadGif(name: currenSheepRun)
        newSheep.frame = CGRect(origin: finishp0, size: CGSize(width: 50, height: 50))
        newSheep.transform = CGAffineTransform(scaleX: -1, y: 1)
        firstMountain.addSubview(newSheep)
    
        automaticMoving(view: newSheep)
    }

    private func automaticMoving(view: UIView) {
       
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            view.center = self.p2
            self.sheepLeave()
            view.removeFromSuperview()
        })
        let animation = CAKeyframeAnimation(keyPath: "position")
        let newBezierPath = UIBezierPath()

        newBezierPath.move(to: startp2)
        newBezierPath.addQuadCurve(to: startp0, controlPoint: startp1)
        animation.path = newBezierPath.cgPath
        animation.fillMode              = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration              = durationAutomaticMoving
        view.layer.add(animation, forKey:"trash")
        CATransaction.commit()
    }
    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    private func sheepLeave() {
        
        let image = UIImage(named: defaultSheepImageName)
        let newSheep = UIImageView(image: image)
        newSheep.frame = CGRect(origin: finishp0, size: CGSize(width: 50, height: 50))
        newSheep.loadGif(name: currenSheepRun)
        firstMountain.addSubview(newSheep)
        firstMountain.sendSubview(toBack: newSheep)
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({
            newSheep.removeFromSuperview()
            self.showSheppInHerd()
           // self.addSheepInHerd()
        })
        let animation = CAKeyframeAnimation(keyPath: "position")
        let newBezierPath = UIBezierPath()
        newBezierPath.move(to: finishp0)
        newBezierPath.addQuadCurve(to: finishp2, controlPoint: finishp1)
        animation.path = newBezierPath.cgPath
        animation.fillMode              = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration              = durationAutomaticMoving
        newSheep.layer.add(animation, forKey:"trash")
        CATransaction.commit()
        
    }
    
    private func showSheppInHerd() {
        
        if let index = conteinerViewSheep.index(where: { $0.isHidden == true }) {
            self.conteinerViewSheep[index].isHidden = false
        }
        
    }
    
    private func findHideSheep() -> Int? {
        return conteinerViewSheepIsHiden.index(where: { $0 == true })
    }
    
    func firstWey() {
   
        switch ScreenType.currentScreenType() {
        case .iPhoneX :
            startp0 = CGPoint(x: 91, y: 573 )
            startp2  = CGPoint(x: 370 , y: 659)
            startp1 = CGPoint(x: 222, y: 576)
            
        case .iPhoneXMax :
            startp0 = CGPoint(x: 101, y: 628 )
            startp2  = CGPoint(x: 400 , y: 733)
            startp1 = CGPoint(x: 256, y: 650)
            
        case .iPhone6:
            startp0 = CGPoint(x: 90, y: 490 )
            startp2  = CGPoint(x: 366 , y: 560)
            startp1 = CGPoint(x: 231, y: 460)
        case .iPhone6Plus:
            //todo
            startp0 = CGPoint(x: 101, y: 540 )
            startp2  = CGPoint(x: 402, y: 610)
            startp1 = CGPoint(x: 228, y: 490)
        default:
            //se 5 и т.д
            startp0 = CGPoint(x:82, y: 420 )
            startp2  = CGPoint(x:306, y:475 )
            startp1 = CGPoint(x: 186, y: 390)
        }
        

        thirdBezierPath.move(to: startp0)
        thirdBezierPath.addQuadCurve(to: startp2, controlPoint: startp1)
        
        /*
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = thirdBezierPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 3.0
        firstMountain.layer.addSublayer(shapeLayer)*/

    }
    func secondWey() {

        
        switch ScreenType.currentScreenType(){
        case .iPhoneX :
            finishp0 = CGPoint(x: 91, y: 573)
            finishp2  = CGPoint(x: 367 , y: 477)
            finishp1 = CGPoint(x: 274, y: 440)
            
        case .iPhoneXMax :
            finishp0 = CGPoint(x: 101, y: 628)
            finishp2  = CGPoint(x: 400 , y: 528)
            finishp1 = CGPoint(x: 263, y: 500)
            
        case .iPhone6:
            finishp0 = CGPoint(x: 90, y: 490)
            finishp2  = CGPoint(x: 363 , y: 410)
            finishp1 = CGPoint(x: 220, y: 370)
        case .iPhone6Plus:
            //todo
            finishp0 = CGPoint(x: 101, y: 540)
            finishp2  = CGPoint(x: 420 , y: 440 )
            finishp1 = CGPoint(x: 250, y: 400)
        default:
            //se 5 и т.д
            finishp0 = CGPoint(x: 82, y: 420 )
            finishp2  = CGPoint(x: 310 , y: 350 )
            finishp1 = CGPoint(x: 200, y: 320)
        }
        
        finishbezierPath.move(to: finishp0)
        finishbezierPath.addQuadCurve(to: finishp2, controlPoint: finishp1)
        
        /*
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = finishbezierPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 3.0
        firstMountain.layer.addSublayer(shapeLayer)*/
        
    }

    func drawBezierPath() {

        p0 = CGPoint(x: self.view.frame.origin.x - 2, y: self.view.frame.maxY - 90 )
        
        p2  = CGPoint(x: self.view.frame.maxX - 60 , y: self.view.frame.maxY - 120 )

        p1 = CGPoint(x: self.view.frame.width/3, y: self.view.frame.height/3)
        
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
    
    var delay: CGFloat = 0.2
    
    func changeeBackground() {
        //TODO: Check Animation starts
        if countCheep >= 60 {
            changeFon(to: "GameFon6")
            secondYawningSheep()
            return
        }
        if countCheep >= 50 {
            changeFon(to: "GameFon5")
            startAnimationStars()

            return
        }
        if countCheep >= 40 {
            changeFon(to: "GameFon4")
            startAnimationStars()

            return
        }
        if countCheep >= 30 {
            changeFon(to: "GameFon3")
            firstYawningSheep()

            return
        }
        if countCheep >= 20 {
            changeFon(to: "GameFon2")
            return
        }
        if countCheep >= 10 {
            fonImage.image = UIImage(named: "GameFon1")
        }
    }
    
    private func updateHerdColor() {
        for i in 0...conteinerViewSheep.count - 1 {
            conteinerViewSheep[i].image = UIImage(named: currentHerdSheep)!
        }
    }
    
    
    private func startAnimationStars() {
        delay = 0.3
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
    }
    
    
    private func firstYawningSheep() {
        endMovingSheppIfNeeded()
        Hero.shared.defaultAnimation = .fade
        let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC2")
        greenVC.hero.isEnabled = true
        greenVC.hero.modalAnimationType = .fade
        present(greenVC, animated: true, completion: nil)
    }
    
    private func secondYawningSheep() {
        endMovingSheppIfNeeded()
        Hero.shared.defaultAnimation = .fade
        let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC3")
        greenVC.hero.isEnabled = true
        greenVC.hero.modalAnimationType = .fade
        present(greenVC, animated: true, completion: nil)
    }
    
    private func endMovingSheppIfNeeded() {
    }
    
    private func changeFon(to name: String ) {
        UIView.transition(with: fonImage,
                          duration: 1,
                          options: .transitionCrossDissolve,
                          animations: { self.fonImage.image = UIImage(named: name) },
                          completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TableSheepViewController {
            destination.delegate = self
        }
        super.prepare(for: segue, sender: sender)
    }
}

extension GameViewController: TableSheepDelegate {
    func close() {
        if countCheep >= 40 {
            startAnimationStars()
        }
        self.navigationController?.navigationBar.isHidden = true
    }
}



extension GameViewController: MovedSheep {
    func endMove(view: UIView) {
        //self.sheepView?.removeFromSuperview()
        
       // moveToEnd(view: view)
        
        moveSheep()
        countCheep += 1
        countLable.text = "\(countCheep)"
        if countCheep < 61 &&  countCheep % 10 == 0 {
            changeeBackground()
        }
        saveLoginData()
    }
    
    func createSheep() {
        createNewSheep()
    }
    
    
    func saveLoginData() {
        let fetchRequest: NSFetchRequest<SheepRecords> = SheepRecords.fetchRequest()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        fetchRequest.predicate = NSPredicate(format: "date = %@", dateString)
        do {
            let sheepData = try SheepDataService.context.fetch(fetchRequest)
            if sheepData.count != 0 {
                sheepData[0].points = Int32(countCheep)
                try SheepDataService.context.save()
            } else {
                let sheepRecords = SheepRecords(context: SheepDataService.context)
                sheepRecords.points = Int32(countCheep)
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let dateString = dateFormatter.string(from: date as Date)
                sheepRecords.date = dateString
                SheepDataService.saveContext()
            }
        } catch {}
    }
    
    
    func firstTouch() {
        if isFirst {
            isFirst = false
            UIView.animate(withDuration: 0.3, animations: {
                //self.arrow.alpha = 0
                self.textSwipe.alpha = 0
            }) { (_) in
                //self.arrow.removeFromSuperview()
                self.textSwipe.removeFromSuperview()
                self.createCircle()
                self.countLable.isHidden = false
            }
        }
    }
}
