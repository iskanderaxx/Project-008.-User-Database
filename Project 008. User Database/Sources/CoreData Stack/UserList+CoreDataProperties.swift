
import Foundation
import CoreData

@objc(UserList)
public class UserList: NSManagedObject {}

// MARK: - Extensions

extension UserList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserList> {
        return NSFetchRequest<UserList>(entityName: "UserList")
    }
    
    // Объекты созданы

    @NSManaged public var name: String?
    @NSManaged public var dateOfBirth: Date?
//    @NSManaged public var gender: String?
//    @NSManaged public var email: String?

}

extension UserList : Identifiable {}
