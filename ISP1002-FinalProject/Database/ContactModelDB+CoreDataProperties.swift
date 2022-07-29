//
//  ContactModelDB+CoreDataProperties.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 29/07/22.
//
//

import Foundation
import CoreData


extension ContactModelDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactModelDB> {
        return NSFetchRequest<ContactModelDB>(entityName: "ContactModelDB")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var lastName: String?
    @NSManaged public var mobile: String?
    @NSManaged public var email: String?
    @NSManaged public var contactId: String?

}

extension ContactModelDB : Identifiable {

}
