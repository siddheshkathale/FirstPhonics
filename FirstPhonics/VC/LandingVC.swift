//
//  LandingVC.swift
//  FirstPhonics
//
//  Created by Apple on 15/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit
import AVFoundation

class LandingVC: UIViewController {

    @IBAction func LoginAction(_ sender: Any) {
        
        print("@@ login landing page")
    }
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        getAudioFile()
        
    }

    func playUsingAVAudioPlayer(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }
    
    func getAudioFile(){
        
        guard let filePath = Bundle.main.path(forResource: "teacher", ofType: "mp3") else {
            print("@@ File does not exist in the bundle.")
            return
        }
        
        let url = URL(fileURLWithPath: filePath)
        
        playUsingAVAudioPlayer(url: url)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        do {
            
            if(audioPlayer != nil){
                audioPlayer?.stop()
            }
            
        } catch {
            print(error)
        }
    }

    
}
