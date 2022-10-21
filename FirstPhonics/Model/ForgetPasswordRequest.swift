//
//  ForgetPasswordRequest.swift
//  FirstPhonics
//
//  Created by Apple on 25/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation


struct ForgetPasswordRequest : Codable {
    
    var username : String?
    
    enum CodingKeys: String, CodingKey {
        
        case username = "username"
    }
    
}

