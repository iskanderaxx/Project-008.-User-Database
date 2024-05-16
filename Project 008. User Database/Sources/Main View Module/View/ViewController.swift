
import UIKit
import SnapKit
import CoreData

// MARK: - View

final class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [UserList]()
    
    // MARK: UI Elements & Oulets
    
//    var presenter: UserPresenterProtocol?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Print your name here"
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
        button.setTitle("Add user", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(blueButtonPressed), for: .touchUpInside)
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
                           forCellReuseIdentifier: "default")
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
        title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        showCurrentData()
        setupViewsHierarchy()
        setupLayout()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    // MARK: Setup & Layout
    
    private func showCurrentData() {
        getAllUsers()
    }
    
    private func setupViewsHierarchy() {
        [textField, blueButton, grayView, tableView].forEach { view.addSubview($0) }
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
            make.top.equalTo(grayView.snp.top).offset(20)
            make.leading.equalTo(grayView.snp.leading).offset(15)
            make.trailing.equalTo(grayView.snp.trailing).offset(-15)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    // MARK: Actions
    
    @objc
    private func blueButtonPressed() {
        let alert = UIAlertController(title: "New User", message: "Enter new User name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else { return }
            
            self?.createUser(name: text)
        }))
        
        present(alert, animated: true)
    }
    
    
    
    // MARK: Core Data
    
    func getAllUsers() {
        do {
            models = try context.fetch(UserList.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
//            fatalError("Fatal error!")
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func createUser(name: String) {
        let newUser = UserList(context: context)
        newUser.name = name
        newUser.dateOfBirth = Date()
        
        do {
            try context.save()
            getAllUsers()
        }
        catch {
//            fatalError("Fatal error!")
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func deleteUser(user: UserList) {
        context.delete(user)
        
        do {
            try context.save()
            getAllUsers()
        }
        catch {
//            fatalError("Fatal error!")
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func updateUser(user: UserList, newName: String) {
        user.name = newName
//        let refinedUser = UserList(context: context)
//        refinedUser.name = name
        
        do {
            try context.save()
            getAllUsers()
        }
        catch {
            fatalError("Fatal error!")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        cell.textLabel?.text = model.name
        // presenter?.configure(cell: cell, forRow: indexPath.row)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = models[indexPath.row]
        let actionSheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Edit user", style: .default, handler: { [weak self] _ in
            
            let alert = UIAlertController(title: "Edit info", message: "Edit current user info", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = user.name
            alert.addAction(UIAlertAction(title: "Confirm", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else { return }
                
                self?.updateUser(user: user, newName: newName)
            }))
            
            self?.present(alert, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteUser(user: user)
        }))
        
        present(actionSheet, animated: true)
        // presenter?.didSelectRow(at: indexPath)
    }
}
