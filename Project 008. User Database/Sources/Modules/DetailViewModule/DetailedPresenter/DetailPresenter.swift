
import CoreData

protocol DetailViewProtocol: AnyObject {
    func updateMemberData()
}

final class DetailPresenter {
    private weak var view: DetailViewProtocol?
    private let member: MemberList
    private var context: NSManagedObjectContext
    
    init(view: DetailViewProtocol, member: MemberList, context: NSManagedObjectContext) {
        self.view = view
        self.member = member
        self.context = context
    }
    
    func getMemberName() -> String { member.name ?? "" }
    
    func getMemberDateOfBirth() -> Date { member.dateOfBirth ?? Date() }
    
    func getMemberGender() -> String { member.gender ?? "" }
    
    func getMemberSong() -> String { member.song ?? "" }
    
    func updateMember(name: String?, dateOfBirth: Date?, gender: String?, song: String?) {
        member.name = name
        member.dateOfBirth = dateOfBirth
        member.gender = gender
        member.song = song
        
        saveContext()
        view?.updateMemberData()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
