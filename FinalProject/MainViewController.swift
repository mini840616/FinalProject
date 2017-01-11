//
//  MainViewController.swift
//  FinalProject
//
//  Created by 江鈺云 on 2016/12/22.
//  Copyright © 2016年 江鈺云. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    

    var currentTime = 60
    var timer = Timer()
    var courses = [
        ["name":"獨棟平房","pic":"data/house-1-02.png"],
        ["name":"鄉間木屋","pic":"data/house-2-02.png"],
        ["name":"歐式別墅","pic":"data/house-3-02.png"],
        ["name":"城市公寓","pic":"data/house-4-02.png"],
    ]
    var message = "獨棟平房"
    let houseTypefilePath = Bundle.main.bundlePath+"/data/houseTypeChosen.txt"

    
    @IBOutlet weak var myCityButton: UIButton!
    
    @IBOutlet weak var myShopButton: UIButton!
    
    @IBOutlet weak var mySettingButton: UIButton!
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var TimerSliderOutlet: UISlider!
    
    @IBAction func TimerSlider(_ sender: UISlider) {
        currentTime = Int(sender.value)
        TimerLabel.text = "\(currentTime)"
    }
    
    @IBOutlet weak var StartOutlet: UIButton!
    
    
    
    @IBAction func StartButton(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MainViewController.counter), userInfo: nil, repeats: true)

        TimerSliderOutlet.setValue(Float(Double(currentTime)), animated: true)

        if StartOutlet.titleLabel?.text == "開始" && currentTime > 0 {
            StartOutlet.setTitle("放棄", for: UIControlState.normal)
            enabler(enable: false)
            myImageView.loadGif(name: "data/worker-gif")
            
        } else {
            StartOutlet.setTitle("開始", for: UIControlState.normal)
            timer.invalidate()
            TimerLabel.text = "\(currentTime)"
            enabler(enable: true)
            myLoadImage()
            
        }
        
 
    }

    @IBAction  func unwindFromShop(segue: UIStoryboardSegue ) {
        
        myLoadImage()
        
    }
    
    
    
    
    func counter() {

        if (currentTime < 1){
            timer.invalidate()
            enabler(enable: true)
            self.writedata()
            StartOutlet.setTitle("開始", for: UIControlState.normal)
            myLoadImage()

        } else if StartOutlet.titleLabel?.text == "開始" {
            timer.invalidate()
            enabler(enable: true)
            myLoadImage()
        } else {
            currentTime -= 1
            TimerLabel.text = "\(currentTime)"
            TimerSliderOutlet.setValue(Float(Double(currentTime)), animated: true)
        }
        
        
    }
    
    func writedata () {
        let message = try! String.init(contentsOfFile: houseTypefilePath)
        
        let alertController = UIAlertController(title: "恭喜你獲得了", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            // reading myCity.json file  for the current status
            let jsonString = try! String.init(contentsOfFile: Bundle.main.path(forResource: "myCity", ofType: "json", inDirectory: "data")!)
            let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false)
            let json = JSON(data: dataFromString!)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            
            //create a json1 with one record
            
            let json1String = "[{\"name\": \""+message+"\", \"datetime\": \""+formatter.string(from: Date())+"\"}]"
            
            
            let data1FromString = json1String.data(using: .utf8, allowLossyConversion: false)
            let json1 = JSON(data: data1FromString!)
            
            //merge json and json1
            let jsonMerge = try! json.merged(with: json1)
            
            //write json back to myCity.json
            do {
                try jsonMerge.rawString()?.write(toFile: Bundle.main.path(forResource: "myCity", ofType: "json", inDirectory: "data")!, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("json not save correctly")
            }

            
            //NSLog("data saved")
        }
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func myLoadImage () {
        message = try! String.init(contentsOfFile: houseTypefilePath)
        for sindex in 0..<courses.count {
            if courses[sindex]["name"] == message
            {
                myImageView.image = UIImage(named:courses[sindex]["pic"]!)
                break
            }
        }
        
    }
    
//    func enabler(enable: Bool) {
//        if enable {
//            TimerSliderOutlet.isEnabled = true
//            myCityButton.isEnabled = true
//            myShopButton.isEnabled = true
//            mySettingButton.isEnabled = true
//        }else {
//            TimerSliderOutlet.isEnabled = false
//            myCityButton.isEnabled = false
//            myShopButton.isEnabled = false
//            mySettingButton.isEnabled = false
//        }
//        
//        
//    }
    
    
    func enabler(enable: Bool) {
        if enable {
            self.TimerSliderOutlet.isEnabled = true
            self.myCityButton.isHidden = false
            self.myShopButton.isHidden = false
            //self.mySettingButton.isHidden = false
        }else {
            TimerSliderOutlet.isEnabled = false
            myCityButton.isHidden = true
            myShopButton.isHidden = true
            //mySettingButton.isHidden = true
        }
        
        
    }
    
    
    func didEnterBackground() {
        print("background")
        if StartOutlet.titleLabel?.text == "放棄" {
            StartOutlet.setTitle("開始", for: UIControlState.normal)
            timer.invalidate()
            TimerLabel.text = "\(currentTime)"
            enabler(enable: true)
            myLoadImage()
            
            let alertController = UIAlertController(title: "放棄", message: "看來你放棄了，再加油吧！", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "houseTypeChosen", ofType: "txt", inDirectory: "data")
        if path == nil {
          do {
                try message.write(toFile: houseTypefilePath, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("HouseType not save correctly")
            }
        }
        //else {print("houseType file exist")}
        
        myLoadImage()
        
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: "didEnterBackground", name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
