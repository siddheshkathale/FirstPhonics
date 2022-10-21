//
//  ViewController.swift
//  FirstPhonics
//
//  Created by Apple on 15/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer()
    }
    
    func timer()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
        {
            let login = UserDefaults.standard.bool(forKey: "IsLogin")
            UserDefaults.standard.set(true, forKey: "IsLanding")
            //print("@@ SplashVC login:: \(login)")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            if(login)
            {
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                
                self.present(nextViewController, animated: true, completion: nil)
            }
            else
            {
                
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "MainMenuVC") as! MainMenuVC
                let navigationController = UINavigationController(rootViewController: vc)
                self.present(navigationController, animated: true, completion: nil)
                
                
                
                //let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SingleMainMenuVC") as! SingleMainMenuVC
                
                //self.present(nextViewController, animated: true, completion: nil)
                
    
                
//                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LandingVC") as! LandingVC
//
//                self.present(nextViewController, animated: true, completion: nil)
            }
            
            
            
        }
    }

  
    
}

