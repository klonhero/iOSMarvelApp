import UIKit

final class PathView: UIView {
    private let path = UIBezierPath()
    var color: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    private func setupNewColor() {
        color.setStroke()
        path.stroke()
        color.setFill()
        path.fill()
    }
    
    override func draw(_ rect: CGRect) {
        path.move(to: CGPoint(x: UIScreen.main.bounds.minX, y: UIScreen.main.bounds.maxY))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.maxX, y: UIScreen.main.bounds.maxY))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.maxX, y: UIScreen.main.bounds.midY * 0.75))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.minX, y: UIScreen.main.bounds.maxY))
        path.close()
        path.lineWidth = 3
        setupNewColor()
    }
}
