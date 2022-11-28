import UIKit

protocol FlippableView: UIView {
	var isFlipped: Bool {get set}
	var flipCompletionHandler: ((FlippableView) -> Void)? {get set}
	func flip()
}

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView{

	
	
	private var margins = 20
	
	lazy var frontSideView: UIView = self.getFrontSideView()
	lazy var backSideView: UIView = self.getBackSideView()

	private func getFrontSideView() -> UIView {
		setupBorders()
		let view = UIView(frame: self.bounds)
		view.backgroundColor = .white

		let shapeView = UIView(frame: CGRect(x: margins, y: margins, width: Int(self.bounds.width)-margins*2, height: Int(self.bounds.height)-margins*2))
		view.addSubview(shapeView)

		let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)

		shapeView.layer.addSublayer(shapeLayer)
		view.layer.masksToBounds = true
		view.layer.cornerRadius = CGFloat(cornerRadius)
		return view
	}
	
	private var anchorPoint = CGPoint(x: 0, y: 0)
	private var startTouchPoint: CGPoint!
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		anchorPoint.x = touches.first!.location(in: window).x - frame.minX
		anchorPoint.y = touches.first!.location(in: window).y - frame.minY
		startTouchPoint = self.frame.origin
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
		self.frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y

	}

	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		UIView.animate(withDuration: 1) {
			if self.frame.origin == self.startTouchPoint {
			self.flip()
				Steps.stepCount += 1
			}
		}
		UIView.animate(withDuration: 0.5) {
			if self.frame.minY < self.superview!.bounds.minY {
				self.frame.origin.y = 0
			}
			if self.frame.minX < self.superview!.bounds.minX {
				self.frame.origin.x = 0
			}
			if self.frame.maxY > self.superview!.bounds.maxY {
				self.frame.origin.y = self.superview!.bounds.maxY - self.frame.size.height
			}
			if self.frame.maxX > self.superview!.bounds.maxX {
				self.frame.origin.x = self.superview!.bounds.maxX - self.frame.size.width
			}
		}
			
	}
	
	
	private func getBackSideView()-> UIView {
		let view = UIView(frame: self.bounds)
		view.backgroundColor = .white
		setupBorders()
		
		switch ["circle", "line"].randomElement() {
		case "circle":
			let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
			view.layer.addSublayer(layer)
		case "line":
			let layer = BackSideLine(size: self.frame.size, fillColor: UIColor.black.cgColor)
			view.layer.addSublayer(layer)
		default:
			break
		}
		view.layer.masksToBounds = true
		view.layer.cornerRadius = CGFloat(cornerRadius)
		return view
	}
	
	var isFlipped: Bool = false {
		didSet {
			self.setNeedsDisplay()
		}
	}
	var flipCompletionHandler: ((FlippableView) -> Void)?
	func flip() {
		let fromView = isFlipped ? frontSideView: backSideView
		let toView = isFlipped ? backSideView: frontSideView
		UIView.transition(from: fromView, to: toView, duration: 1, options: [.transitionFlipFromTop],
			completion: { _ in
			self.flipCompletionHandler?(self)
		})
		isFlipped.toggle()
	}
	
	var color: UIColor!
	
	override func draw(_ rect: CGRect) {
		backSideView.removeFromSuperview()
		frontSideView.removeFromSuperview()
		
		if isFlipped {
		self.addSubview(backSideView)
		self.addSubview(frontSideView)
	} else {
		self.addSubview(frontSideView)
		self.addSubview(backSideView)
	}
}
	

	init(frame: CGRect, color: UIColor) {
		super.init(frame: frame)
		self.color = color
	}
		
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var cornerRadius = 20
	private func setupBorders() {
		self.clipsToBounds = true
		self.layer.cornerRadius = 20
		self.layer.borderWidth = 2
		self.layer.borderColor = UIColor.black.cgColor
	}
}
