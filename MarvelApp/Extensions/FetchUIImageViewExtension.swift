import UIKit

extension UIImageView {
    func fetch(from url: URL?) {
        self.kf.setImage(with: url)
    }
    func fetch(from link: String) {
        guard let url = URL(string: link) else { return }
        fetch(from: url)
    }
}
