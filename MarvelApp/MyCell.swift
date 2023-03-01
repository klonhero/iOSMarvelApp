import UIKit
import CollectionViewPagingLayout

struct HeroCellModel {
    var name: String
    var image: UIImage
}

final class HeroCell: UICollectionViewCell {
    
    func setupCell(model: HeroCellModel) {
        heroImageView.image = model.image
        label.text = model.name
    }
    
    private lazy var heroImageView: UIImageView = {
        let imageView = UIImageView(frame: self.frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var label: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return textView
    }()
    
    private let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        view.addSubview(heroImageView)
        view.addSubview(label)
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30)
        ])
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            heroImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            heroImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            heroImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension HeroCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.linear)
    }
}
