import UIKit

final class DescriptionViewController: UIViewController {
    
    struct Model {
        let url: URL?
        let name: String
        let description: String
    }
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        textView.textAlignment = .left
        textView.isEditable = false
        return textView
    }()
    
    private var gradientView: GradientView = {
        let gradientView = GradientView(gradientStartColor: UIColor.black.withAlphaComponent(0), gradientEndColor: UIColor.black.withAlphaComponent(0.5))
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(gradientView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionTextView)
    
        setupImageView()
        setupNameLabel()
        setupDescriptionLabel()
        setupGradientView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setup(_ model: Model) {
        nameLabel.text = model.name
        descriptionTextView.text = model.description
        imageView.fetch(from: model.url)
    }
    
    private func setupImageView() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func setupNameLabel() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: nameLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupGradientView() {
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientView.leftAnchor.constraint(equalTo: view.leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
