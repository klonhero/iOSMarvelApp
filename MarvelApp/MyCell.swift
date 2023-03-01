import UIKit
import CollectionViewPagingLayout

class MyCell: UICollectionViewCell {

    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension MyCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        .layout(.linear)
    }
}
