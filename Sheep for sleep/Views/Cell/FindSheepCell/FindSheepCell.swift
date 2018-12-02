//
//  FindSheepCell.swift
//  Sheep for sleep
//
//  Created by Evgen on 24.09.2018.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

private let sizeSheep: CGSize = CGSize(width: 50, height: 70)
private let currentHerdSheep: String = "FindSheep"

protocol FindSheepCellDelegate: AnyObject {
    func foundSheep(frame: CGRect, in cell: UITableViewCell)
}

class FindSheepCell: UITableViewCell {

    var sheeps: [FindSheepView] = []
    var count: Int = 0
    var goapSheepIndex: Int = 0
    weak var delegate: FindSheepCellDelegate?
    
    override func awakeFromNib() {
        self.clipsToBounds = false
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setupCells(with wight: CGFloat, shouldIndent: Bool) {
        
        count = countCheepInRow(wight: wight, shouldIndent: shouldIndent)
        
        for i in 0...count {
            addSheepInRow(with: i, shouldIndent: shouldIndent)
        }

    }
    
    func gapeSheep() {
        goapSheepIndex = randomSheep()
        sheeps[goapSheepIndex].startGape()
    }
    
    private func randomSheep() -> Int {
        return Int.random(in: 1..<(count - 1))
    }
    
    private func addSheepInRow(with index: Int, shouldIndent: Bool) {
        var indent: Int = 0
        if shouldIndent {
            indent = Int(sizeSheep.width/2)
        }
        
        let start = index * Int(sizeSheep.width-5) - indent

        let findSheepView: FindSheepView = UIView.instantiateFromNib()
        
        findSheepView.delegate = self
        
        if findSheepView.isGapeSheep == false {
           findSheepView.imageView.image = UIImage(named: currentHerdSheep)
        }
        
        findSheepView.index = index
        
        sheeps.append(findSheepView)
        
        let point = CGPoint(x: start, y: 0)
        findSheepView.frame = CGRect(origin: point, size: sizeSheep)
        self.contentView.addSubview(findSheepView)
    }
    
    func countCheepInRow(wight: CGFloat, shouldIndent: Bool = false) -> Int {
        
        let count: Int = Int(wight / sizeSheep.width) + 2
        return count
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sheeps = []
    }
    
}

extension FindSheepCell: FindSheepViewDelegate {
    
    func clickedGapeSheep(_ index: Int) {
        
        let frameSheep = sheeps[index].frame
        delegate?.foundSheep(frame: frameSheep, in: self)
    }
    
}
