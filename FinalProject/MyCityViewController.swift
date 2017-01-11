//
//  MyCityViewController.swift
//  FinalProject
//
//  Created by 江鈺云 on 2016/12/22.
//  Copyright © 2016年 江鈺云. All rights reserved.
//

import UIKit
//import SwiftyJSON

class MyCityViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    var courses = [
        ["name":"獨棟平房","pic":"data/house-1-02.png"],
        ["name":"鄉間木屋","pic":"data/house-2-02.png"],
        ["name":"歐式別墅","pic":"data/house-3-02.png"],
        ["name":"城市公寓","pic":"data/house-4-02.png"],
        ]
    var myCityData = [[String: Date]]()
    var myFilterCityData = [[String: Date]]()
    var formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        //let formatter = DateFormatter()
        self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

        let dataPath = Bundle.main.path(forResource: "data/myCity", ofType: "json")!
       
        let jsonString = try! String.init(contentsOfFile: dataPath)
        //print(jsonString)
        let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false)
        let json = JSON(data: dataFromString!)
        
        for (_,subJson):(String, JSON) in json {
            let oneRecordData: [String: Date] = [subJson["name"].stringValue: self.formatter.date(from: subJson["datetime"].stringValue)! ]
            
            self.myCityData.append(oneRecordData)
            
        }
        //print(myCityData)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //返回记录数
        self.formatter.dateFormat = "yyyy-MM-dd"
        self.myFilterCityData = self.myCityData.filter({ (oneRecordData: [String : Date]) -> Bool in
            self.formatter.string(from: self.myDatePicker.date)  == self.formatter.string(from: oneRecordData.values.first!)
        })
        return self.myFilterCityData.count
    }
      //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //返回Cell内容，这里我们使用刚刚建立的Cell作为显示内容
        let cell: MyCell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! MyCell

        //cell.backgroundColor = UIColor(red: 37/255, green: 160/255, blue: 193/255, alpha: 1)
        cell.myImageView.image = nil
        self.formatter.dateFormat = "yyyy-MM-dd"
        for sindex in 0..<courses.count {
            if courses[sindex]["name"] == self.myFilterCityData[indexPath.row].keys.first
            {
                cell.myImageView.image = UIImage(named:courses[sindex]["pic"]!)
                break
            }
        }
        return cell as UICollectionViewCell
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //某个Cell被选择的事件处理
    }
    
    
    
    @IBOutlet weak var myDatePicker: UIDatePicker!

    @IBAction func myDatePickerAction(_ sender: Any) {
        self.myCollectionView.reloadData()
        
    }
    
//    @IBOutlet weak var myMap: MKMapView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
