import UIKit
import Kingfisher

final class ActivityIndicatorView: UIView {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private let blurEffect: UIBlurEffect = {
        let blurEffect = UIBlurEffect(style: .dark)
        return blurEffect
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView()
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.effect = self.blurEffect
        return visualEffectView
    }()
    
    func start() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.5
        }
    }
    
    func stop() {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
    }
    
    private func setLayout() {
        self.addSubview(visualEffectView)
        visualEffectView.backgroundColor = .red
        visualEffectView.contentView.addSubview(activityIndicator)
        setupVisualEffectView()
        setupActivityIndiactor()
    }
    
    private func setupVisualEffectView() {
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            visualEffectView.leftAnchor.constraint(equalTo: self.leftAnchor),
            visualEffectView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    private func setupActivityIndiactor() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: visualEffectView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: visualEffectView.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: visualEffectView.heightAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: visualEffectView.widthAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
