import UIKit

// Класс описывающий доску игры
class BoardGameController: UIViewController {
	// счетчик шагов
	var stepCount = 0
	
	override func loadView() {
		super.loadView()
		view.addSubview(startButtonView)
		view.addSubview(boardGameView)
		view.addSubview(openAllCards)
		view.addSubview(stepCountLabel)
	}
	
	// обновление лейбла счетчика шагов
	func updateTextInLabel(startWith: Int?) {
		if startWith != nil {
			stepCount = startWith!
			stepCountLabel.text = String(stepCount)
		} else {
		stepCount += 1
		stepCountLabel.text = String(stepCount)
		print("update func works!, \(stepCount)")
		}
	}
	
	// Булевое значение началась игра или нет
	var flagGameStartOrNot = false
	
	// количество всех карт на поле
	var AllCards = 0
	
	// количество пар карт
	var cardsPairsCount = 8
	
	// создания новый  игры
	lazy var game = getNewGame()
	func getNewGame() -> Game {
		let game = Game()
		game.cardsCount = self.cardsPairsCount
		game.generateCards()
		AllCards = self.cardsPairsCount * 2
		return game
	}

	lazy var stepCountLabel = getStepCountLabel()
	lazy var startButtonView = getStartButtonView()
	lazy var openAllCards = getOpenAllCards()
	
	// кнопка лейба счетчика шагов
	 func getStepCountLabel() -> UILabel {
		let label = UILabel(frame: CGRect(x: Int(view.center.x) + 110, y: 0, width: Int(view.center.x) - 120, height: 50))
		let window = UIApplication.shared.windows[0]
		label.frame.origin.y = window.safeAreaInsets.top + (navigationController?.navigationBar.frame.size.height ?? 0)
		 		 
		label.textAlignment = .center
		label.textColor = .black
		label.font = UIFont.systemFont(ofSize: 25)
		label.textColor = .white
		label.layer.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
		label.layer.cornerRadius = 10
		 label.text = "0"

		return label
	}
	
	// кнопка открытия всех карт
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
	
	// метод открытия всех карт
	@objc func openAll(sender: UIButton) {
		let counter = stepCount
		let allCards = self.boardGameView.subviews.count
		
		// все перевернутые карты
		var allFlippedCards = 0 {
			// обсервер отвечающий за переворт всех карт
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
		
		// все не перевернутые карты
		var allNotFlippedCards = 0 {
			// обсервер отвечающий за переворт всех карт
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
	
	// кнопка запуска
	private func getStartButtonView() -> UIButton {

		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
		button.center.x = view.center.x
		
		button.setTitle("Запуск", for: .normal)
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
	
	// метод запуска новый игры
	@objc func startGame() {
		if flagGameStartOrNot == false {
			game = getNewGame()
			let cards = getCardsBy(modelData: game.cards)
			placeCardsOnBoard(cards: cards)
			self.flagGameStartOrNot = true
			updateTextInLabel(startWith: 0)
		} else {
			
			// Аллерт указывающий что игра уже запущена
			let allert = UIAlertController(title: "Внимание", message: "Вы уже запустили игру", preferredStyle: .alert)
			allert.view?.layer.cornerRadius = 100
			allert.view.layer.backgroundColor = UIColor.yellow.cgColor
			
			// начало новой игры
			let start = UIAlertAction(title: "Начать сначало", style: .default, handler: { [unowned self] _ in
				for i in boardGameView.subviews {
					i.removeFromSuperview()
				}
				game = getNewGame()
				let cards = getCardsBy(modelData: game.cards)
				placeCardsOnBoard(cards: cards)
				updateTextInLabel(startWith: 0)
				flagGameStartOrNot = true
			})
			
			// остаться на нынешей игре
			let ok = UIAlertAction(title: "Остаться", style: .default, handler: nil)
			allert.addAction(start)
			allert.addAction(ok)
			present(allert, animated: true, completion: nil)
		}
	}

	// создания доски для игры
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

	// перевернутые карты
	private var flippedCards = [UIView]()

	// получение карт из фабрики
	func getCardsBy(modelData :[Card]) -> [UIView] {
		var cardViews = [UIView]()
		let cardViewFactory = CardViewFactory()
		
		// создания пар одинаковых карт с одинаковым тэгом
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
				
				// если карта перевёрнута добавить в перевернутые карты
				if flippedcard.isFlipped {
					flippedCards.append(flippedcard)
					updateTextInLabel(startWith: nil)
				}
				else {
					if let index = flippedCards.firstIndex(of: flippedcard) {
						flippedCards.remove(at: index)
					}
				}
				
				// если перевернутые карты 2, нужно проверить
				if flippedCards.count == 2 {
					let firstCard = game.cards[self.flippedCards.first!.tag]
					let secondCard = game.cards[self.flippedCards.last!.tag]
					
					// если тэг карт совпадает то удаляются из супервью
					if game.checkCards(firstCard: firstCard, secondCard: secondCard) {
						AllCards -= 2
						
						// если карт не осталась на доске то конец игры
						if AllCards == 0 {
							let allert = UIAlertController(
								title: "Игра окончена",
								message: "Вы закончали игру за  \(stepCount) шага",
								preferredStyle: .alert)
							let start = UIAlertAction(
								title: "Начать новую игру?",
								style: .default) { _ in
									flagGameStartOrNot = false
									startGame()
								}
							allert.addAction(start)
							present(allert, animated: true, completion: nil)
						}
						
						// анимация удаления карт
						UIView.animate(withDuration: 1, animations: {
							self.flippedCards.first!.layer.opacity = 0
							self.flippedCards.last!.layer.opacity = 0
						}, completion: {_ in
							self.flippedCards.first?.removeFromSuperview()
							self.flippedCards.last?.removeFromSuperview()
							self.flippedCards = []
						})
					} else {
						// если карты не совпадают карта заново переворачиваются
						for card in self.flippedCards {
							(card as! FlippableView).flip()
						}
					}
				}
			}
		}
		return cardViews
	}

	// размеры карт
	var cardSize: CGSize { CGSize(width: 80, height: 120) }
	
	// максимальные коорниданты карт
	private var cardMaxXCoordinates: Int { Int(boardGameView.frame.width - cardSize.width) }
	private var cardMaxYCoordinates: Int { Int(boardGameView.frame.height - cardSize.height) }
	
	var cardViews = [UIView]()
	
	// расположение карт на доске
	private func placeCardsOnBoard(cards: [UIView]) {
		for card in cards {
			card.removeFromSuperview()
		}
		cardViews = cards
		
		// случайно расположение на доске
		for card in cardViews {
			let randomCoordinatesX = Int.random(in: 0...cardMaxXCoordinates)
			let randomCoordinatesY = Int.random(in: 0...cardMaxYCoordinates)
			
			card.frame.origin = CGPoint(x: randomCoordinatesX, y: randomCoordinatesY)
			boardGameView.addSubview(card)
		}
	}
}
