//
//  ChangePasswordVC.swift
//  FirstPhonics
//
//  Created by Apple on 20/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var oldPasswordTF: UITextField!
    
    @IBOutlet weak var newPasswordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    
    @IBAction func btnUpdate(_ sender: Any) {
        
        if(checkValidation()){
            updatePasswordService()
        }
        
    }
    
    var CommanF = CommanFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.action = #selector(buttonClicked(sender:))
        
        setPlaceHolderColor(textField: oldPasswordTF, label: "Old Password")
        setPlaceHolderColor(textField: newPasswordTF, label: "New Password")
        setPlaceHolderColor(textField: confirmPasswordTF, label: "Confirm Password")
        
    }
    
    @objc func buttonClicked(sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }

    
    func checkValidation() -> Bool
    {
        if CommanF.checkEmtyValidation(text: oldPasswordTF.text!)
        {
            self.present(self.CommanF.alert(msg: "Old Password is empty"),
                         animated: true,
                         completion: nil)
            
            return false
        }
        
        if CommanF.checkEmtyValidation(text: newPasswordTF.text!)
        {
            self.present(self.CommanF.alert(msg: "New Password is empty"),
                         animated: true,
                         completion: nil)
            
            return false
        }
        
        if CommanF.checkEmtyValidation(text: confirmPasswordTF.text!)
        {
            self.present(self.CommanF.alert(msg: "Confirm Password is empty"),
                         animated: true,
                         completion: nil)
            
            return false
        }
        
        if (confirmPasswordTF.text != newPasswordTF.text)
        {
            self.present(self.CommanF.alert(msg: "New password & confirm password is not available"),
                         animated: true,
                         completion: nil)
            
            return false
        }
        
        return true
    }
    
    func updatePasswordService()
    {
        if !CommanF.isConnectedToNetwork()
        {
            self.present(self.CommanF.alert(msg: StringConstants.NO_INTERNET),
                         animated: true,
                         completion: nil)
            return
        }
        
        //SVProgressHUD.show()
        
        CommanF.startProgressLoader(view: self.view)
        
        let _url = "\(Constants.ChangePassword_URL)"
        
        print("@@ _url:: \(_url)")
        
        let url = URL(string: _url)!
        
        let id = UserDefaults.standard.string(forKey: "Id")
        
        var user = ChangePasswordRequest()
        user.id       = id
        user.password = newPasswordTF.text
        
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
                    print("@@ updatePasswordService Error: \(error.localizedDescription)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else
                {
                    
                    print("@@ updatePasswordService Error: invalid HTTP response code")
                    return
                }
                
                guard let data = data else
                {
                    print("@@ updatePasswordService Error: missing data")
                    return
                }
                
                print("@@ updatePasswordService Success")
                
                // feel free to uncomment this for debugging data
                //print("@@ loginService Result:: \(String(data: data, encoding: .utf8)!)")
                
                do
                {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(CommanResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        if(model.message == "Success"){
                            
                            self.reset()
                            
                            self.present(self.CommanF.alert(msg: StringConstants.sucess_update),
                                         animated: true,
                                         completion: nil)
                            
                        }
                        else
                        {
                            self.present(self.CommanF.alert(msg: StringConstants.error_message),
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
    
    func reset(){
        oldPasswordTF.text = ""
        newPasswordTF.text = ""
        confirmPasswordTF.text = ""
    }

    func setPlaceHolderColor(textField:UITextField,label:String) {
        
        
        
        textField.attributedPlaceholder = NSAttributedString(string: label,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        
    }
}
