import UIKit

// протокол фигуры слоя
protocol ShapeLayerProtocol: CAShapeLayer {
	init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
	init() {
		fatalError("init() не может быть использован для создания экземпляра")
	}
}

// класс кругов на задней стороны карты
class BackSideCircle: CAShapeLayer, ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
	
		// рисования с помощью путь Бейзера
		let path = UIBezierPath()
		
		// создания 15 случайных кругов
		for _ in 1...15 {
			let randomX = Int.random(in: 0...Int(size.width))
			let randomY = Int.random(in: 0...Int(size.height))
			let center = CGPoint(x: randomX, y: randomY)
			let radius = Int.random(in: 5...15)
			
			path.move(to: center)
			path.addArc(withCenter: center, radius: CGFloat(radius), startAngle: 0, endAngle: .pi*2, clockwise: true)
		}
		self.path = path.cgPath
		self.fillColor = fillColor
		self.strokeColor = fillColor
		self.lineWidth = 1
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// класс линий на задней стороны карты
class BackSideLine: CAShapeLayer, ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		
		// рисования с помощью путь Бейзера
		let path = UIBezierPath()
		
		// создания 15 случайных линий
		for _ in 1...15 {
			let randomXStart = Int.random(in: 0...Int(size.width))
			let randomYStart = Int.random(in: 0...Int(size.height))
			
			let randomXEnd = Int.random(in: 0...Int(size.width))
			let randomYEnd = Int.random(in: 0...Int(size.height))
			
			path.move(to: CGPoint(x: randomXStart, y: randomYStart))
			path.addLine(to: CGPoint(x: randomXEnd, y: randomYEnd))
		}
		
		self.path = path.cgPath
		self.strokeColor = fillColor
		self.lineWidth = 3
		self.lineCap = .round
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// класс описывающий цветной круг на передней стороны карты
class CircleShape: CAShapeLayer, ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		let radius = ([size.width, size.height].min() ?? 0) / 2
		let centerX = size.width/2
		let centerY = size.height/2
		
		let path = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
		path.close()
		
		self.path = path.cgPath
		self.fillColor = fillColor
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// класс описывающий прозрачный круг на передней стороны карты
class RoundShape: CAShapeLayer, ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		let radius = ([size.width, size.height].min() ?? 0) / 2
		let centerX = size.width/2
		let centerY = size.height/2
		
		let path = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
		path.close()
		self.path = path.cgPath
		self.fillColor = .none
		self.strokeColor = UIColor.black.cgColor
		self.lineWidth = 5
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// класс описывающий квадрат на передней стороны карты
class SquareShape: CAShapeLayer, ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		let edgeSize = [size.height, size.width].min() ?? 0
		let rect = UIBezierPath(rect: CGRect(x: 0, y: 0, width: edgeSize, height: edgeSize))
		rect.close()
		self.path = rect.cgPath
		self.fillColor = fillColor
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// класс описывающий крест на передней стороны карты
class CrossShape: CAShapeLayer, ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: size.width, y: size.height))
		path.move(to: CGPoint(x: size.width, y: 0))
		path.addLine(to: CGPoint(x: 0, y: size.height))
		
		self.path = path.cgPath
		self.strokeColor = fillColor
		self.lineWidth = 5
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// класс описывающий прямоугольник на передней стороны карты
class FillShape: CAShapeLayer, ShapeLayerProtocol {
	required init(size: CGSize, fillColor: CGColor) {
		super.init()
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		let path = UIBezierPath(rect: rect)
		self.path = path.cgPath
		self.fillColor = fillColor
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
