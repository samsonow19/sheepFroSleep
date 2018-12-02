//
//  FindSheepVC.swift
//  Sheep for sleep
//
//  Created by Evgen on 24.09.2018.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit
import AVFoundation

class FindSheepVC: UIViewController {
    
    private let movingSheepImageName: String = "MovingSheepDark1"
    private let idCell = "FindSheepCell"

    @IBOutlet weak var loadingView: LoadView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var pillows: [UIImageView]!
    
    @IBOutlet weak var conteinerPillows: UIView!
    @IBOutlet weak var screenView: UIView!
    
    private var foundSheep: [UIView] = []
    
    private let needFindSheep: Int = 3
    private var countFindSheep: Int = 0
    
    private var countInRow: Int = 0
    private var countCell: Int = 0
    private var foundSheepCount: Int = 0
    
    private var sectionGapeSheep: Int = 0
    
    private var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: idCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: idCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        foundSheep.forEach { $0.removeFromSuperview() }
    }
    
    @IBOutlet weak var closeVC: UIButton!
    
    @IBAction func closeModule(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        foundSheepCount = 0
        startPlaySound()
        countCell = Int(tableView.frame.height / 45)
        loadingView.setupLoadView(wight: loadingView.frame.width)
        loadingView.delegate = self
        sectionGapeSheep = randomSectionGapeSheep()
        
        tableView.reloadData()
        
        countInRow = countCheepInRow()
    }
    
    func startPlaySound() {
        guard let url = Bundle.main.url(forResource: "gapeSheep", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.play()
            player.volume = 0.3
            //0.006
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    private func countCheepInRow() -> Int {
        
        let count: Int = Int(self.view.frame.width / 50)
        return count
    }
    
    private func randomSectionGapeSheep() -> Int {
        return Int.random(in: 1..<(countCell - 1))
    }

}

extension FindSheepVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sheepRow = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! FindSheepCell
        
        let shouldIndent: Bool
        
        if indexPath.row % 2 == 0 {
            shouldIndent = true
        } else {
            shouldIndent = false
        }
        
        sheepRow.setupCells(with: self.view.frame.width, shouldIndent: shouldIndent)
        sheepRow.delegate = self
        
        if indexPath.row == sectionGapeSheep {
            sheepRow.gapeSheep()
        }
        
        return sheepRow
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}


extension FindSheepVC: FindSheepCellDelegate {
    
    func foundSheep(frame: CGRect, in cell: UITableViewCell) {

        let sheepView: UIImageView = UIImageView()
        sheepView.contentMode = .scaleAspectFit
        sheepView.image = UIImage(named: "HerdSheep1")
        let newFrame = cell.convert(frame, to: self.view)
        sheepView.frame = CGRect(origin: newFrame.origin,
                                 size: CGSize(width: newFrame.width * 1.5, height: newFrame.height * 1.5))
        
        self.view.addSubview(sheepView)
        foundSheep.append(sheepView)
     
        automaticMoving(viewSheep: sheepView)
        
    }
    
    private func automaticMoving(viewSheep: UIImageView) {
        //end game
        if needFindSheep < foundSheepCount { return }

        let curertPillow = self.pillows[foundSheepCount]
        //let curertPillowsInView = curertPillow.convert(curertPillow.center, to: self.view)
//        let curertPillowsInView = curertPillow.convert(curertPillow.frame, to: self.view)
//
//        let tetstView = UIView()
//        tetstView.backgroundColor = .green
//        //tetstView.frame = test
//        self.view.addSubview(tetstView)
//

        var pont = curertPillow.center
        
        pont.y += conteinerPillows.frame.origin.y
        
        UIView.animate(withDuration: 0.8, animations: {
            viewSheep.center = pont
        }){ (_) in
            viewSheep.image = UIImage(named: "SheepSleep")
            
            viewSheep.bounds = curertPillow.bounds
            
            if self.needFindSheep == self.foundSheepCount {
                self.performSegue(withIdentifier: "win", sender: nil)
                return
            }
            self.startPlaySound()

        }
        
        foundSheepCount += 1
        
        sectionGapeSheep = randomSectionGapeSheep()
        
        tableView.reloadData()
        
        if self.needFindSheep == self.foundSheepCount {
            self.loadingView.delegate = nil
            self.loadingView.deinitTimer()
        }
  
    }
    
}

extension FindSheepVC: LoadViewDelegate {
    
    func timeOver() {
        performSegue(withIdentifier: "lose", sender: nil)
    }
}



