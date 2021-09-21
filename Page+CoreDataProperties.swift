//
//  Page+CoreDataProperties.swift
//  olds
//
//  Created by Caroline Taus on 21/09/21.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }

    @NSManaged public var pageAudio: String?
    @NSManaged public var pageDate: Date?
    @NSManaged public var pagePhoto: String?
    @NSManaged public var album: Album?

}

extension Page : Identifiable {

}
