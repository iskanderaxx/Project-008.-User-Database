
import UIKit

final class DetailViewController: UIViewController {
    private let member: MemberList
    
    init(member: MemberList) {
        self.member = member
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
    }
}
