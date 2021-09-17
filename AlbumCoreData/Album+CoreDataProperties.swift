//
//  Album+CoreDataProperties.swift
//  olds
//
//  Created by Raphael Alkamim on 17/09/21.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var albumTittle: String?
    @NSManaged public var albumType: String?
    @NSManaged public var pages: NSSet?

}

// MARK: Generated accessors for pages
extension Album {

    @objc(addPagesObject:)
    @NSManaged public func addToPages(_ value: Page)

    @objc(removePagesObject:)
    @NSManaged public func removeFromPages(_ value: Page)

    @objc(addPages:)
    @NSManaged public func addToPages(_ values: NSSet)

    @objc(removePages:)
    @NSManaged public func removeFromPages(_ values: NSSet)

}

extension Album : Identifiable {

}
