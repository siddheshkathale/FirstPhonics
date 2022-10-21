//
//  LoginRequest.swift
//  FirstPhonics
//
//  Created by Apple on 23/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation

struct LoginRequest : Codable {
    var username : String?
    var password : String?
    
    enum CodingKeys: String, CodingKey {
        
        case username = "username"
        case password = "password"
    }
    
}
