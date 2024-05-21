
import UIKit
import SnapKit

final class DetailViewCell: UITableViewCell {
    
    // MARK: UI Elements & Oulets
    
    public var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
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
        [iconView, titleLabel].forEach { contentView.addSubview($0) }}
    
    func configureCell(with title: String, iconName: String) {
        titleLabel.text = title
        iconView.image = UIImage(systemName: iconName)
    }
    
    private func setupLayout() {
        iconView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(15)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(15)
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-15)
        }
    }
}
 
