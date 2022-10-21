//
//  ChangePasswordRequest.swift
//  FirstPhonics
//
//  Created by Apple on 25/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation


struct ChangePasswordRequest : Codable {
    var id : String?
    var password : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "Id"
        case password = "password"
    }

    
}
