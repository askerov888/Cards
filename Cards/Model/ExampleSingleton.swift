import UIKit

class Singlton {
	static var shared: Singlton = Singlton()
	
	private init() {}
	
	var exampleInt = 100
	var exampleString = "Hello"
}
