//
//  LoginFromOtherDeviceResponse.swift
//  FirstPhonics
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation

struct LoginFromOtherDeviceResponse : Codable {
    let username : String?
    let email : String?
    let paid : Bool?
    let flag : Int?
    let id : Int?
    let device_Id : String?
    let isError : Bool?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        
        case username = "username"
        case email = "email"
        case paid = "Paid"
        case flag = "Flag"
        case id = "Id"
        case device_Id = "Device_Id"
        case isError = "IsError"
        case message = "Message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        paid = try values.decodeIfPresent(Bool.self, forKey: .paid)
        flag = try values.decodeIfPresent(Int.self, forKey: .flag)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        device_Id = try values.decodeIfPresent(String.self, forKey: .device_Id)
        isError = try values.decodeIfPresent(Bool.self, forKey: .isError)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
}
