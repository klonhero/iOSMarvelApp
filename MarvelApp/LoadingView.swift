import UIKit
import Kingfisher

final class LoadingView: UIView {
    
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
        visualEffectView.effect = self.blurEffect
        return visualEffectView
    }()
    
    func start() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
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
        visualEffectView.addSubview(activityIndicator)
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
            visualEffectView.centerYAnchor.constraint(equalTo: visualEffectView.centerYAnchor),
        ])
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
