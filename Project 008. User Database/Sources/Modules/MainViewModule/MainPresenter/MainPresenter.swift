
protocol MainViewProtocol: AnyObject {
    func showData(of members: [MemberList])
    func showError(with error: Error)
}

final class MainPresenter {
    private weak var view: MainViewProtocol?
    private var coreDataService = CoreDataService.shared
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    // MARK: CRUD stack
     
    func getAllMembers() {
        let members = coreDataService.getAllMembers()
        view?.showData(of: members)
    }
    
    func createMember(name: String) {
        coreDataService.createMember(name: name)
        getAllMembers()
    }
    
    func deleteMember(_ member: MemberList) {
        coreDataService.deleteMember(member)
        getAllMembers()
    }
    
    func updateMember(_ member: MemberList, newName: String) {
        coreDataService.updateMember(member, newName: newName)
    }
}
