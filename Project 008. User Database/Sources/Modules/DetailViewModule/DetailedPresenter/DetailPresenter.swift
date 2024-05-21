
import CoreData

protocol DetailViewProtocol: AnyObject {
    func updateMemberData()
}

final class DetailPresenter {
    private weak var view: DetailViewProtocol?
    private let member: MemberList
    
    init(view: DetailViewProtocol, member: MemberList) {
        self.view = view
        self.member = member
    }
    
    func getMemberName() -> String {
        guard let name = member.name else { return "Choose member name" }
        return name
    }
    
//    func getMemberDateOfBirth() -> String {
//        guard let date = member.dateOfBirth else { return "Choose member dateofBirth" }
//        return date
//    }
    
    func getMemberGender() -> String {
        guard let gender = member.gender else { return "Choose member gender" }
        return gender
    }
    
    func getMemberSong() -> String {
        guard let song = member.song else { return "Choose member song" }
        return song
    }
    
    func editMemberProfile() {

    }
}
