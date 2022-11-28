import UIKit

class StartViewController: UIViewController {
	
	override func loadView() {
		super.loadView()
		view.backgroundColor = .lightGray
		view.addSubview(buttonStart)
	}
	
	lazy var buttonStart = getButtonStart()
	private func getButtonStart() -> UIButton {
		let button = UIButton()
		button.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
		button.center.y = view.center.y
		button.center.x = view.center.x
		
		button.setTitle("Старт Игры", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.setTitleColor(.gray, for: .highlighted)
		button.layer.cornerRadius = 10
		button.backgroundColor = .white
		
		button.addTarget(nil, action: #selector (goToGameBoard), for: .touchUpInside)
		
		return button
	}

	
	@objc func goToGameBoard(sender: UIButton) {
		let story = UIStoryboard(name: "Main", bundle: nil)
		let boardScene = story.instantiateViewController(withIdentifier: "BoardGameController") as! BoardGameController
		navigationController?.pushViewController(boardScene, animated: true)
		
		//		let goToBoardSegue = UIStoryboardSegue.init(identifier: "goToBoard", source: story.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController, destination: boardScene as! BoardGameController)
	}
}
