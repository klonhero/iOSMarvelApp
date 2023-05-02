import UIKit
import CollectionViewPagingLayout

final class CharacterCollectionViewCell: UICollectionViewCell {
    
    struct Model {
        var name: String
        var url: URL?
    }
    
    func setup(with model: Model) {
        heroImageView.fetch(from: model.url)
        imageAverageColor = heroImageView.image?.averageColor?.lighter(by: 30)
        label.text = model.name
    }
    
    lazy var imageAverageColor: UIColor? = {
        let color = heroImageView.image?.averageColor?.lighter(by: 30)
        return color
    }()
    
    private lazy var heroImageView: UIImageView = {
        let imageView = UIImageView(frame: self.frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
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
    
    private var gradientView: GradientView = {
        let gradientView = GradientView(gradientStartColor: UIColor.black.withAlphaComponent(0), gradientEndColor: UIColor.black.withAlphaComponent(0.5))
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        containerView.addSubview(heroImageView)
        containerView.addSubview(gradientView)
        containerView.addSubview(label)
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30)
        ])
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 50),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            label.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15),
            label.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            heroImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            heroImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        ])
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: heroImageView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor),
            gradientView.leftAnchor.constraint(equalTo: heroImageView.leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: heroImageView.rightAnchor)
        ])

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension CharacterCollectionViewCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.linear)
    }
}
