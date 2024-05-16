
import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {
    
//    // MARK: UI Elements & Oulets
//    
//    private lazy var userImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 40
//        return imageView
//    }()
//    
//    private lazy var userName: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.numberOfLines = 1
//        label.textAlignment = .center
//        return label
//    }()
//    
//    private lazy var cardRarity: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.numberOfLines = 1
//        label.textAlignment = .left
//        return label
//    }()
//    
//    // MARK: Data
//    
//    var card: Card? {
//        didSet {
//            cardName.text = card?.name
//            cardRarity.text = card?.rarity
//            
//            guard let imagePath = card?.imageURL,
//                  let imageURL = URL(string: imagePath) else {
//                cardImage.image = UIImage(named: "placeholder")
//                return
//            }
//            
//            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
//                guard let data = data, error == nil else {
//                    DispatchQueue.main.async {
//                        self.cardImage.image = UIImage(named: "placeholder")
//                    }
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.cardImage.image = UIImage(data: data)
//                }
//            }.resume()
//        }
//    }
//    
//    // MARK: Initializers
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViewsHierarchy()
//        setupLayout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: Setup & Layout
//    
//    private func setupViewsHierarchy() {
//        addSubview(cardImage)
//        addSubview(cardName)
//        addSubview(cardRarity)
//    }
//    
//    private func setupLayout() {
//        cardImage.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().offset(-10)
//            make.centerY.equalToSuperview()
//            make.width.height.equalTo(80)
//        }
//        
//        cardName.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(10)
//            make.top.equalToSuperview().offset(10)
//            make.trailing.equalTo(cardImage.snp.leading).offset(-10)
//        }
//        
//        cardRarity.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(10)
//            make.top.equalTo(cardName.snp.bottom).offset(15)
//            make.trailing.equalTo(cardImage.snp.leading).offset(-10)
//        }
//    }
}
