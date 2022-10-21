//
//  LessonChapterModel.swift
//  FirstPhonics
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation

struct LessonChapterModel : Codable {
    var lessonName : String?
    var Week : String?
    var lessonURL : String?
    var message_label : String?
    var paid : Bool?
    var deviceIdFlag:Int?
    
    enum CodingKeys: String, CodingKey {
        
        case lessonName = "lessonName"
        case Week = "Week"
        case lessonURL = "lessonURL"
        case message_label = "message_label"
        case paid = "paid"
        case deviceIdFlag = "deviceIdFlag"
        
    }
    
}
