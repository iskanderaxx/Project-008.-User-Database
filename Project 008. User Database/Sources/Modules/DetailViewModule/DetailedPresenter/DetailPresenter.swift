
import CoreData

//protocol DetailViewProtocol: AnyObject {
//    func updateMemberData(name: String?, dateOfBirth: Date?, gender: String?, song: String?)
//    func showError(with error: Error)
//}

final class DetailPresenter {
//   weak var view: DetailViewProtocol?
    private let member: MemberList
    private let coreDataService: CoreDataService
//    private var context: NSManagedObjectContext
    
    init(member: MemberList, coreDataService: CoreDataService) { // view: DetailViewProtocol, , context: NSManagedObjectContext
//        self.view = view
        self.member = member
        self.coreDataService = coreDataService
//        self.context = context
    }
    
    func getMemberName() -> String { member.name ?? "" }
    
    func getMemberGender() -> String { member.gender ?? "" }
    
    func getMemberSong() -> String { member.song ?? "" }
    
    func setMemberName(_ name: String) { member.name = name }
    
    func setMemberDateOfBirth(_ date: Date) { member.dateOfBirth = date }
    
    func setMemberGender(_ gender: String) { member.gender = gender }
    
    func setMemberSong(_ song: String) { member.song = song }
    
    func updateMember(name: String?, dateOfBirth: Date?, gender: String?, song: String?) {
        if let name = name { setMemberName(name) }
        if let dateOfBirth = dateOfBirth { setMemberDateOfBirth(dateOfBirth) }
        if let gender = gender { setMemberGender(gender) }
        if let song = song { setMemberSong(song) }
        
        coreDataService.saveContext()
        
//        saveContext()
//        view?.updateMemberData(name: name, dateOfBirth: dateOfBirth, gender: gender, song: song)
    }
//    
//    func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context: \(error)")
//        }
//    }
}
