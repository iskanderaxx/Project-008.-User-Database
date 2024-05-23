
import CoreData

protocol MainViewProtocol: AnyObject {
    func showInformation(about members: [MemberList])
    func showError(with error: Error)
}

final class MainPresenter {
    
    weak var view: MainViewProtocol?
    private var context: NSManagedObjectContext
    
    init(view: MainViewProtocol, context: NSManagedObjectContext) {
        self.view = view
        self.context = context
    }
    
    // MARK: CRUD stack
     
    func getAllMembers() {
        do {
            let members = try context.fetch(MemberList.fetchRequest())
            view?.showInformation(about: members)

        } catch {
            view?.showError(with: error)
        }
    }
    
    func createMember(name: String) {
        let newMember = MemberList(context: context)
        newMember.name = name
        
        do {
            try context.save()
            getAllMembers()
        } catch {
            view?.showError(with: error)
        }
    }
    
    func deleteMember(_ member: MemberList) {
        context.delete(member)
        
        do {
            try context.save()
            getAllMembers()
        } catch {
            view?.showError(with: error)
        }
    }
    
    func updateMember(_ member: MemberList, newName: String) {
        member.name = newName
        
        do {
            try context.save()
        } catch {
            view?.showError(with: error)
        }
    }
}
