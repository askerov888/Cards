//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        
        createBezier(on: view)
    }
}

private func createBezier(on view: UIView) {
    let shapeLayer = CAShapeLayer()
    view.layer.addSublayer(shapeLayer)

    shapeLayer.lineWidth = 5
    shapeLayer.strokeColor = UIColor.black.cgColor
    shapeLayer.fillColor = UIColor.systemBlue.cgColor

        
    shapeLayer.path = getPath().cgPath
}

private func getPath() -> UIBezierPath {
    let path = UIBezierPath()
    
    path.move(to: CGPoint(x: 150, y: 250))
    path.addLine(to: CGPoint(x: 150, y: 200))
    path.addLine(to: CGPoint(x: 140, y: 200))
    path.addArc(withCenter: CGPoint(x: 140, y: 150), radius: 50, startAngle: .pi/2, endAngle: .pi*3/2, clockwise: true)
    path.addLine(to: CGPoint(x: 150, y: 100))
    path.addLine(to: CGPoint(x: 150, y: 90))
    path.addArc(withCenter: CGPoint(x: 200, y: 90), radius: 50, startAngle: .pi, endAngle: 0, clockwise: true)
    path.addLine(to: CGPoint(x: 250, y: 100))
    path.addLine(to: CGPoint(x: 260, y: 100))
    path.addArc(withCenter: CGPoint(x: 260, y: 150), radius: 50, startAngle: .pi*3/2, endAngle: .pi/2, clockwise: true)
    path.addLine(to: CGPoint(x: 250, y: 200))
    path.addLine(to: CGPoint(x: 250, y: 250))
    path.close()
    
    return path
    }
    
PlaygroundPage.current.liveView = MyViewController()
