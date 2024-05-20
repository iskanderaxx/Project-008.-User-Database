
import CoreData

@objc(MemberList)
public class MemberList: NSManagedObject {}

// MARK: - Extensions

extension MemberList {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemberList> {
        return NSFetchRequest<MemberList>(entityName: "MemberList")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var gender: String?
    @NSManaged public var song: String?

}

extension MemberList : Identifiable {}
