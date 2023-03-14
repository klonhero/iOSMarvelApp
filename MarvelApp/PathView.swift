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
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY * 0.75))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.close()
        path.lineWidth = 3
        setupNewColor()
    }
}
