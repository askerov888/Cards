protocol oldHobbitDelegate: AnyObject {
	func getAGlassOfWaterToOldHobbit()
}

class GrandfatherHobbit {
	weak var delegate: oldHobbitDelegate?
	
	func tell() {
		delegate?.getAGlassOfWaterToOldHobbit()
	}
}

class GoodSon: oldHobbitDelegate {
	func getAGlassOfWaterToOldHobbit() {
		print("It's your water")
	}
}

class BadSon: oldHobbitDelegate {
	func getAGlassOfWaterToOldHobbit() {
		print("No, I am busy")
	}
}

// the start story

let grandfather = GrandfatherHobbit()
let ivan = BadSon()
let masha = GoodSon()

grandfather.delegate = ivan
grandfather.tell()

grandfather.delegate = masha
grandfather.tell()


