//
//  Not+CoreDataProperties.swift
//  Notes
//
//  Created by Tinskrin on 27.09.2023.
//
//

import Foundation
import CoreData


extension Not {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Not> {
        return NSFetchRequest<Not>(entityName: "Not")
    }

    @NSManaged public var date: Date
    @NSManaged public var title: String
    @NSManaged public var id: UUID

}

extension Not : Identifiable {

}
