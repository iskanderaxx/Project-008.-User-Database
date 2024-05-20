
import CoreData
import UIKit

protocol MemberViewProtocol: AnyObject {
    func showInfo(_ members: [MemberList])
    func showError(_ error: Error)
}

// MARK: - Presenter

final class MainPresenter {
    weak var view: MemberViewProtocol?
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    init(view: MemberViewProtocol) {
        self.view = view
    }
     
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
