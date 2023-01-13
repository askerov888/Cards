import UIKit

class Game {
	// количество карт, которые нужно создать
	var cardsCount = 0

	var cards = [Card]()
	// метод созданния карт из случайных светов и форм
	func generateCards() {
		// создание карт
		for _ in 0..<cardsCount {
			let randomElement = (type: CardType.allCases.randomElement()!, color: CardColor.allCases.randomElement()!)
			cards.append(randomElement)
		}
	}
	// проверка первой и второй карты
	func checkCards(firstCard: Card, secondCard: Card) -> Bool {
		firstCard == secondCard ? true: false
	}
}
