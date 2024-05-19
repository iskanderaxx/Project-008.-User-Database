
import UIKit
import SnapKit
import CoreData

// MARK: - View

final class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [MemberList]()
    
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
    
    private lazy var orangeButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.backgroundColor = .systemOrange
        button.tintColor = .white
        button.setTitle("Add member", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(orangeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .systemGray6
        return grayView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, 
                           forCellReuseIdentifier: "defaultCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        return tableView
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Eurovision 2024"
        navigationController?.navigationBar.prefersLargeTitles = true
        showCurrentData()
        setupViewsHierarchy()
        setupLayout()
    }
    
    // MARK: Setup & Layout
    
    private func showCurrentData() {
        getAllMembers()
    }
    
    private func setupViewsHierarchy() {
        [textField, orangeButton, grayView, tableView].forEach { view.addSubview($0) }
    }
    
    private func setupLayout() {
        textField.snp.makeConstraints { make in
            make.centerY.equalTo(view).offset(-245)
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).offset(-15)
            make.height.equalTo(45)
        }
        
        orangeButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.leading.equalTo(view).offset(15)
            make.trailing.equalTo(view).offset(-15)
            make.height.equalTo(45)
        }
        
        grayView.snp.makeConstraints { make in
            make.top.equalTo(orangeButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(grayView.snp.top).offset(20)
            make.leading.equalTo(grayView.snp.leading).offset(15)
            make.trailing.equalTo(grayView.snp.trailing).offset(-15)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    // MARK: Actions
    
//    @objc
//    private func orangeButtonPressed() {
//        let alert = UIAlertController(title: "New member", message: "Enter new member name", preferredStyle: .alert)
//        alert.addTextField(configurationHandler: nil)
//        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
//            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
//            
//            self?.createMember(name: text)
//        }))
//        
//        present(alert, animated: true)
//    }
    
    @objc
    private func orangeButtonPressed() {
        guard let text = textField.text, !text.isEmpty else { return }
        
        createMember(name: text)
        textField.text = ""
    }
    
    // MARK: Core Data
    
    private func getAllMembers() {
        do {
            models = try context.fetch(MemberList.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    private func createMember(name: String) {
        let newMember = MemberList(context: context)
        newMember.name = name
        
        do {
            try context.save()
            getAllMembers()
        } catch {
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    private func deleteCurrent(member: MemberList) {
        context.delete(member)
        
        do {
            try context.save()
            getAllMembers()
        } catch {
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    private func updateCurrent(member: MemberList, newName: String) {
        member.name = newName
        
        do {
            try context.save()
            getAllMembers()
        } catch {
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

// MARK: - Extensions

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = model.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let member = models[indexPath.row]
        let detailViewController = MemberDetailViewController(member: member)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let member = models[indexPath.row]
            deleteCurrent(member: member)
            tableView.reloadData()
        }
    }
}
