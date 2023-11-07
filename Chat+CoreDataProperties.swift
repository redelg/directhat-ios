//
//  Chat+CoreDataProperties.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 6/03/22.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var number: String?
    @NSManaged public var numberFormat: String?
    @NSManaged public var timestamp: Date?

}

extension Chat : Identifiable {

}
