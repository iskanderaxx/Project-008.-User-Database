//
//  UserList+CoreDataProperties.swift
//  Project 008. User Database
//
//  Created by Mac Alexander on 07.05.2024.
//
//

import Foundation
import CoreData


extension UserList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserList> {
        return NSFetchRequest<UserList>(entityName: "UserList")
    }

    @NSManaged public var name: String?
    @NSManaged public var dateOfBirth: Date?
//    @NSManaged public var gender: String?
//    @NSManaged public var email: String?

}

extension UserList : Identifiable {

}
