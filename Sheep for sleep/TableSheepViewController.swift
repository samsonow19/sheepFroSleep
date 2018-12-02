//
//  TableSheepViewController.swift
//  Sheep for sleep
//
//  Created by Evgeniy Samsonov on 17.04.2018.
//  Copyright © 2018 Evgeniy Samsonov. All rights reserved.
//

import UIKit
import CoreData
import PromiseKit

// размер овцы овцы с анимацией - 73 / 92


struct SectionSheepData {
    var sheepData: [SheepRecords] = []
}

protocol TableSheepDelegate: class {
    func close()
}

class TableSheepViewController: UIViewController {
    
    let idCell: String = "SheepRecordCell"
    let idHeaderCell: String = "HeaderSheepCell"
    var sectionSheep: [SectionSheepData] = []
    var allSheepData: [SheepRecords] = []
    weak var delegate: TableSheepDelegate?
    
    let currentDate: Date = Date()
    let calendar = Calendar.current

    let dateFormatter = DateFormatter()
    @IBOutlet weak var table: UITableView!
    
    @IBAction func close(_ sender: Any) {
        delegate?.close()
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        var nib = UINib(nibName: idCell, bundle: nil)
        table.register(nib, forCellReuseIdentifier: idCell)
        
        nib = UINib(nibName: idHeaderCell, bundle: nil)
        table.register(nib, forCellReuseIdentifier: idHeaderCell)
        
        let fetchRequest: NSFetchRequest<SheepRecords> = SheepRecords.fetchRequest()
        
        do {
            var sheepData = try SheepDataService.context.fetch(fetchRequest)
            sheepData.sort { (first, second) -> Bool in
                let fDate = dateFormatter.date(from: first.date!)!
                let sDate = dateFormatter.date(from: second.date!)!
                return fDate > sDate
            }
            
            self.allSheepData = sheepData

            DispatchQueue.global(qos: .background).async(.promise) {
                self.sectionSheep = self.mapSheepRecords(sheepRecords: sheepData)
            }.done { _ in
                self.table.delegate = self
                self.table.dataSource = self
                self.table.reloadData()
            }

        } catch {}

    }
    
    private func mapSheepRecords(sheepRecords: [SheepRecords] ) -> [SectionSheepData] {
        var newSheepRecords = sheepRecords
        let lastWeekDate = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentDate)!
        let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
        var newSectionSheep: [SectionSheepData] = []
        var currentWeekSheeps: [SheepRecords] = []
        var lastWeekSheeps: [SheepRecords] = []
        var currentMonthSheeps: [SheepRecords] = []
        var lastMonthSheeps: [SheepRecords] = []
        
       
        var index = -1;
        for sheepRecord in newSheepRecords {
            index += 1
            if let currentWeekSheep = cutForDate(component: .weekOfMonth, stringDate: sheepRecord.date,
                                            currentDate: currentDate, sheepRecord: sheepRecord) {
                currentWeekSheeps.append(currentWeekSheep)
                newSheepRecords.remove(at: index)
                index -= 1
                continue
            }
            
            
            if let lastWeekSheep = cutForDate(component: .weekOfMonth, stringDate: sheepRecord.date,
                                              currentDate: lastWeekDate, sheepRecord: sheepRecord) {
                lastWeekSheeps.append(lastWeekSheep)
                newSheepRecords.remove(at: index)
                index -= 1
                continue
            }
        }
        
        index = -1;
        for sheepRecord in newSheepRecords {
            index += 1
            if let currentMonthSheep = cutForDate(component: .month, stringDate: sheepRecord.date,
                                                  currentDate: currentDate, sheepRecord: sheepRecord) {
                currentMonthSheeps.append(currentMonthSheep)
                newSheepRecords.remove(at: index)
                index -= 1
                continue
            }
            
            if let lastMonthSheep = cutForDate(component: .month, stringDate: sheepRecord.date,
                                               currentDate: lastMonthDate, sheepRecord: sheepRecord) {
                lastMonthSheeps.append(lastMonthSheep)
                newSheepRecords.remove(at: index)
                index -= 1
                continue
            }
        }
        
