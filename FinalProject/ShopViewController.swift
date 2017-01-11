//
//  ShopViewController.swift
//  FinalProject
//
//  Created by 江鈺云 on 2016/12/22.
//  Copyright © 2016年 江鈺云. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UIScrollViewDelegate {
    
    //界面设计元素引用
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!

    
    //需要显示的页面内容
    var courses = [
        ["name":"獨棟平房","pic":"data/house-1-01.png"],
        ["name":"鄉間木屋","pic":"data/house-2-01.png"],
        ["name":"歐式別墅","pic":"data/house-3-01.png"],
        ["name":"城市公寓","pic":"data/house-4-01.png"],
    ]
    //let fileChoose = "data/houseTypeChosen.txt"
    //let fileChoose: String = Bundle.main.path(forResource: "data/houseTypeChoosen", ofType: "txt")!
    //let fileChoose = "houseTypeChosen.txt"
    @IBAction func chooseButton(_ sender: UIButton) {
        // Create the alert controller
        let message: String =  courses[self.pageControl.currentPage]["name"]!
        let alertController = UIAlertController(title: "你選擇了", message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            do {
                try message.write(toFile: Bundle.main.path(forResource: "houseTypeChosen", ofType: "txt", inDirectory: "data")!, atomically: true, encoding: String.Encoding.utf8)
            } catch {
               print("HouseType not save correctly")
            }

            
            self.navigationController?.popToRootViewController(animated: true)
            NSLog("OK Pressed")
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(Bundle.main.path(forResource: "houseTypeChosen", ofType: "txt", inDirectory: "data")! )
        //设置scrollView的内容总尺寸
        scrollView.contentSize = CGSize(
            width: CGFloat(self.view.bounds.width) * CGFloat(self.courses.count),
            height: self.view.bounds.height
        )
        //关闭滚动条显示
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        //协议代理，在本类中处理滚动事件
        scrollView.delegate = self
        //滚动时只能停留到某一页
        scrollView.isPagingEnabled = true
        //添加页面到滚动面板里
        let size = scrollView.bounds.size
        for (seq,course) in courses.enumerated() {
            let page = UIView()
            let imageView=UIImageView(image:UIImage(named:course["pic"]!))
            imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: scrollView.bounds.height)
            page.addSubview(imageView);
            page.frame = CGRect(x: CGFloat(seq) * size.width, y: 0,
                                width: size.width, height: size.height)
            scrollView.addSubview(page)
        }
        
        //页控件属性
        pageControl.backgroundColor = UIColor.clear
        pageControl.numberOfPages = courses.count
        pageControl.currentPage = 0
        //设置页控件点击事件
        pageControl.addTarget(self, action: #selector(pageChanged(_:)),
                              for: UIControlEvents.valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UIScrollViewDelegate方法，每次滚动结束后调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //通过scrollView内容的偏移计算当前显示的是第几页
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //设置pageController的当前页
        pageControl.currentPage = page
    }
    
    //点击页控件时事件处理
    func pageChanged(_ sender:UIPageControl) {
        //根据点击的页数，计算scrollView需要显示的偏移量
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        //展现当前页面内容
        scrollView.scrollRectToVisible(frame, animated:true)
    }
    
    
}
