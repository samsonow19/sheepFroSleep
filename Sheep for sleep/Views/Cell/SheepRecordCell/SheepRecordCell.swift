//
//  SheepRecord.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 17.04.2018.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit

class SheepRecordCell: UITableViewCell {

    @IBOutlet weak var firstSheep: SheepRecordView!
    @IBOutlet weak var secondSheep: SheepRecordView!
    @IBOutlet weak var thirdSheep: SheepRecordView!
    @IBOutlet weak var fourthSheep: SheepRecordView!
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var countPointFirst: UILabel!
    @IBOutlet weak var dayFirst: UILabel!
    
    @IBOutlet weak var countPointSecond: UILabel!
    @IBOutlet weak var daySecond: UILabel!
    
    @IBOutlet weak var countPointThrid: UILabel!
    @IBOutlet weak var dayThrid: UILabel!
    
    @IBOutlet weak var countPointFourth: UILabel!
    @IBOutlet weak var dayFourth: UILabel!
    
    let dateFormatter = DateFormatter()
    let dateFormatter2 = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter2.dateFormat = "MMMM dd"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        firstSheep.isHidden = true
        secondSheep.isHidden = true
        thirdSheep.isHidden = true
        fourthSheep.isHidden = true
        countPointFirst.textColor = UIColor.defoultSheepPointCellColor()
    }
    
    func setup(sheepRecords: [SheepRecords]) {
        if sheepRecords.count == 0 {
            return
        }
        
        if sheepRecords.count >= 1 {
            firstSheep.isHidden = false
            countPointFirst.text = String(sheepRecords[0].points)
            guard let date = dateFormatter.date(from: sheepRecords[0].date ?? "" ) else {
                fatalError("ERROR: Date conversion failed due to mismatched format.")
            }
            
            dayFirst.text = dateFormatter2.string(from: date)
        }
        if sheepRecords.count >= 2 {
            secondSheep.isHidden = false
            countPointSecond.text = String(sheepRecords[1].points)
            guard let date = dateFormatter.date(from: sheepRecords[1].date ?? "" ) else {
                fatalError("ERROR: Date conversion failed due to mismatched format.")
            }
            
            daySecond.text = dateFormatter2.string(from: date)
        }
        if sheepRecords.count >= 3 {
            thirdSheep.isHidden = false
            countPointThrid.text = String(sheepRecords[2].points)
            guard let date = dateFormatter.date(from: sheepRecords[2].date ?? "" ) else {
                fatalError("ERROR: Date conversion failed due to mismatched format.")
            }
            dayThrid.text = dateFormatter2.string(from: date)
        }
        
        if sheepRecords.count >= 4 {
            fourthSheep.isHidden = false
            countPointFourth.text = String(sheepRecords[3].points)
            guard let date = dateFormatter.date(from: sheepRecords[3].date ?? "" ) else {
                fatalError("ERROR: Date conversion failed due to mismatched format.")
            }
            dayFourth.text = dateFormatter2.string(from: date)
        }
    }

}

class SheepRecordView: UIView {

    @IBOutlet weak var test: UIImage!
}
