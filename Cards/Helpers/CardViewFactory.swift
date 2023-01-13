import UIKit

// Класс-Фабрика в которой генерируются карты с разными формами и цветами.
class CardViewFactory {
	func get(_ shapy: CardType, withSize size: CGSize, color: CardColor) -> UIView {
		let frame = CGRect(origin: .zero, size: size)
		let color = getViewColorBy(color: color)		
		
		switch shapy {
		case .circle:
			return CardView<CircleShape>(frame: frame, color: color)
		case .cross:
			return CardView<CrossShape>(frame: frame, color: color)
		case .square:
			return CardView<SquareShape>(frame: frame, color: color)
		case .fill:
			return CardView<FillShape>(frame: frame, color: color)
		case .round:
			return CardView<RoundShape>(frame: frame, color: color)
		}
	}
	// Метод в котором находятся все цвета
	func getViewColorBy(color: CardColor) -> UIColor {
		switch color {
		case .gray:
			return .gray
		case .black:
			return .black
		case .brown:
			return.brown
		case .green:
			return.green
		case .orange:
			return .orange
		case .purple:
			return .purple
		case .red:
			return .red
		case .yellow:
			return .yellow
		}
	}
}
