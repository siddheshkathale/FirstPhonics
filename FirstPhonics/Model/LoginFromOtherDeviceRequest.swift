//
//  LoginFromOtherDeviceRequest.swift
//  FirstPhonics
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation

struct LoginFromOtherDeviceRequest : Codable {
    
    var id : String?
    var device_Id : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "Id"
        case device_Id = "Device_Id"
    }
    
    
    
}
