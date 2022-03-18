//
//  Message+CoreDataProperties.swift
//  Direct Chat
//
//  Created by Renzo Delgado on 13/03/22.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var selected: Bool

}

extension Message : Identifiable {

}
