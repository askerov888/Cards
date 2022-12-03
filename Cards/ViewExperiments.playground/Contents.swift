import Foundation

struct Photo: Codable{
	//String, URL, Bool and Date conform to Codable.
	var title: String
	var url: URL
	var isSample: Bool
	
	//The Dictionary is of type [String:String] and String already conforms to Codable.
	var metaData: [String:String]
	
	//PhotoType and Size are also Codable types
	var type: PhotoType
	var size: Size
}

struct Size: Codable {
	var height: Double
	var width: Double
}

enum PhotoType: String, Codable {
	case flower
	case animal
	case fruit
	case vegetable
}


let photoObject = Photo(title: "Hibiscus", url: URL(string: "https://www.flowers.com/hibiscus")!, isSample: false, metaData: ["color" : "red"], type: .flower, size: Size(height: 200, width: 200))
//let encodedData = try? JSONEncoder().encode(photoObject)
//
//type(of: photoObject)
//print("\(encodedData)")
//



let jsonString = """
 {
	"type":"fruit",
	"size":{
			   "width":150,
			   "height":150
		   },
	"title":"Apple",
	"url":"https:\\/\\/www.fruits.com\\/apple",
	"isSample":true,
	"metaData":{
				  "color":"green"
			   }
}
"""

//if let jsonData = jsonString.data(using: .utf8) {
//	let photoObject = try? JSONDecoder().decode(Photo.self, from: jsonData)
//	photoObject?.title
//	photoObject?.url
//}



func decodePhoto(inputJson: String) -> Photo? {
	guard let jsonData = jsonString.data(using: .utf8) else {return nil}
	guard let photoObject = try? JSONDecoder().decode(Photo.self, from: jsonData) else {return nil}
	return photoObject
}

func encodePhoto(input: Photo) -> Data? {
	guard let encodeFile = try? JSONEncoder().encode(input) else {return nil}
	return encodeFile
}

let answer = decodePhoto(inputJson: jsonString)
//answer?.url
//answer?.title
//answer?.size.height



let exampleEncode = encodePhoto(input: answer!)
type(of: answer)



