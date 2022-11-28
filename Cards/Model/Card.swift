import UIKit

enum CardType: CaseIterable {
	case circle, cross, square, fill, round
}

enum CardColor: CaseIterable {
	case red, green, black, gray, brown, yellow, purple, orange
}

typealias Card = (type: CardType, color: CardColor)
