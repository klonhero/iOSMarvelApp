import UIKit

class PathView: UIView {
    var path: UIBezierPath? {
        didSet {
            setNeedsDisplay()
        }
    }
    var pathColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        pathColor.setStroke()
        path?.stroke()
        pathColor.setFill()
        path?.fill()
    }
}
