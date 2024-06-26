
import UIKit
import SnapKit

final class MainViewController: UIViewController, MainViewProtocol {
    
    private var presenter: MainPresenter?
    private var members = [MemberList]()
    private var coreDataManager = CoreDataManager.shared
    
    // MARK: UI Elements & Oulets
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Print member name here"
        textField.textColor = .gray
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = .systemGray6
        textField.textAlignment = .natural
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var blueButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setTitle("Add member", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addMemberButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .systemGray6
        return grayView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "defaultCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Eurovision 2024"
        setupTitleColor()
        setupMainPresenter()
        setupViewsHierarchy()
        setupLayout()
    }
    
    deinit {
         tableView.removeObserver(self, forKeyPath: "contentSize")
     }
    
    // MARK: Setup & Layout
    
    private func setupTitleColor() {
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupMainPresenter() {
        presenter = MainPresenter(view: self)
        presenter?.getAllMembers()
    }
    
    private func setupViewsHierarchy() {
        [textField, blueButton, grayView].forEach { view.addSubview($0) }
        grayView.addSubview(tableView)
    }
    
    private func setupLayout() {
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(view).offset(-245)
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).offset(-15)
            make.height.equalTo(45)
        }
        
        blueButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).offset(-15)
            make.height.equalTo(45)
        }
        
        grayView.snp.makeConstraints { make in
            make.top.equalTo(blueButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(grayView.snp.top).offset(15)
            make.leading.equalTo(grayView.snp.leading).offset(15)
            make.trailing.equalTo(grayView.snp.trailing).offset(-15)
            make.height.equalTo(0)
        }
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    // MARK: Actions
    
    @objc
    private func addMemberButtonPressed() {
        guard let text = textField.text, !text.isEmpty else { return }
        
        presenter?.createMember(name: text)
        textField.text = ""
    }
}

// MARK: - Extensions

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = members[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = model.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let member = members[indexPath.row]
        let detailViewController = DetailViewController(member: member)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let member = members[indexPath.row]
            presenter?.deleteMember(member)
            tableView.reloadData()
        }
    }
}

extension MainViewController {
    func showData(of members: [MemberList]) {
        self.members = members
        self.tableView.reloadData()
    }
    
    func showError(with error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            tableView.snp.updateConstraints { make in
                make.height.equalTo(tableView.contentSize.height)
            }
        }
    }
}
