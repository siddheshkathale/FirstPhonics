//
//  PaymentPopUpVC.swift
//  FirstPhonics
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit

class PaymentPopUpVC: UIViewController {

    
    @IBAction func closeAction(_ sender: Any) {
        
        self.view.removeFromSuperview()
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
