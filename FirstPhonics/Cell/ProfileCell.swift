//
//  ProfileCell.swift
//  FirstPhonics
//
//  Created by Apple on 20/06/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var lblUsername: UILabel!
    
    
    @IBOutlet weak var lblEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
