//
//  PaymentVC.swift
//  FirstPhonics
//
//  Created by Apple on 20/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {

    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var borderView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.action = #selector(buttonClicked(sender:))
        
        drawBorder(view: borderView)
        
    }
    
    @objc func buttonClicked(sender: UIBarButtonItem) {
        //print("@@ buttonClicked ForgetPasswordVC")
        self.dismiss(animated: true, completion: nil)
    }

    func drawBorder(view : UIView)
    {
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 1
        view.layer.borderColor = Color.border_gray_dark
    }
   
}
