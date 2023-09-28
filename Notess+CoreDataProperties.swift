//
//  Notess+CoreDataProperties.swift
//  Notes
//
//  Created by Why on 27.09.2023.
//
//

import Foundation
import CoreData


extension Notess {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notess> {
        return NSFetchRequest<Notess>(entityName: "Notess")
    }

    @NSManaged public var attribute: NSObject?
    @NSManaged public var noteses: NSSet?

}

// MARK: Generated accessors for noteses
extension Notess {

    @objc(addNotesesObject:)
    @NSManaged public func addToNoteses(_ value: Not)

    @objc(removeNotesesObject:)
    @NSManaged public func removeFromNoteses(_ value: Not)

    @objc(addNoteses:)
    @NSManaged public func addToNoteses(_ values: NSSet)

    @objc(removeNoteses:)
    @NSManaged public func removeFromNoteses(_ values: NSSet)

}
