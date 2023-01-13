import UIKit

// список всех возможных видов форм
enum CardType: CaseIterable {
	case circle, cross, square, fill, round
}

// список всех возможных светов
enum CardColor: CaseIterable {
	case red, green, black, gray, brown, yellow, purple, orange
}

// новый тип данных
typealias Card = (type: CardType, color: CardColor)
