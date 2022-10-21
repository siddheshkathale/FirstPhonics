//
//  PostRegistrationRequest.swift
//  FirstPhonics
//
//  Created by Apple on 23/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation

struct PostRegistrationRequest : Codable {
    
    var username : String?
    var email : String?
    var password : String?
    var Address : String?
    
    var City : String?
    var Country_Code : String?
    var Country : String?
    var Child_Name : String?
    var Mobile_No : String?
    
    var Name : String?
    var State : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case username = "username"
        case email = "email"
        case password = "password"
        
        case Address = "Address"
        case City = "City"
        
        case Country_Code = "Country_Code"
        case Country = "Country"
        case Child_Name = "Child_Name"
        
        case Mobile_No = "Mobile_No"
        case Name = "Name"
        case State = "State"
        
        
    }

    
}
