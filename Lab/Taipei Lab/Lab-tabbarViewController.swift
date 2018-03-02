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

class Lab_tabbarViewController: ButtonBarPagerTabStripViewController {
    
    
    //建立Button,以navigation方式返回上一頁
    @IBAction func BtnBack_Action(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBOutlet weak var region: UILabel!
    
    let graySpotifyColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    let darkGraySpotifyColor = UIColor(red: 149/255.0, green: 148/255.0, blue: 148/255.0, alpha: 1.0)
    
    var ViewControlls:[UIViewController] = []
    
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = self.storyboard?.instantiateViewController(withIdentifier: "machine") as! Machine_ViewController
        
        let child_2 = self.storyboard?.instantiateViewController(withIdentifier: "machine") as! Machine_ViewController
        
        let child_3 = self.storyboard?.instantiateViewController(withIdentifier: "machine") as! Machine_ViewController
        
        let child_4 = self.storyboard?.instantiateViewController(withIdentifier: "machine") as! Machine_ViewController
        
        let child_5 = self.storyboard?.instantiateViewController(withIdentifier: "machine") as! Machine_ViewController
        
        let child_6 = self.storyboard?.instantiateViewController(withIdentifier: "machine") as! Machine_ViewController
        
        let child_7 = self.storyboard?.instantiateViewController(withIdentifier: "machine") as! Machine_ViewController
        
        child_1.itemInfo = IndicatorInfo(title: "機構配備")
        
        child_2.itemInfo = IndicatorInfo(title: "環測配備")
        
        child_3.itemInfo = IndicatorInfo(title: "熱流配備")
        
        child_4.itemInfo = IndicatorInfo(title: "無響室配備")
        
        child_5.itemInfo = IndicatorInfo(title: "電子配備")
        
        child_6.itemInfo = IndicatorInfo(title: "音像配備")
        
        child_7.itemInfo = IndicatorInfo(title: "掃地機配備")
        
        ViewControlls =  [child_1,child_2,child_3,child_4,child_5,child_6,child_7]
        
        return ViewControlls
    }
    
    //加入from...toindex，讓換頁時能抓到
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        
        if ViewControlls.count >= toIndex  {
            
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
    
    @IBAction func toolbar(_ sender: Any) {
        
        let Alert = UIAlertController(title:"請選擇區域", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let TaipeiAlert = UIAlertAction(title:"台北", style: .default){
            (action:UIAlertAction) in
            
            self.region.text = "台北"
            self.dismiss(animated: true, completion: nil)
            
            
        }
        Alert.addAction(TaipeiAlert)
        
        let kuenshanAlert = UIAlertAction(title:"昆山", style: .default){
            (action:UIAlertAction) in
            
            self.region.text = "昆山"
            self.dismiss(animated: true, completion: nil)
            
            
        }
        Alert.addAction(kuenshanAlert)
        
        let BoanAlert = UIAlertAction(title:"寶安", style: .default){
            (action:UIAlertAction) in
            
            self.region.text = "寶安"
            self.dismiss(animated: true, completion: nil)
            
            
        }
        Alert.addAction(BoanAlert)
        
//      hkhjjhkj  gfghfghfghfgh
        
        self.present(Alert, animated: true, completion: nil)
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

