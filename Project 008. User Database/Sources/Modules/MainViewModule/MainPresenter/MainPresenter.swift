
import CoreData

// MARK: - Main Presenter

protocol MainViewProtocol: AnyObject {
    func showInfo(_ members: [MemberList])
    func showError(_ error: Error)
}

final class MainPresenter {
    weak var view: MainViewProtocol?
    var controller: MainViewController
    
    private var context: NSManagedObjectContext {
        guard let appDelegate = controller.delegate as? AppDelegate else {
            fatalError("AppDelegate is nil or is not of type AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    init(view: MainViewProtocol, controller: MainViewController) {
        self.view = view
        self.controller = controller
    }
    
    // MARK: CRUD stack
     
    func getAllMembers() {
        do {
            let members = try context.fetch(MemberList.fetchRequest())
            view?.showInfo(members)

        } catch {
            view?.showError(error)
        }
    }
    
    func createMember(name: String) {
        let newMember = MemberList(context: context)
        newMember.name = name
        
        do {
            try context.save()
            getAllMembers()
        } catch {
            view?.showError(error)
        }
    }
    
    func deleteMember(_ member: MemberList) { //
        context.delete(member)
        
        do {
            try context.save()
            getAllMembers()
        } catch {
            view?.showError(error)
        }
    }
    
    func updateMember(_ member: MemberList, newName: String) {
        member.name = newName
        
        do {
            try context.save()
            getAllMembers()
        } catch {
            view?.showError(error)
        }
    }
}
