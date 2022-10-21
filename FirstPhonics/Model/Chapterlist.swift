

import Foundation

struct Chapterlist : Codable {
	let chapter_name : String?
	let medianame : String?
	let id : Int?
	let week : String?
	let paid : Bool?
	let isError : Bool?
	let message : String?

	enum CodingKeys: String, CodingKey {

		case chapter_name = "chapter_name"
		case medianame = "medianame"
		case id = "Id"
		case week = "Week"
		case paid = "Paid"
		case isError = "IsError"
		case message = "Message"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		chapter_name = try values.decodeIfPresent(String.self, forKey: .chapter_name)
		medianame = try values.decodeIfPresent(String.self, forKey: .medianame)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        week = try values.decodeIfPresent(String.self, forKey: .week)
        paid = try values.decodeIfPresent(Bool.self, forKey: .paid)
        isError = try values.decodeIfPresent(Bool.self, forKey: .isError)
        message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}
