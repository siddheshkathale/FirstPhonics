//
//  GetLessonResponse.swift
//  FirstPhonics
//
//  Created by Apple on 23/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation

struct GetLessonResponse : Codable {
    var chapterlist : [Chapterlist]?
    let paid : Bool?
    let isError : Bool?
    let message : String?
    let flag : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case chapterlist = "chapterlist"
        case paid = "Paid"
        case isError = "IsError"
        case message = "Message"
        case flag = "Flag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        chapterlist = try values.decodeIfPresent([Chapterlist].self, forKey: .chapterlist)
        paid = try values.decodeIfPresent(Bool.self, forKey: .paid)
        isError = try values.decodeIfPresent(Bool.self, forKey: .isError)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        flag = try values.decodeIfPresent(Int.self, forKey: .flag)
    }
    
}
