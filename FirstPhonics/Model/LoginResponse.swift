//
//  LoginResponse.swift
//  FirstPhonics
//
//  Created by Apple on 23/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation

struct LoginResponse : Codable {
    
 
    
    let username : String?
    let email : String?
    let paid : Bool?
    let id : Int?
    let isError : Bool?
    let message : String?
    let flag : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case username = "username"
        case email = "email"
        case paid = "Paid"
        case id = "Id"
        case isError = "IsError"
        case message = "Message"
        case flag = "Flag"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        paid = try values.decodeIfPresent(Bool.self, forKey: .paid)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        isError = try values.decodeIfPresent(Bool.self, forKey: .isError)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        flag = try values.decodeIfPresent(Int.self, forKey: .flag)
    }
    
    
}
