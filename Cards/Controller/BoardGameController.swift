import UIKit

struct Steps {
	static var stepCount = 0 {
		didSet {
			print(stepCount)
		}
	}
}


class BoardGameController: UIViewController {

	
	override func loadView() {
		super.loadView()
		view.addSubview(startButtonView)
		view.addSubview(boardGameView)
		view.addSubview(openAllCards)
		view.addSubview(stepCountLabel)

	}
	

	
	private func updateTextInLabel() {
		stepCountLabel.text = "\(Steps.stepCount)"
	}
	
	
	var flagGameStartOrNot = false
	
	var cardsPairsCount = 8
	lazy var game = getNewGame()
	
	func getNewGame() -> Game {
		let game = Game()
		game.cardsCount = self.cardsPairsCount
		game.generateCards()
		return game
	}

	lazy var stepCountLabel = getStepCountLabel()
	lazy var startButtonView = getStartButtonView()
	lazy var openAllCards = getOpenAllCards()


	
	
	 func getStepCountLabel() -> UILabel {
		let label = UILabel(frame: CGRect(x: Int(view.center.x) + 110, y: 0, width: Int(view.center.x) - 120, height: 50))
		 let window = UIApplication.shared.windows[0]
		label.frame.origin.y = window.safeAreaInsets.top + (navigationController?.navigationBar.frame.size.height ?? 0)
		 
		 let countString = String(Steps.stepCount)
		 
		label.textAlignment = .center
		label.textColor = .black
		label.font = UIFont.systemFont(ofSize: 25)
		label.textColor = .white
		label.layer.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
		label.layer.cornerRadius = 10

		 label.text = countString
		 print(label.text!)
		 
		 label.setNeedsDisplay()
		 return label
	}
	
