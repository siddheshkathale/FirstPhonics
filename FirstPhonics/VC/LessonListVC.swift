//
//  LessonListVC.swift
//  FirstPhonics
//
//  Created by Apple on 23/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import UIKit
import AVKit

class LessonListVC: UIViewController {

    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var lessonTableView: UITableView!
    
    @IBOutlet weak var btnSong: UIButton!
    
    @IBOutlet weak var lblNoData: UILabel!
    
    @IBOutlet weak var lessonTableViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblScrollUp: UILabel!
    
    var CommanF = CommanFunctions()
    
    var vc: LandscapePlayer!
    var player: AVPlayer!
    
    var position = 0
    
    var lessonList = [LessonChapterModel] ()
    
    var songUrl = ""
    
    var audioPlayer: AVAudioPlayer?
    
    // MARK: Lifecycle
  
    @IBAction func songAction(_ sender: Any) {
        
        print("@@ songAction")
        
        if(!songUrl.isEmpty){
            playVideo(link: songUrl)
        }
        else {
            
            self.present(self.CommanF.alert(msg: StringConstants.video_empty_link_message),
                         animated: true,
                         completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        songUrl = ""
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.doneButtonClick),
            name: Notification.Name("closePlayer"),
            object: nil)

        
        if(position == 1)
        {
            btnSong.isHidden = false
            
            getSong()
            
            lessonTableViewTopConstraint.constant = 100.0
        }
        else{
            
            lessonTableViewTopConstraint.constant = 60.0
            
            btnSong.isHidden = true
            
        }
        
        if(position == 2 || position == 4){
            lblScrollUp.isHidden = true
            lessonTableViewTopConstraint.constant = 20.0
        }
        else{
            lblScrollUp.isHidden = false
        }
        
        btnSong.backgroundColor = UIColor.yellow
        btnSong.tintColor = UIColor.blue
        
        btnBack.action = #selector(buttonClicked(sender:))
        
        
        getLesson()
        
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
            print("@@ Lesson playUsingAVAudioPlayer audioPlayer play error:: ",error)
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
                //audioPlayer = nil
            }
            
        } catch {
            print("@@ Lesson viewWillDisappear audioPlayer stop error:: ",error)
            
        }
    }
    
    @objc func buttonClicked(sender: UIBarButtonItem) {
    
        self.dismiss(animated: true, completion: nil)
    }
   
    @objc func doneButtonClick(sender:NSNotification?){
        
        print("@@ doneButtonClick")
        
        if(player != nil){
            self.vc.player?.pause()
        }

        
    }
    
    func getDeviceId() -> String{
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print(uuid)
            
            return uuid
        }
    
        return ""
    }
    
    // MARK: Web Service
    
    func getSong() {
        
        if !CommanF.isConnectedToNetwork()
        {
            self.present(self.CommanF.alert(msg: StringConstants.NO_INTERNET),
                         animated: true,
                         completion: nil)
            return
        }
        
        //SVProgressHUD.show()
        
        CommanF.startProgressLoader(view: self.view)
        
        let _url = "\(Constants.GetAlphaletSongs_URL)"
        
        print("@@ getSong _url:: \(_url)")
        
        let url = URL(string: _url)!
        
        
        do {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            //request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            URLSession.shared.dataTask(with: request)
            { data, response, error in
                
                DispatchQueue.main.async {
                    self.CommanF.stopProgressLoader(view: self.view)
                }
                
                if let error = error
                {
                    print("@@ getSong Error: \(error.localizedDescription)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else
                {
                    
                    print("@@ getSong Error: invalid HTTP response code")
                    return
                }
                
                guard let data = data else
                {
                    print("@@ getSong Error: missing data")
                    return
                }
                
                print("@@ getSong Success")
                
                // feel free to uncomment this for debugging data
                //print("@@ getSong Result:: \(String(data: data, encoding: .utf8)!)")
                
                do {
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(GetAlphaletSongsResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            
                            if(model != nil) {
                                
                                self.songUrl = model.medianame!
                            }
                            else {
                                self.present(self.CommanF.alert(msg: StringConstants.error_message),
                                             animated: true,
                                             completion: nil)
                            }
                        }
                    }
                    catch {
                        print("@@ getLesson Error Exception : \(error.localizedDescription)")
                    }
                    
                    
                }
                catch {
                    print("@@ getSong Error Exception : \(error.localizedDescription)")
                }
                
                }.resume()
            
        }
        catch{
            print("@@ getSong json Error Exception : \(error.localizedDescription)")
        }
        
        
    }
    
    func getLesson() {
        
        if !CommanF.isConnectedToNetwork() {
            self.present(self.CommanF.alert(msg: StringConstants.NO_INTERNET),
                         animated: true,
                         completion: nil)
            return
        }
        
        //SVProgressHUD.show()
        
        CommanF.startProgressLoader(view: self.view)
        
        let _url = "\(Constants.GetLesson_URL)"
        
        print("@@ _url:: \(_url)")
        
        let url = URL(string: _url)!
        
        var getLessonRequest = GetLessonRequest()
        
        getLessonRequest.tutorial_id    = "\(position)"
        getLessonRequest.user_Id        = UserDefaults.standard.string(forKey: "Id") ?? ""
        getLessonRequest.Device_Id      =  getDeviceId()
        
        
        let jsonData = try! JSONEncoder().encode(getLessonRequest)
        
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
                    print("@@ getLesson Error: \(error.localizedDescription)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("@@ getLesson Error: invalid HTTP response code")
                    return
                }
                
                guard let data = data else {
                    print("@@ getLesson Error: missing data")
                    return
                }
                
                print("@@ getLesson Success")
                
                // feel free to uncomment this for debugging data
                //print("@@ getLesson Result:: \(String(data: data, encoding: .utf8)!)")
                
                do {
                    
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(GetLessonResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        if(model  != nil) {
                            
                            if(model.chapterlist  != nil) {
                                
                                //print("@@ getLesson model.chapterlist?.count:: \(model.chapterlist?.count)")
                                
                                let listSize = model.chapterlist?.count
                                
                                if(listSize! > 0)
                                {
                                    //self.lessonTableView.isHidden = false
                                    
                                    self.lblNoData.isHidden = true
                                    
                                    let lst:[Chapterlist]? = model.chapterlist
                                    
                                    self.prepareLessons(chapterlist: lst,paidFlag: model.paid ?? false,deviceIdFlag: model.flag ?? 0)
                                }
                                else
                                {
                                    //self.lessonTableView.isHidden = true
                                    self.lblNoData.isHidden = false
                                }
                                
                            }
                            else {
                                
                                //self.lessonTableView.isHidden = true
                                self.lblNoData.isHidden = false
                                self.showWarningMessageForDuplicateDevice()
                            }
                            
                        }
                        else {
                            
                            
                            self.present(self.CommanF.alert(msg: StringConstants.error_message),
                                         animated: true,
                                         completion:  { () in
                                            self.dismiss(animated: true, completion: nil)
                                            
                            })
                        }
                        
                
                    }
                }
                catch {
                    print("@@ getLesson Error Exception : \(error.localizedDescription)")
                }
                
                }.resume()
            
        }
        catch{
            print("@@ getLesson json Error Exception : \(error.localizedDescription)")
        }
    }
    
    func prepareLessons(chapterlist : [Chapterlist]?, paidFlag:Bool,deviceIdFlag:Int) {
        
        var i = 0
        
        //var list:[Chapterlist] = (chapterlist ?? nil)!
        
        for chapter in chapterlist! {
            
            if(position == 1 || position == 2) {
                
                var model = LessonChapterModel()
                
                model.lessonName    = chapter.chapter_name
                model.Week          = chapter.week
                model.lessonURL     = chapter.medianame
                model.message_label = ""
                model.paid          = paidFlag
                model.deviceIdFlag  = deviceIdFlag
                
                lessonList.append(model)
                
            }
            else{
                
                if((i%3 == 0) && (i != 0)){
                    
                    var msg = ""
                    
                    if(position == 3){
                        
                        switch i{
                            
                            case 3: msg = "Day 7 Revision of above 3"
                            
                            case 6: msg = "Day 14 Revision of above 3"
                            
                            case 9: msg = "Day 21 Revision of above 3"
                            
                            case 12: msg = "Day 26 Revision of above 3"
                            
                        default:
                            ""
                        }
                        
                    }
                    else if(position == 4){
                        
                        switch i{
                            
                        case 3: msg = "Day 4 Revision of above 3"
                            
                        case 6: msg = "Day 8 Revision of above 3"
                            
                            
                        default:
                            ""
                        }
                        
                    }
                    else{
                        
                        switch i{
                            
                        case 3: msg = "Day 4 Revision of above 3"
                            
                        case 6: msg = "Day 8 Revision of above 3"
                            
                        case 9: msg = "Day 12 Revision of above 3"
                            
                        case 12: msg = "Day 15 Revision of above 2"
                            
                        default:
                            ""
                        }
                        
                    }
                    
                    var model1 = LessonChapterModel()
                    
                    model1.lessonName    = ""
                    model1.Week          = ""
                    model1.lessonURL     = ""
                    model1.message_label = msg
                    model1.paid          = paidFlag
                    model1.deviceIdFlag  = deviceIdFlag
                    
                    lessonList.append(model1)
                    
                    var model2 = LessonChapterModel()
                    
                    model2.lessonName    = chapter.chapter_name
                    model2.Week          = chapter.week
                    model2.lessonURL     = chapter.medianame
                    model2.message_label = ""
                    model2.paid          = paidFlag
                    model2.deviceIdFlag  = deviceIdFlag
                    
                    lessonList.append(model2)
                    
                }
                else {
                    
                    var model = LessonChapterModel()
                    
                    model.lessonName    = chapter.chapter_name
                    model.Week          = chapter.week
                    model.lessonURL     = chapter.medianame
                    model.message_label = ""
                    model.paid          = paidFlag
                    model.deviceIdFlag  = deviceIdFlag
                    
                    lessonList.append(model)
                    
                    if(chapterlist!.count == i+1){
                        
                        var msg = ""
                        
                        if(position == 3){
                            
                            var model1 = LessonChapterModel()
                            
                            model1.lessonName    = ""
                            model1.Week          = ""
                            model1.lessonURL     = ""
                            model1.message_label = "Day 26 Revision of above 3"
                            model1.paid          = paidFlag
                            model1.deviceIdFlag  = deviceIdFlag
                            
                            lessonList.append(model1)
                            
                            var model2 = LessonChapterModel()
                            
                            model2.lessonName    = ""
                            model2.Week          = ""
                            model2.lessonURL     = ""
                            model2.message_label = "Day 27 Revision of above 6"
                            model2.paid          = paidFlag
                            model2.deviceIdFlag  = deviceIdFlag
                            
                            lessonList.append(model2)
                            
                            msg = "Day 28 Revision of above 6"
                            
                        }
                        else if(position == 4){
                            msg = "Day 8 Revision of above 3"
                        }
                        else if(position == 5){
                            msg = "Day 15 Revision of above 2"
                        }
                        
                        var model2 = LessonChapterModel()
                        
                        model2.lessonName    = ""
                        model2.Week          = ""
                        model2.lessonURL     = ""
                        model2.message_label = msg
                        model2.paid          = paidFlag
                        model2.deviceIdFlag  = deviceIdFlag
                        
                        lessonList.append(model2)
                        
                    }
                    
                }
                
            }
            
            i = i+1
        }
        
        print("@@ lessonList count:: \(lessonList.count)")
        
        lessonTableView.reloadData()
        
        //tableView.reloadData()
    }
    
    
    }

