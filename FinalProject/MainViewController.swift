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
            TimerSliderOutlet.isEnabled = false
            myImageView.loadGif(name: "data/worker-gif")
            
        } else {
            StartOutlet.setTitle("開始", for: UIControlState.normal)
            timer.invalidate()
            TimerLabel.text = "\(currentTime)"
            TimerSliderOutlet.isEnabled = true
            myImageView.image = UIImage(named: "data/worker-gif.gif")
            
        }
        
 
    }
    
    
    func counter() {

        if (currentTime <= 0){
            timer.invalidate()
            TimerSliderOutlet.isEnabled = true
            self.writedata()
            StartOutlet.setTitle("開始", for: UIControlState.normal)
            myImageView.image = UIImage(named: "data/worker-gif.gif")

        } else if StartOutlet.titleLabel?.text == "開始" {
            timer.invalidate()
            TimerSliderOutlet.isEnabled = true
        } else {
            currentTime -= 1
            TimerLabel.text = "\(currentTime)"
            TimerSliderOutlet.setValue(Float(Double(currentTime)), animated: true)
        }
        
        
    }
    
    func writedata () {
        
        let message = try! String.init(contentsOfFile: Bundle.main.path(forResource: "houseTypeChosen", ofType: "txt", inDirectory: "data")!)
        
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

            
            NSLog("data saved")
        }
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try "獨棟平房".write(toFile: Bundle.main.path(forResource: "houseTypeChosen", ofType: "txt", inDirectory: "data")!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("HouseType not save correctly")
        }

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