	private func getOpenAllCards() -> UIButton {
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: CGFloat(view.center.x - 120), height: 50))
		
		button.setTitle("Переворот", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.setTitleColor(.gray, for: .highlighted)
		
		let window = UIApplication.shared.windows[0]
		button.frame.origin.y = window.safeAreaInsets.top + (navigationController?.navigationBar.frame.size.height ?? 0)
		button.frame.origin.x = 10
		button.layer.cornerRadius = 10
		button.backgroundColor = .green
		button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
		
		button.addTarget(nil, action: #selector(openAll), for: .touchUpInside)
		return button
	}
	
	@objc func openAll(sender: UIButton) {
		
		let allCards = self.boardGameView.subviews.count
		var allFlippedCards = 0 {
			didSet {
				if allFlippedCards >= 1 {
					for i in self.boardGameView.subviews {
						guard let cardCurrent = i as? FlippableView else {return}
						if cardCurrent.isFlipped {
							cardCurrent.flip()
						} else {
							continue
						}
					}
				}
			}
		}
		var allNotFlippedCards = 0 {
			didSet {
				if allNotFlippedCards == allCards {
					for i in self.boardGameView.subviews {
						guard let cardCurrent = i as? FlippableView else {return}
						if !cardCurrent.isFlipped {
							cardCurrent.flip()
						} else {
							continue
						}
					}
				allNotFlippedCards = 0
				}
			}
		}
			
		
		
		// проверка всех карт на доске
		for i in self.boardGameView.subviews {
			guard let cardCurrent = i as? FlippableView else {return}
			if cardCurrent.isFlipped {
				allFlippedCards += 1
				break
			} else {
				allNotFlippedCards += 1
			}
		}
	}
	
	

	private func getStartButtonView() -> UIButton {

		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
		button.center.x = view.center.x
		
		button.setTitle(Singlton.shared.exampleString, for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.setTitleColor(.gray, for: .highlighted)
		button.center.x = view.center.x
		
		let window = UIApplication.shared.windows[0]
		let top = window.safeAreaInsets.top
		
		button.frame.origin.y = top + ((navigationController?.navigationBar.frame.size.height) ?? 0)
		
		button.layer.cornerRadius = 10
		button.backgroundColor = .systemGray4
		button.addTarget(nil, action: #selector(startGame), for: .touchUpInside)
		
		return button
	}
	
	@objc func startGame(sender: UIButton) {
		if flagGameStartOrNot == false {
			game = getNewGame()
			let cards = getCardsBy(modelData: game.cards)
			placeCardsOnBoard(cards: cards)
			self.flagGameStartOrNot = true
		} else {
			let allert = UIAlertController(title: "Внимание", message: "Вы уже запустили игру", preferredStyle: .alert)
			allert.view?.layer.cornerRadius = 100
			allert.view.layer.backgroundColor = UIColor.yellow.cgColor
			let ok = UIAlertAction(title: "Начать сначало", style: .default, handler: { _ in
				for i in self.boardGameView.subviews {
					i.removeFromSuperview()
				}
				self.flagGameStartOrNot = false
			})
			allert.addAction(ok)
			present(allert, animated: true, completion: nil)
		}
	}
	
	lazy var boardGameView = getBoardGameView()
	
	private func getBoardGameView() -> UIView {
		let view = UIView()
		let margin: CGFloat = 10
		
		let safeArea = UIApplication.shared.windows[0].safeAreaInsets
		
		let viewY = safeArea.top + startButtonView.frame.size.height + margin + (navigationController?.navigationBar.frame.size.height ?? 0)
		let viewX = safeArea.left + margin
		let viewWidth = UIScreen.main.bounds.width - (viewX + safeArea.right + margin)
		let viewHeight = UIScreen.main.bounds.height - (viewY + safeArea.bottom + margin)
		
		view.frame = CGRect(x: viewX, y: viewY, width: viewWidth, height: viewHeight)
		
		view.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
		view.layer.cornerRadius = 5

		
		return view
	}
	func getCardsBy(modelData :[Card]) -> [UIView] {
		var cardViews = [UIView]()
		let cardViewFactory = CardViewFactory()
		
		for (index, modelCard) in modelData.enumerated() {
			let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, color: modelCard.color)
			cardOne.tag = index
			cardViews.append(cardOne)
			
			let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, color: modelCard.color)
			cardTwo.tag = index
			cardViews.append(cardTwo)
		}
		
		for card in cardViews {
			(card as! FlippableView).flipCompletionHandler = { [self] flippedcard in
				flippedcard.superview?.bringSubviewToFront(flippedcard)
				
				if flippedcard.isFlipped {
					flippedCards.append(flippedcard)
				} else {
					if let index = flippedCards.firstIndex(of: flippedcard) {
						flippedCards.remove(at: index)
					}
				}
				if flippedCards.count == 2 {
					let firstCard = game.cards[self.flippedCards.first!.tag]
					let secondCard = game.cards[self.flippedCards.last!.tag]
					
					if game.checkCards(firstCard: firstCard, secondCard: secondCard) {
						UIView.animate(withDuration: 1, animations: {
							self.flippedCards.first!.layer.opacity = 0
							self.flippedCards.last!.layer.opacity = 0
						}, completion: {_ in
							self.flippedCards.first?.removeFromSuperview()
							self.flippedCards.last?.removeFromSuperview()
							self.flippedCards = []
						})
					} else {
						for card in self.flippedCards {
							(card as! FlippableView).flip()
						}
					}
				}
			}
		}
		return cardViews
	}

	
	var cardSize: CGSize { CGSize(width: 80, height: 120) }
	private var cardMaxXCoordinates: Int { Int(boardGameView.frame.width - cardSize.width) }
	private var cardMaxYCoordinates: Int { Int(boardGameView.frame.height - cardSize.height) }
	
	var cardViews = [UIView]()
	
	private func placeCardsOnBoard(cards: [UIView]) {
		for card in cards {
			card.removeFromSuperview()
		}
		cardViews = cards
		
		for card in cardViews {
			let randomCoordinatesX = Int.random(in: 0...cardMaxXCoordinates)
			let randomCoordinatesY = Int.random(in: 0...cardMaxYCoordinates)
			
			card.frame.origin = CGPoint(x: randomCoordinatesX, y: randomCoordinatesY)
			boardGameView.addSubview(card)
		}
	}
	
	private var flippedCards = [UIView]()
	
	
}
