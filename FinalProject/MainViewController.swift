//
//  MainViewController.swift
//  FinalProject
//
//  Created by 江鈺云 on 2016/12/22.
//  Copyright © 2016年 江鈺云. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var timer = Timer()
    var count = 0
    
    func updateTime() {
        count -= 1
        TimeLabel.text = "\(count)"
    }

//
//    @IBAction func TimeSlider(_ sender: UISlider) {
//        
//        var initialValue = Int(sender.value)
//        
//        TimeLabel.text = "\(initialValue)"
//    }
    
    @IBOutlet weak var TimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
