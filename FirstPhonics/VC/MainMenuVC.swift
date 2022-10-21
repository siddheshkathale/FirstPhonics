//
//  MainMenuVC.swift
//  FirstPhonics
//
//  Created by Apple on 19/04/19.
//  Copyright © 2019 FrugalNova. All rights reserved.
//

import AVKit
import UIKit
import AVFoundation
import MediaPlayer

class MainMenuVC: UIViewController {

    @IBOutlet weak var btnIntro: UIButton!
    
    @IBOutlet weak var toggleMenu: UIBarButtonItem!
    
    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet weak var imageView5: UIImageView!
    
    var CommanF = CommanFunctions()
    
    //var moviePlayer:MPMoviePlayerController!
    
    //var moviePlayer: MPMoviePlayerController?
    
    var movieViewController : MPMoviePlayerViewController?
    var movieplayer : MPMoviePlayerController!
    
    var vc: LandscapePlayer!
    var player: AVPlayer!
    
    @IBAction func btnIntrocuction(_ sender: Any) {
        
        print("@@ btnIntrocuction")
        
        let url = NSURL(string: "http://report.frugalnova.co.uk/Video/book.mp4")!
        //movieViewController = MPMoviePlayerViewController(contentURL: url as URL)
        
        player = AVPlayer(url: url as URL)
        vc = LandscapePlayer()
        vc.player = player
        
        present(vc, animated: true) {
            self.vc.player?.play()
        }
    }
    
    @objc func doneButtonClick(sender:NSNotification?){
    
        print("@@ doneButtonClick")
        
        if(player != nil){
         self.vc.player?.pause()
        }
        
    }
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.doneButtonClick),
            name: Notification.Name("closePlayer"),
            object: nil)
        

        if revealViewController() != nil
        {
            toggleMenu.target = revealViewController()
            toggleMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        btnIntro.backgroundColor = UIColor.yellow
        btnIntro.tintColor = UIColor.red
        
        drawCircle(imageView: imageView1)
        
        drawCircle(imageView: imageView2)
        
        drawCircle(imageView: imageView3)
        
        drawCircle(imageView: imageView4)
        
        drawCircle(imageView: imageView5)
        
        
        setImageViewClickable(imageView: imageView1,position: 1)
        
        setImageViewClickable(imageView: imageView2,position: 2)
        
        setImageViewClickable(imageView: imageView3,position: 3)
        
        setImageViewClickable(imageView: imageView4,position: 4)
        
        setImageViewClickable(imageView: imageView5,position: 5)
        
        getAlphbetSongService()
        
        //addNavBarImage()
        
    }
    
    func addNavBarImage() {
        
        let navController = navigationController!
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        //let logoImage = UIImage.init(named: "logo")
        let image = #imageLiteral(resourceName: "logo")
        let logoImageView = UIImageView.init(image: image)
        
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        
        logoImageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight) //CGRectMake(-40, 0, 150, 25)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        //negativeSpacer.width = 25
        
        navigationItem.rightBarButtonItems = [negativeSpacer, imageItem]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
        let login = UserDefaults.standard.bool(forKey: "IsLogin")
        
        if(login){
            toggleMenu?.isEnabled = true
        }
        else{
            self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 185/255, green: 59/255 , blue: 62/255, alpha: 1)
            
            toggleMenu?.isEnabled = false
        }
        
        
        
        getAudioFile()
        
    }
    
    func playUsingAVAudioPlayer(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("@@ Menu playUsingAVAudioPlayer audioPlayer play error:: ",error)
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
            print("@@ Menu viewWillDisappear audioPlayer stop error:: ",error)
            
        }
    }
    
    func drawCircle(imageView:UIImageView) {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 280, height: 250))
            
            let img = renderer.image { ctx in
                let rect = CGRect(x: 5, y: 5, width: 270, height: 240)
                
                ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
                ctx.cgContext.addEllipse(in: rect)
                ctx.cgContext.drawPath(using: .fill)
            }
            
            imageView.image = img
            
        } else {
            // Fallback on earlier versions
            
            let drawSize = CGSize(width: 280, height: 250)
            UIGraphicsBeginImageContext(drawSize)
            
            let rect = CGRect(x: 5, y: 5, width: 270, height: 240)
            
            let ctx = UIGraphicsGetCurrentContext()!
            ctx.setFillColor(UIColor.yellow.cgColor)
            ctx.addEllipse(in: rect)
            ctx.drawPath(using: .fill)
            
            //ctx.fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))
            
            let img = UIGraphicsGetImageFromCurrentImageContext()
            
            imageView.image = img
        }
        
        
    }

    func setImageViewClickable(imageView:UIImageView,position:Int)  {
        
        imageView.tag = position
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))
        imageView.isUserInteractionEnabled = true
    }

    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        let image = gesture.view as? UIImageView
        
        if (image != nil) {
           
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LessonListVC") as! LessonListVC
            
            //print("@@ image?.tag:: \(String(describing: image?.tag))")
            nextViewController.position = image?.tag ?? 0
            //print("@@ nextViewController.position:: \(nextViewController.position)")
            
            self.present(nextViewController, animated: true, completion: nil)
            
        }
    }
    
    func getAlphbetSongService(){
        
        if !CommanF.isConnectedToNetwork()
        {
            self.present(self.CommanF.alert(msg: StringConstants.NO_INTERNET),
                         animated: true,
                         completion: nil)
            return
        }
        
        //SVProgressHUD.show()
        
        CommanF.startProgressLoader(view: self.view)

        let _url = Constants.GetAlphaletSongs_URL
        
        print("@@ getAlphbetSongService _url:: \(_url)")
        
        let url = URL(string: _url)!
        
        
        URLSession.shared.dataTask(with: url)
        { data, response, error in
            
            
            DispatchQueue.main.async {
                
                //SVProgressHUD.dismiss()
                self.CommanF.stopProgressLoader(view: self.view)
            }
            
            if let error = error
            {
                print("@@ getAlphbetSongService Error: \(error.localizedDescription)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else
            {
                
                print("@@ getAlphbetSongService Error: invalid HTTP response code")
                return
            }
            
            guard let data = data else
            {
                print("@@ getAlphbetSongService Error: missing data")
                return
            }
            
            print("@@ getAlphbetSongService Success")
            
            // feel free to uncomment this for debugging data
            //print("@@ Result:: \(String(data: data, encoding: .utf8)!)")
            
            do
            {
                let decoder = JSONDecoder()
                let song_Model = try decoder.decode(GetAlphaletSongsResponse.self, from: data)
                
                DispatchQueue.main.async { // Correct
                    
                    if(song_Model.message == "Success"){
                        print("@@ medianame:: \(song_Model.medianame)")
                    }
                }
                
            }
            catch
            {
                print("@@ getAlphbetSongService Error Exception : \(error.localizedDescription)")
            }
            
            }.resume()
        
        
    }
    
}