extension LessonListVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var type : Int
        
        let msg:String = lessonList[indexPath.row].message_label ?? ""
        
        if(!msg.isEmpty)
        {
            type = 3
        }
        else{
            
            if((indexPath.row + 1) % 2 != 0){
                type = 0
            }
            else{
                type = 2
            }
            
        }
        
        switch type {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LeftLessonCell", for: indexPath) as? LeftLessonCell
            {
                cell.btnLink.tag = indexPath.row
                
                
               
                
                cell.btnLink.backgroundColor = UIColor.yellow
                cell.btnLink.tintColor = UIColor.blue
                cell.lblDescription.textColor = UIColor.white
                
                cell.btnLink.addTarget(self, action: #selector(self.btnLinkClicked), for: UIControl.Event.touchUpInside)
                
                cell.selectionStyle = .none
                
                cell.lblDescription.text = lessonList[indexPath.row].Week
                cell.btnLink.setTitle(lessonList[indexPath.row].lessonName, for: .normal)
                
                
                return cell
            }
            
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RightLessonCell", for: indexPath) as? RightLessonCell
            {
                cell.btnLink.tag = indexPath.row
                
                cell.btnLink.backgroundColor = UIColor.blue
                cell.btnLink.tintColor = UIColor.yellow
                cell.lblDescription.textColor = UIColor.white
                
                cell.btnLink.addTarget(self, action: #selector(self.btnLinkClicked), for: UIControl.Event.touchUpInside)
                
                cell.selectionStyle = .none
                
                cell.lblDescription.text = lessonList[indexPath.row].Week
                cell.btnLink.setTitle(lessonList[indexPath.row].lessonName, for: .normal)
                
                return cell
            }
            
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageLessonCell", for: indexPath) as? MessageLessonCell
            {
                cell.lblMessage.tag = indexPath.row
                
            
                cell.lblMessage.textColor = UIColor.white
                cell.selectionStyle = .none
                
                cell.lblMessage.text = lessonList[indexPath.row].message_label
                
                return cell
            }
        
        default:
            ""
        }
  
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if(position == 3){
//
//            return 80.0
//        }
        
        return 70.0
    }
    
    @objc func btnLinkClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        
        //print("@@ lessonURL:: \(buttonRow)")
        
        //playVideo(link: lessonList[buttonRow].lessonURL!)
        
        if(lessonList[buttonRow].deviceIdFlag == 0){
            
            if(buttonRow == 0){
                playVideo(link: lessonList[buttonRow].lessonURL!)
            }
            else if (lessonList[buttonRow].paid!){
                playVideo(link: lessonList[buttonRow].lessonURL!)
            }
            else{
                setPopUp()
            }
            
        }
        else{
            showWarningMessageForDuplicateDevice()
        }
    }
    
    func playVideo(link:String){
        
        print("@@ playVideo")
        
        let url = NSURL(string: link)!
        
        player = AVPlayer(url: url as URL)
        vc = LandscapePlayer()
        vc.player = player
        
        
        present(vc, animated: true) {
            self.vc.player?.play()
        }
        
    }
    
    func setPopUp(){
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//

        
        //self.present(nextViewController, animated: true, completion: nil)
        
        let login = UserDefaults.standard.bool(forKey: "IsLogin")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if(login){
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentPopUpVC") as! PaymentPopUpVC
    
            self.addChild(nextViewController)
    
            nextViewController.view.frame = self.view.frame
            self.view.addSubview(nextViewController.view)
            nextViewController.didMove(toParent: self)
            
        }
        else{
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LandingVC") as! LandingVC
            
            self.present(nextViewController, animated: true, completion: nil)
            
        }
        
        
        
        
        
    }
    
    func showWarningMessageForDuplicateDevice() {
        
        let alert = UIAlertController(title: "Alert", message: StringConstants.duplicate_user_error_message,         preferredStyle: UIAlertController.Style.alert)
        
//        alert.addAction(UIAlertAction(title: "Cancel",
//                                      style: UIAlertAction.Style.default,
//                                      handler: { _ in
//                                                //Cancel Action
//                                                }))
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        
                                        self.logout()
                                        
                                        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func logout()
    {

        //print("@@ logout")
        
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
