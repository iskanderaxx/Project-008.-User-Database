
import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private weak var view: MainViewProtocol?
    
    private init() {}
    
    // MARK: Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(error), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: CRUD stack
    
    func getAllMembers() -> [MemberList] {
        do {
            let members = try context.fetch(MemberList.fetchRequest())
            return members
        } catch {
            print("Failed to fetch members: \(error)")
            return []
        }
    }
    
    func createMember(name: String) {
        let newMember = MemberList(context: context)
        newMember.name = name
        
        do {
            try context.save()
        } catch {
            view?.showError(with: error)
        }
    }
    
    func deleteMember(_ member: MemberList) {
        context.delete(member)
        
        do {
            try context.save()
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
