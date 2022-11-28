import UIKit

class Game {
	var cardsCount = 0
	
	var cards = [Card]()
	
	func generateCards() {
		var cards = [Card]()
		
		for _ in 0...cardsCount {
			let randomElement = (type: CardType.allCases.randomElement()!, color: CardColor.allCases.randomElement()!)
			cards.append(randomElement)
		}
		self.cards = cards
	}
	
	func checkCards(firstCard: Card, secondCard: Card) -> Bool {
		firstCard == secondCard ? true: false
	}
}
