//
//  LandscapePlayer.swift
//  FirstPhonics
//
//  Created by Apple on 21/06/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import Foundation
import AVKit

class LandscapePlayer: AVPlayerViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        print("@@ LandscapePlayer")
        NotificationCenter.default.post(name: Notification.Name("closePlayer"), object: nil)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
}
