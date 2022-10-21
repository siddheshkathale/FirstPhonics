//
//  ForgetPasswordVC.swift
//  FirstPhonics
//
//  Created by Apple on 19/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBAction func btnSend(_ sender: Any) {
        
        if(checkValidation()){
            sendPasswordService()
        }
        
    }
    
    var CommanF = CommanFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.action = #selector(buttonClicked(sender:))
        
        setPlaceHolderColor(textField: usernameTF, label: "Username")
        
    }
    
    @objc func buttonClicked(sender: UIBarButtonItem) {
        print("@@ buttonClicked ForgetPasswordVC")
        self.dismiss(animated: true, completion: nil)
    }

    func checkValidation() -> Bool{
        
        if CommanF.checkEmtyValidation(text: usernameTF.text!)
        {
            self.present(self.CommanF.alert(msg: "Username is empty"),
                         animated: true,
                         completion: nil)
            
            return false
        }
    
        return true
    }
    
    func sendPasswordService(){
        
        if !CommanF.isConnectedToNetwork()
        {
            self.present(self.CommanF.alert(msg: StringConstants.NO_INTERNET),
                         animated: true,
                         completion: nil)
            return
        }
        
        //SVProgressHUD.show()
        
        CommanF.startProgressLoader(view: self.view)
        
        let _url = "\(Constants.ForgetPassword_URL)"
        
        print("@@ _url:: \(_url)")
        
        let url = URL(string: _url)!
        
        let id = UserDefaults.standard.string(forKey: "Id")
        
        var user = ForgetPasswordRequest()
        user.username = usernameTF.text
        
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
                    print("@@ sendPasswordService Error: \(error.localizedDescription)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else
                {
                    
                    print("@@ sendPasswordService Error: invalid HTTP response code")
                    return
                }
                
                guard let data = data else
                {
                    print("@@ sendPasswordService Error: missing data")
                    return
                }
                
                print("@@ sendPasswordService Success")
                
                // feel free to uncomment this for debugging data
                print("@@ loginService Result:: \(String(data: data, encoding: .utf8)!)")
                
                do
                {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(CommanResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        if(model.message == "Success"){
                            
                            self.reset()
                            
                            self.present(self.CommanF.alert(msg: StringConstants.mail_sucess),
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
                    print("@@ sendPasswordService Error Exception : \(error.localizedDescription)")
                }
                
                }.resume()
            
        }
        catch{
            print("@@ sendPasswordService json Error Exception : \(error.localizedDescription)")
        }
        
    }
    
    func reset(){
        usernameTF.text = ""
    }
    
    func setPlaceHolderColor(textField:UITextField,label:String) {
       
        textField.attributedPlaceholder = NSAttributedString(string: label,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        
    }
    
}
