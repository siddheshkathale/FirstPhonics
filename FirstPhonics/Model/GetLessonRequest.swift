//
//  GetLessonRequest.swift
//  FirstPhonics
//
//  Created by Apple on 23/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation

struct GetLessonRequest : Codable {
    var tutorial_id : String?
    var user_Id : String?
    var Device_Id : String?
    
    enum CodingKeys: String, CodingKey {
        
        case tutorial_id = "tutorial_id"
        case user_Id = "User_Id"
        case Device_Id = "Device_Id"
    }
    
}
