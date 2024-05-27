
import UIKit
import SnapKit
import CoreData

final class DetailViewController: UIViewController, DetailViewProtocol {
    
    private let member: MemberList
    private var detailPresenter: DetailPresenter?
    private var isEditingEnabled = false
    
    // MARK: Initializers
    
    init(member: MemberList) {
        self.member = member
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Elements & Outlets
    
    var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.tintColor = .black
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 3.0
        button.layer.borderColor =
        UIColor.systemBlue.cgColor
        button.addTarget(nil, action: #selector(DetailViewController.editButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var memberImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "eurovision")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 125
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var detailGrayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .systemGray6
        return grayView
    }()
    
    private lazy var memberDataTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DetailViewCell.self,
                           forCellReuseIdentifier: "detailDefaultCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailPresenter()
        setupViewsHierarchy()
        setupLayout()
    }
    
    // MARK: Setup & Layout
    
    private func setupDetailPresenter() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Error: fatal error")
        }
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = delegate.persistentContainer.viewContext
        detailPresenter = DetailPresenter(view: self, member: member, context: context)
    }
    
    private func setupViewsHierarchy() {
        [editButton, memberImage, detailGrayView].forEach { view.addSubview($0) }
        detailGrayView.addSubview(memberDataTable)
    }
    
    private func setupLayout() {
        editButton.snp.makeConstraints { make in
            make.top.equalTo(view).offset(140)
            make.trailing.equalTo(view).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        memberImage.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(210)
            make.width.height.equalTo(250)
        }
        
        detailGrayView.snp.makeConstraints { make in
            make.top.equalTo(memberImage.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalTo(view)
        }
        
        memberDataTable.snp.makeConstraints { make in
            make.centerX.equalTo(detailGrayView)
            make.top.equalTo(detailGrayView).offset(40)
            make.leading.equalTo(detailGrayView.snp.leading).offset(15)
            make.trailing.equalTo(detailGrayView.snp.trailing).offset(-15)
            make.height.equalTo(4 * 60).priority(.high)
        }
    }
    
    func updateMemberData(name: String?, dateOfBirth: Date?, gender: String?, song: String?) {
        detailPresenter?.updateMember(name: name, dateOfBirth: dateOfBirth, gender: gender, song: song)
        memberDataTable.reloadData()
    }
    
    // MARK: Actions
    
    @objc
    func editButtonPressed() {
        isEditingEnabled.toggle()

        editButton.setTitle(isEditingEnabled ? "Save" : "Edit", for: .normal)
        editButton.backgroundColor = isEditingEnabled ? .systemBlue : .white
        
        if !isEditingEnabled { detailPresenter?.saveContext() }
    }
}

// MARK: - Extensions

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MemberList.managedPropertiesCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailDefaultCell", for: indexPath) as? DetailViewCell else  {
            return UITableViewCell()
        }

        switch indexPath.row {
        case 0:
            cell.configureCell(with: detailPresenter?.getMemberName() ?? "", iconName: "person")
        case 1:
            if let dateOfBirth = member.dateOfBirth {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                cell.configureCell(with: dateFormatter.string(from: dateOfBirth), iconName: "calendar")
            } else { cell.configureCell(with: "", iconName: "calendar") }
        case 2:
            cell.configureCell(with: detailPresenter?.getMemberGender() ?? "", iconName: "person.2.circle")
        case 3:
            cell.configureCell(with: detailPresenter?.getMemberSong() ?? "", iconName: "music.note")
        default:
            break
        }
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         
         guard isEditingEnabled else { return }
         
         switch indexPath.row {
         case 0:
             presentTextInputAlert(for: indexPath, title: "Edit Name", text: detailPresenter?.getMemberName(), placeholder: "Enter name") { [weak self] newName in
                 self?.detailPresenter?.setMemberName(newName)
                 self?.memberDataTable.reloadRows(at: [indexPath], with: .automatic)
             }
         case 1:
             presentDatePickerAlert(for: indexPath)
         case 2:
             presentGenderSelectionAlert(for: indexPath)
         case 3:
             presentTextInputAlert(for: indexPath, title: "Edit Song", text: detailPresenter?.getMemberSong(), placeholder: "Enter song") { [weak self] newSong in
                 self?.detailPresenter?.setMemberSong(newSong)
                 self?.memberDataTable.reloadRows(at: [indexPath], with: .automatic)
             }
         default:
             break
         }
     }
}

private extension DetailViewController {
    private func presentGenderSelectionAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Choose gender", message: nil, preferredStyle: .actionSheet)
        let genders = ["Male", "Female", "Non-Binary"]
        
        genders.forEach { gender in
            alert.addAction(UIAlertAction(title: gender, style: .default, handler: { [weak self] _ in
                self?.detailPresenter?.setMemberGender(gender)
                self?.detailPresenter?.saveContext()
                self?.memberDataTable.reloadRows(at: [indexPath], with: .automatic)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentDatePickerAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Select date of birth", message: nil, preferredStyle: .actionSheet)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        if #available(iOS 14.0, *) { datePicker.preferredDatePickerStyle = .wheels }
        alert.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(alert.view).offset(20)
            make.leading.equalTo(alert.view).offset(20)
            make.trailing.equalTo(alert.view).offset(-20)
            make.bottom.equalTo(alert.view).offset(-60)
        }
        
        let selectAction = UIAlertAction(title: "Select", style: .default) { [weak self] _ in
            self?.detailPresenter?.setMemberDateOfBirth(datePicker.date)
            self?.detailPresenter?.saveContext()
            self?.memberDataTable.reloadRows(at: [indexPath], with: .automatic)
        }
        alert.addAction(selectAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentTextInputAlert(for indexPath: IndexPath, title: String, text: String?, placeholder: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = text
            textField.placeholder = placeholder
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            if let textField = alert.textFields?.first, let inputText = textField.text {
                completion(inputText)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
