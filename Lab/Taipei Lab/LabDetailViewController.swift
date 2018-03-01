//
//  Lab-tabbarViewController.swift
//  週報
//
//  Created by Ｍatthew on 2018/2/12.
//  Copyright © 2018年 Ｍatthew. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import XLPagerTabStrip

class LabDetailViewController: ButtonBarPagerTabStripViewController {
    
    //建立Button,以navigation方式返回上一頁
    @IBAction func BtnBack_Action(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    let graySpotifyColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    let darkGraySpotifyColor = UIColor(red: 149/255.0, green: 148/255.0, blue: 148/255.0, alpha: 1.0)
    
    var ViewControlls:[UIViewController] = []
    
    var FtypeNo:String?
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = self.storyboard?.instantiateViewController(withIdentifier: "machinedetail") as! EqipmentDetailViewController
        
        let child_2 = self.storyboard?.instantiateViewController(withIdentifier: "machinedetail") as! EqipmentDetailViewController
        
        let child_3 = self.storyboard?.instantiateViewController(withIdentifier: "machinedetail") as! EqipmentDetailViewController
        
        let child_4 = self.storyboard?.instantiateViewController(withIdentifier: "machinedetail") as! EqipmentDetailViewController
        
        
        child_1.itemInfo = IndicatorInfo(title: "基本")
        child_1.TypeNo = FtypeNo
        
        
        child_2.itemInfo = IndicatorInfo(title: "保養")
        
        child_3.itemInfo = IndicatorInfo(title: "維修")
        
        child_4.itemInfo = IndicatorInfo(title: "儀校")
        
        
        
        ViewControlls =  [child_1,child_2,child_3,child_4]
        
        return ViewControlls
    }
    
    //加入from...toindex，讓換頁時能抓到
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
        if ViewControlls[toIndex] as? Machine_ViewController != nil  {
            
            let Machine_ViewController = ViewControlls[toIndex] as! Machine_ViewController
            
            Machine_ViewController.Find_Fac_List(Type: String(toIndex))
            
            
            
        }
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //XLPagerTabStrip套件
        settings.style.buttonBarBackgroundColor = graySpotifyColor
        settings.style.buttonBarItemBackgroundColor = graySpotifyColor
        settings.style.selectedBarBackgroundColor = UIColor(red: 82/255.0, green: 125/255.0, blue: 163/255.0, alpha: 1.0)
        settings.style.buttonBarItemFont = UIFont(name: "System-Bold", size:18) ?? UIFont.systemFont(ofSize: 18)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(red: 149/255.0, green: 148/255.0, blue: 148/255.0, alpha: 1.0)
            newCell?.label.textColor = UIColor(red: 82/255.0, green: 125/255.0, blue: 163/255.0, alpha: 1.0)
        }
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


