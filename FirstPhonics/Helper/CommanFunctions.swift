//
//  CommanFunctions.swift
//  Feedback360InSwift
//
//  Created by Apple on 24/04/18.
//  Copyright © 2018 FrugalNova. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import CoreData

class CommanFunctions
{
  
//    func getContext() -> NSManagedObjectContext
//    {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        return appDelegate.persistentContainer.viewContext
//    }
    
    
    func alert(msg : String) -> UIAlertController
    {
        let alertController = UIAlertController(title:StringConstants.APP_NAME,
                                                message:msg,
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: UIAlertAction.Style.default,
                                                handler: nil))
        
        return alertController
    }
    
    
    func isValidEmailAddress(email: String) -> Bool
    {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do
        {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            
            if results.count == 0
            {
                returnValue = false
            }
            
        }
        catch let error as NSError
        {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        
        return  returnValue
    }
    
    func checkEmtyValidation(text:String?) -> Bool
    {
        guard let text = text, !text.isEmpty else {
            return true
        }
        
        return false
    }
    
    func isConnectedToNetwork() -> Bool
    {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        
        zeroAddress.sin_len     = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family  = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress)
        {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false
        {
            return false
        }
        
        let isReachable     = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
        
    }
    
    func filePath() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path  = paths[0]
        let file  = (path as NSString).appendingPathComponent("Persistent.plist")
        
        return file
    }
    
    func saveData( dic : [String:Any])
    {
        let data = NSMutableData()
        
        //2
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(dic, forKey: "items")
        archiver.finishEncoding()
        data.write(toFile: filePath(), atomically: true)
    }
    
    func loadData() -> [String:Any]
    {
        var dic = [String:Any]()
        
        if FileManager.default.fileExists(atPath: filePath())
        {
            if let data = NSData(contentsOfFile: filePath())
            {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
                dic = unarchiver.decodeObject(forKey: "items") as! [String:Any]
                
                unarchiver.finishDecoding()
            }
        }
        
        return dic
    }
    
    func startProgressLoader(view : UIView)
    {
        let spinnerActivity = MBProgressHUD.showAdded(to: view, animated: true);
        
        spinnerActivity.label.text = "Loading";
        
        spinnerActivity.detailsLabel.text = "Please Wait!!";
        
        spinnerActivity.isUserInteractionEnabled = false;
        
    }
    
    func stopProgressLoader(view : UIView)
    {
        MBProgressHUD.hide(for: view, animated: true);
    }
    
    
}
