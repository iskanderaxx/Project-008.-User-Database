
import Foundation

// MARK: - Protocols

protocol UserPresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfRows() -> Int
    func configure(cell: TableViewCell, forRow row: Int)
    func didSelectRow(at indexPath: IndexPath)
}

// MARK: - Presenter

//final class UserPresenter: UserPresenterProtocol {
//    func viewDidLoad() {
//        <#code#>
//    }
//    
//    func numberOfRows() -> Int {
//        <#code#>
//    }
//    
//    func configure(cell: TableViewCell, forRow row: Int) {
//        <#code#>
//    }
//    
//    func didSelectRow(at indexPath: IndexPath) {
//        <#code#>
//    }
//    
//    
//}
