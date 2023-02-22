import UIKit
import CollectionViewPagingLayout

class MyCell: UICollectionViewCell {
    
    // The card view that we apply transforms on
    var card: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        // Adjust the card view frame
        // you can use Auto-layout too
        let cardFrame = CGRect(
            x: 80,
            y: 100,
            width: frame.width - 160,
            height: frame.height - 200
        )
        card = UIView(frame: cardFrame)
        card.backgroundColor = .systemOrange
        contentView.addSubview(card)
    }
}

extension MyCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.linear)
    }
}
