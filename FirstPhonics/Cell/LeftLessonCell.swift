//
//  LeftLessonCell.swift
//  FirstPhonics
//
//  Created by Apple on 05/06/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit

class LeftLessonCell: UITableViewCell {

    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnLink: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
