
import UIKit
import SnapKit

// MARK: - Detail Controller

final class DetailViewController: UIViewController, DetailViewProtocol {
    
    private var detailPresenter: DetailPresenter?
    private let member: MemberList
    
    // MARK: UI Elements & Oulets
    
    private lazy var editButton: UIButton = {
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
        button.addTarget(self, action: #selector(editMemberProfileButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var memberImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no-profile-min")
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
    
    lazy var memberDataTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DetailViewCell.self,
                           forCellReuseIdentifier: "detailDefaultCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 15
        tableView.layer.masksToBounds = true
        return tableView
    }()
    
    // MARK: Initializers
    
    init(member: MemberList) {
        self.member = member
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailPresenter()
        setupViewsHierarchy()
        setupLayout()
    }
    
    // MARK: Setup & Layout
    
    private func setupDetailPresenter() {
        detailPresenter = DetailPresenter(view: self, member: member)
    }
    
    private func setupViewsHierarchy() {
        [editButton, memberImage, detailGrayView].forEach { view.addSubview($0) }
        detailGrayView.addSubview(memberDataTable)
    }
    
    func updateMemberData() {
        memberDataTable.reloadData()
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
    
    // MARK: Actions
    
    @objc
    func editMemberProfileButtonPressed() {
        detailPresenter?.editMemberProfile()
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
        
        let data: (title: String, iconName: String)
        switch indexPath.row {
        case 0:
            data = (title: detailPresenter?.getMemberName() ?? "Choose member name", iconName: "person")
        case 1:
            data = (title: "Дата рождения", iconName: "calendar")
        case 2:
            data = (title: detailPresenter?.getMemberGender() ?? "Choose member gender", iconName: "person.2.circle")
        case 3:
            data = (title: detailPresenter?.getMemberSong() ?? "Choose member song", iconName: "music.note")
        default:
            data = (title: "", iconName: "")
        }
        
        cell.configureCell(with: data.title, iconName: data.iconName)
        return cell
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
