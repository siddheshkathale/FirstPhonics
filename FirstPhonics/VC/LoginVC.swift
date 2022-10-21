//
//  LoginVC.swift
//  FirstPhonics
//
//  Created by Apple on 18/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func LoginAction(_ sender: Any) {
        
        
        
        if(checkValidation()){
            loginService()
        }
        
    }
    
    var CommanF = CommanFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let urlString = "http://report.frugalnova.co.uk/Video/Alpha_song.mp4"

//        DispatchQueue.global(qos: .background).async {
//            if let url = URL(string: urlString),
//                let urlData = NSData(contentsOf: url) {
//                let documentsPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)[0];
//                let filePath="\(documentsPath)/tempFile1.mp4"
//
//                print("@@ filePath:: ",filePath)
//
//                DispatchQueue.main.async {
//                    //urlData.write(toFile: filePath, atomically: true)
//                    do {
//                        try urlData.write(toFile: filePath, options: .completeFileProtection)
//                    }
//                    catch {
//                        // Handle errors.
//                        print("@@ Video errors!")
//                    }
//                    print("@@ Video is saved!")
//                }
//            }
//        }
        
        
        btnBack.action = #selector(buttonClicked(sender:))
        
        let Landing = UserDefaults.standard.bool(forKey: "IsLanding")
        
        if(Landing){
            btnBack.isEnabled = true
        }
        else{
            btnBack.isEnabled = false
        }
        
        setPlaceHolderColor(textField: usernameTF, label: "Username")
        setPlaceHolderColor(textField: passwordTF, label: "Password")
        
        
        
        
        
        
        
        
    }
    
    @objc func buttonClicked(sender: UIBarButtonItem) {
        
        //print("@@ buttonClicked LoginVC")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func checkValidation() -> Bool {
        
        if CommanF.checkEmtyValidation(text: usernameTF.text!)
        {
            self.present(self.CommanF.alert(msg: "Enter Email Address"),
                         animated: true,
                         completion: nil)
            
            return false
        }
        
        if CommanF.checkEmtyValidation(text: passwordTF.text!)
        {
            self.present(self.CommanF.alert(msg: "Enter Password"),
                         animated: true,
                         completion: nil)
            
            return false
        }
        
        return true
    }
    
    func loginService() {
        
        if !CommanF.isConnectedToNetwork()
        {
            self.present(self.CommanF.alert(msg: StringConstants.NO_INTERNET),
                         animated: true,
                         completion: nil)
            return
        }
        
        //SVProgressHUD.show()
        
        CommanF.startProgressLoader(view: self.view)
        
        let _url = "\(Constants.Login_URL)"
        
        print("@@ _url:: \(_url)")
        
        let url = URL(string: _url)!
        
        var user = LoginRequest()
        user.username = usernameTF.text
        user.password = passwordTF.text
        
        let jsonData = try! JSONEncoder().encode(user)
        
        do{
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            URLSession.shared.dataTask(with: request)
            { data, response, error in
                
                DispatchQueue.main.async {
                    self.CommanF.stopProgressLoader(view: self.view)
                }
                
                if let error = error
                {
                    print("@@ loginService Error: \(error.localizedDescription)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else
                {
                    
                    print("@@ loginService Error: invalid HTTP response code")
                    return
                }
                
                guard let data = data else
                {
                    print("@@ loginService Error: missing data")
                    return
                }
                
                print("@@ loginService Success")
                
                // feel free to uncomment this for debugging data
                //print("@@ loginService Result:: \(String(data: data, encoding: .utf8)!)")
                
                do
                {
                    let decoder = JSONDecoder()
                    let login_Model = try decoder.decode(LoginResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        if(!login_Model.isError!){
                            
                            if(login_Model.flag == 1){
                                self.showAlert(userid1: login_Model.id!)
                            }
                            else{
                                
                                UserDefaults.standard.set(true, forKey: "IsLogin")
                                
                                UserDefaults.standard.set(login_Model.id, forKey: "Id")
                                UserDefaults.standard.set(login_Model.username, forKey: "username")
                                UserDefaults.standard.set(login_Model.email, forKey: "email")
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                                
                                self.present(nextViewController, animated: true, completion: nil)
                                
                            }
           
                        }
                        else
                        {
                            self.present(self.CommanF.alert(msg: StringConstants.Incorrect_Login),
                                         animated: true,
                                         completion: nil)
                        }
                        
                    }
                    
                }
                catch
                {
                    print("@@ loginService Error Exception : \(error.localizedDescription)")
                }
                
            }.resume()
            
        }
        catch{
            print("@@ loginService json Error Exception : \(error.localizedDescription)")
        }
        
    }

    func showAlert(userid1 : Int) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "Want to continue with this device? you Won't be able to use app on other devices!",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes! continue",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                       
                                        self.updateDevice(userid: userid1)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func updateDevice(userid : Int) {
        
        if !CommanF.isConnectedToNetwork() {
            self.present(self.CommanF.alert(msg: StringConstants.NO_INTERNET),
                         animated: true,
                         completion: nil)
            return
        }
        
        //SVProgressHUD.show()
        
        CommanF.startProgressLoader(view: self.view)
        
        let _url = "\(Constants.LoginFromOtherDevice_URL)"
        
        print("@@ _url:: \(_url)")
        
        let url = URL(string: _url)!
        
        var user        = LoginFromOtherDeviceRequest()
        user.id         = String(userid) 
        user.device_Id  = getDeviceId()
   
        
        let jsonData = try! JSONEncoder().encode(user)
        
        do{
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            URLSession.shared.dataTask(with: request)
            { data, response, error in
                
                DispatchQueue.main.async {
                    self.CommanF.stopProgressLoader(view: self.view)
                }
                
                if let error = error {
                    print("@@ updateDevice Error: \(error.localizedDescription)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("@@ updateDevice Error: invalid HTTP response code")
                    return
                }
                
                guard let data = data else {
                    print("@@ updateDevice Error: missing data")
                    return
                }
                
                print("@@ updateDevice Success")
                
                // feel free to uncomment this for debugging data
                //print("@@ updateDevice Result:: \(String(data: data, encoding: .utf8)!)")
                
                do
                {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(LoginFromOtherDeviceResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        if(!model.isError!){
                            
                            UserDefaults.standard.set(true, forKey: "IsLogin")
                            
                            UserDefaults.standard.set(model.id, forKey: "Id")
                            UserDefaults.standard.set(model.username, forKey: "username")
                            UserDefaults.standard.set(model.email, forKey: "email")
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                            
                            self.present(nextViewController, animated: true, completion: nil)
                            
                        }
                        else {
                            self.present(self.CommanF.alert(msg: StringConstants.error_message),
                                         animated: true,
                                         completion: nil)
                        }
                        
                    }
                }
                catch {
                    print("@@ updateDevice Error Exception : \(error.localizedDescription)")
                }
                
            }.resume()
            
        }
        catch {
            print("@@ updateDevice json Error Exception : \(error.localizedDescription)")
        }
        
    }
    
    func getDeviceId() -> String {
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return uuid
        }
        
        return ""
    }
    
    func setPlaceHolderColor(textField:UITextField,label:String) {
        
        textField.attributedPlaceholder = NSAttributedString(string: label,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        
    }
    
}
