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
        path.move(to: CGPoint(x: self.frame.minX, y: self.frame.maxY))
        path.addLine(to: CGPoint(x: self.frame.maxX, y: self.frame.maxY))
        path.addLine(to: CGPoint(x: self.frame.maxX, y: self.frame.midY))
        path.addLine(to: CGPoint(x: self.frame.minX, y: self.frame.maxY))
        path.close()
        path.lineWidth = 3
        setupNewColor()
    }
}
