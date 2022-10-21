//
//  RegistrationVC.swift
//  FirstPhonics
//
//  Created by Apple on 17/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {

    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var countryCodeTF: UITextField!
    
    @IBOutlet weak var mobileNoTF: UITextField!
    
    @IBOutlet weak var customerNameTF: UITextField!
    
    @IBOutlet weak var childNameTF: UITextField!
    
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var stateTF: UITextField!
    
    @IBOutlet weak var countryTF: UITextField!
    
  
    
    @IBAction func signupAction(_ sender: Any) {
    
        if(checkValidation()){
            registerService()
        }
        
    }
    
    var CommanF = CommanFunctions()
    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnBack.action = #selector(buttonClicked(sender:))
     
        setPlaceHolderColor(textField: usernameTF, label: "Username")
        setPlaceHolderColor(textField: emailTF, label: "Email")
        setPlaceHolderColor(textField: passwordTF, label: "Password")
        setPlaceHolderColor(textField: mobileNoTF, label: "Mobile No")
        setPlaceHolderColor(textField: customerNameTF, label: "Customer Name")
        
        
        setPlaceHolderColor(textField: childNameTF, label: "Child Name")
        setPlaceHolderColor(textField: addressTF, label: "Address")
        setPlaceHolderColor(textField: cityTF, label: "City")
        setPlaceHolderColor(textField: stateTF, label: "State")
        setPlaceHolderColor(textField: countryTF, label: "Country")
        
    }
    
    @objc func buttonClicked(sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkValidation() -> Bool {
        
        if CommanF.checkEmtyValidation(text: usernameTF.text!){
            showAlert(msg:"Enter Username")
            return false
        }
        
        if CommanF.checkEmtyValidation(text: emailTF.text!){
            showAlert(msg:"Enter Email")
            return false
        }
        
        if CommanF.checkEmtyValidation(text: passwordTF.text!){
            showAlert(msg:"Enter Password")
            return false
        }
        
        if CommanF.checkEmtyValidation(text: mobileNoTF.text!){
            showAlert(msg:"Enter Mobile No")
            return false
        }
        
        if CommanF.checkEmtyValidation(text: customerNameTF.text!){
            showAlert(msg:"Enter Customer Name")
            return false
        }
        
        if CommanF.checkEmtyValidation(text: childNameTF.text!){
            showAlert(msg:"Enter Child Name")
            return false
        }
        
        if CommanF.checkEmtyValidation(text: addressTF.text!){
            showAlert(msg:"Enter Address")
            return false
        }
        
        if CommanF.checkEmtyValidation(text: cityTF.text!){
            showAlert(msg:"Enter City")
            return false
        }
        
        if CommanF.checkEmtyValidation(text: stateTF.text!){
            showAlert(msg:"Enter State")
            return false
        }
        
        if CommanF.checkEmtyValidation(text: countryTF.text!){
            showAlert(msg:"Enter Country")
            return false
        }
        
        return true
    }
    
    func showAlert(msg:String){
        
        self.present(self.CommanF.alert(msg: msg),
                     animated: true,
                     completion: nil)
        
    }
    
    func registerService() {
        
        if !CommanF.isConnectedToNetwork() {
            showAlert(msg: StringConstants.NO_INTERNET)
            return
        }
        
        //SVProgressHUD.show()
        
        CommanF.startProgressLoader(view: self.view)
        
        let _url = "\(Constants.Registration_URL)"
        
        print("@@ _url:: \(_url)")
        
        let url = URL(string: _url)!
        
        var user = PostRegistrationRequest()
        
        user.username   = usernameTF.text
        user.password   = passwordTF.text
        user.email      = emailTF.text
        
        user.Country_Code = countryCodeTF.text
        user.Mobile_No = mobileNoTF.text
        user.Name = customerNameTF.text
        user.Child_Name = childNameTF.text
        user.Address = addressTF.text
        
        user.City = cityTF.text
        user.State = stateTF.text
        user.Country = countryTF.text
        
        
        let jsonData = try! JSONEncoder().encode(user)
        
        do {
            
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
                    print("@@ registerService Error: \(error.localizedDescription)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("@@ registerService Error: invalid HTTP response code")
                    return
                }
                
                guard let data = data else {
                    print("@@ registerService Error: missing data")
                    return
                }
                
                print("@@ registerService Success")
                
                // feel free to uncomment this for debugging data
                print("@@ registerService Result:: \(String(data: data, encoding: .utf8)!)")
                
                do
                {
                    let decoder = JSONDecoder()
                    let Common_Model = try decoder.decode(CommanResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        if(Common_Model.message == "Success"){
                            
                            UserDefaults.standard.set(false, forKey: "IsLanding")
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                            
                            self.present(nextViewController, animated: true, completion: nil)
                            
                        }
                        else {
                            self.showAlert(msg: Common_Model.message!)
                        }
                        
                    }
                    
                }
                catch
                {
                    print("@@ registerService Error Exception : \(error.localizedDescription)")
                }
                
                }.resume()
            
        }
        catch{
            print("@@ registerService json Error Exception : \(error.localizedDescription)")
        }
        
    }
    
    func setPlaceHolderColor(textField:UITextField,label:String) {
        textField.attributedPlaceholder = NSAttributedString(string: label,
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
    }
    
}

