
import UIKit
import SnapKit

final class DetailViewCell: UITableViewCell {
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = false
        return textField
    }()
 
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewsHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup & Layout
    
    private func setupViewsHierarchy() {
        [iconView, textField].forEach { contentView.addSubview($0) }}
    
    private func setupLayout() {
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(30)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(with title: String?, iconName: String) { // , isEditable: Bool
        iconView.image = UIImage(systemName: iconName)
        
        if let title = title, !title.isEmpty {
            textField.text = title
            textField.textColor = UIColor.label
        } else {
            var placeholderText = ""
            switch iconName {
            case "calendar":
                placeholderText = "Choose member date of birth"
            case "person.2.circle":
                placeholderText = "Choose member gender"
            case "music.note":
                placeholderText = "Enter member song"
            default:
                break
            }
        
            textField.text = placeholderText
            textField.textColor = UIColor.secondaryLabel
        }
        
        func setEditing(_ editing: Bool) {
            textField.isUserInteractionEnabled = editing
        }
//        textField.isUserInteractionEnabled = isEditable
    }
}
 
