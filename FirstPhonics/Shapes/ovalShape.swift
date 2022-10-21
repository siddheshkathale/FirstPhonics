//
//  ovalShape.swift
//  FirstPhonics
//
//  Created by Apple on 22/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit

class ovalShape: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 150, height: 50))
        UIColor.gray.setFill()
        ovalPath.fill()
        
    }
 

}
