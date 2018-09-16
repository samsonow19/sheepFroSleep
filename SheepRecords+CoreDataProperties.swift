//
//  SheepRecords+CoreDataProperties.swift
//  
//
//  Created by Evgeniy Samsonov on 18.04.2018.
//
//

import Foundation
import CoreData


extension SheepRecords {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SheepRecords> {
        return NSFetchRequest<SheepRecords>(entityName: "SheepRecords")
    }

    @NSManaged public var points: Int32
    @NSManaged public var date: String?

}
