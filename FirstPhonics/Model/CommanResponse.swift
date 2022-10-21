//
//  CommanResponse.swift
//  FirstPhonics
//
//  Created by Apple on 23/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation

struct CommanResponse : Codable {
    
    let isError : Bool?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        
        case isError = "IsError"
        
        case message = "Message"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isError = try values.decodeIfPresent(Bool.self, forKey: .isError)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
}