        for currentWeek in currentWeekSheeps {
            let index = currentMonthSheeps.index { (sheep) -> Bool in
                sheep.date == currentWeek.date
            }
            if let findIndex = index {
                currentMonthSheeps.remove(at: findIndex)
            }
        }
        
        
        newSectionSheep.append(SectionSheepData(sheepData: currentWeekSheeps))
        newSectionSheep.append(SectionSheepData(sheepData: lastWeekSheeps))
        newSectionSheep.append(SectionSheepData(sheepData: currentMonthSheeps))
        newSectionSheep.append(SectionSheepData(sheepData: lastMonthSheeps))
        return newSectionSheep
    }
    

    
    private func cutForDate(component: Calendar.Component, stringDate: String?, currentDate: Date, sheepRecord: SheepRecords) -> SheepRecords?  {

        var thisTimeInterval: SheepRecords?
        guard let date = dateFormatter.date(from: stringDate ?? "" ) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        let datesAreInTheSameDay = calendar.isDate(currentDate, equalTo: date, toGranularity:component)
        if datesAreInTheSameDay {
            thisTimeInterval = sheepRecord
        }
        return thisTimeInterval
    }


}

extension TableSheepViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        let sheepData = sectionSheep[section].sheepData.count
        let double = Double(sheepData)
        let remainderOfDivision: Double = double / 4.0
        if remainderOfDivision != 0, remainderOfDivision != 1 {
            count = (sheepData / 4) + 1
        } else {
            count = sheepData / 4
        }
        if section != 0, sheepData != 0 {
            return count + 1
        } else {
            return count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.row == 0, indexPath.section != 0 {
            if indexPath.section == 1 {
                let  headerCell = table.dequeueReusableCell(withIdentifier: idHeaderCell, for: indexPath) as! HeaderSheepCell
                headerCell.title.image = UIImage(named: "LastWeek")
                return headerCell
            }
            if indexPath.section == 2 {
                let  headerCell = table.dequeueReusableCell(withIdentifier: idHeaderCell, for: indexPath) as! HeaderSheepCell
                headerCell.title.image = UIImage(named: "ThisMonth")
                return headerCell
            }
            if indexPath.section == 3 {
                let  headerCell = table.dequeueReusableCell(withIdentifier: idHeaderCell, for: indexPath) as! HeaderSheepCell
                headerCell.title.image = UIImage(named: "LastMonth")
                return headerCell
            }
            return UITableViewCell()
            
        } else {
            let cell = table.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as! SheepRecordCell
            if indexPath.section == 0 {
                let items = getItems(inSection: sectionSheep[0].sheepData, index: indexPath.row)
                cell.setup(sheepRecords: items)
                if indexPath.row == 0 {
                    cell.firstImage.loadGif(name: "superSheep")
                    cell.countPointFirst.textColor = UIColor.firstDayColor()
                    cell.firstImage.contentMode = .scaleAspectFit
                }
                return cell
            }
            let items = getItems(inSection: sectionSheep[indexPath.section].sheepData, index: indexPath.row - 1)
            cell.setup(sheepRecords: items)
            return cell
        }

    }
    
    private func getItems(inSection: [SheepRecords], index: Int) -> [SheepRecords] {
        var sheepRecords: [SheepRecords] = []
        let double = Double(index)
        let remainderOfDivision: Double = double / 4.0
        var part = index / 4
        if remainderOfDivision != 0 {
            part += 1
        }
        let index = part * 4
        for i in index...(index+4) {
            if i < inSection.count {
                sheepRecords.append(inSection[i])
            } else {
                break
            }
        }
        return sheepRecords
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0, indexPath.section != 0 {
            return self.view.frame.height / 7
        }
        return self.view.frame.height / 5
    }
    
}


