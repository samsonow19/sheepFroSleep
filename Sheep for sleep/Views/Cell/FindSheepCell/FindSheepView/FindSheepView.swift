//
//  FindSheepView.swift
//  Sheep for sleep
//
//  Created by Evgen on 25.09.2018.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

private let gapeSheepName: String = "sheepGape"
private let currentHerdSheep: String = "FindSheep"

protocol FindSheepViewDelegate:AnyObject {
    func clickedGapeSheep(_ index: Int)
}

class FindSheepView: UIView {
    
    weak var delegate: FindSheepViewDelegate?
    var isGapeSheep: Bool = false

    @IBOutlet weak var imageView: UIImageView!
    var index: Int = 0

    @IBAction func clickedShepp(_ sender: Any) {
        if isGapeSheep {
            stopGape()
            delegate?.clickedGapeSheep(index)
        }
    }
    
    func startGape() {
        imageView.image = nil
        imageView.loadGif(name: gapeSheepName)
        isGapeSheep = true
    }
    
    func stopGape() {
        imageView.image = UIImage(named: currentHerdSheep)
    }
    
}
