//
//  MenuVC.swift
//  FirstPhonics
//
//  Created by Apple on 19/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit

class MenuVC: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    
    var cellid = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 1
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.section == 0 {cellid = "ProfileCell"}
        else if indexPath.section == 1 {cellid = "CPCell"}
        else if indexPath.section == 2 {cellid = "HelpCell"}
        else if indexPath.section == 3 {cellid = "LogoutCell"}
        
        
        
        if (indexPath.section == 0) {
            
            let cell:ProfileCell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! ProfileCell
            
            cell.lblUsername.text    = UserDefaults.standard.string(forKey: "username")
            cell.lblEmail.text       = UserDefaults.standard.string(forKey: "email")
            
            cell.selectionStyle = .none
            
            return cell
            
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
            
            cell.selectionStyle = .none
            
            return cell
        }

        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.section
        {
        case 0:
            print("@@ index 0")
        case 3:
            showAlert()
        default:
            print("Some other character")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var height:CGFloat
        
        if indexPath.section == 0
        {
            height = 215
        }
        else
        {
            height = 44
        }
        
        return height;
    }
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Are you sure?", message: "Want to Logout",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
                                        self.logout()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func logout()
    {
        
        UserDefaults.standard.set(false, forKey: "IsLogin")
        UserDefaults.standard.set("", forKey: "Id")
        UserDefaults.standard.set(false, forKey: "IsLanding")
        
        UserDefaults.standard.set("", forKey: "username")
        UserDefaults.standard.set("", forKey: "email")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        self.present(nextViewController, animated: true, completion: nil)
        
        //self.dismiss(animated: true, completion: nil)
    }
    

}
