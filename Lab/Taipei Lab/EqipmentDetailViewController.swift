//
//  Machine ViewController.swift
//  週報
//
//  Created by Ｍatthew on 2018/2/12.
//  Copyright © 2018年 Ｍatthew. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import XLPagerTabStrip





class EqipmentDetailViewController: UIViewController,IndicatorInfoProvider {
    
    
    @IBOutlet weak var Standard: UITextView!
    
    @IBOutlet weak var FSPEC: UITextView!
    
    @IBOutlet var Photo: UIImageView!
    
    @IBOutlet var type: UILabel!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var partno: UILabel!
    
    @IBOutlet var equipno: UILabel!
    
    @IBOutlet var position: UILabel!
    
    @IBOutlet var keeping: UILabel!
    
    @IBOutlet var personal: UILabel!
    
    @IBOutlet weak var buycost: UILabel!
    
    @IBOutlet weak var buydate: UILabel!
    
    @IBOutlet weak var storagedate: UILabel!
    
    @IBOutlet weak var DepreciationYear: UILabel!
    
    @IBOutlet weak var FactoryOwner: UILabel!
    
    var activityIndicator:UIActivityIndicatorView!
    
    var TypeNo:String?
    
    
    
    //XLPagerTabStrip套件
    var itemInfo: IndicatorInfo = "機構配備"
    
    func play(){
        //进度条开始转动
        activityIndicator.startAnimating()
    }
    
    func stop(){
        //进度条停止转动
        activityIndicator.stopAnimating()
    }
    
    
    
    //XLPagerTabStrip套件
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //將讀取條改變顏色，大小，形狀
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center=self.view.center
        activityIndicator.backgroundColor = UIColor(hexString: "#585858")
        activityIndicator.clipsToBounds = true
        activityIndicator.layer.cornerRadius = 1
        
        Find_Fac_Detail(F_SeqNo: TypeNo!)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //從網路上抓圖片
    func WebImgGet(_ Path:String,ImageView:UIImageView)
    {
        
        
        let url = URL(string: ("http://wtsc.msi.com.tw/IMS/IMS_App_Service.asmx/Get_File?FileName=" + Path).addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)!
        
        let placeholderImage = UIImage(named: "msi_default_image")
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: ImageView.frame.size,
            radius: 0
        )
        
        ImageView.af_setImage(
            withURL: url,
            //placeholderImage: placeholderImage,
            filter: filter
        )
    }
    
    
    
    
    
    
    func Find_Fac_Detail(F_SeqNo:String)
    {
        //環形進度條開始讀取
        self.view.addSubview(activityIndicator)
        
        play()
        
        
        Alamofire.request(AppClass.LabPath() + "Find_Fac_Detail?F_SeqNo="+F_SeqNo)
            .responseJSON { response in
                
                
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    
                    var FType:String?
                    var Facility:String?
                    var AssetNo:String?
                    var Model:String?
                    var Location:String?
                    var Dept:String?
                    var Owner:String?
                    var IMG:String?
                    var SPEC:String?
                    var FCOST:String?
                    var BUYDATE:String?
                    var StorageDate:String?
                    var USEYEAR:String?
                    var Factory:String?
                    var FStandard:String?
                    
                    
                    
                    
                    
                    if Jstring  != "" {
                        
                        
                        
                        for NotificationInfo in (ObjectString )! {
                            
                            
                            
                            if (NotificationInfo["F_AssetNo"] as? String) != nil {
                                
                                
                                AssetNo = NotificationInfo["F_AssetNo"] as? String
                                
                            }
                            
                            if (NotificationInfo["F_Location"] as? String) != nil {
                                
                                
                                Location = NotificationInfo["F_Location"] as? String
                            }
                            
                            if (NotificationInfo["F_Owner"] as? String) != nil {
                                
                                
                                Owner = NotificationInfo["F_Owner"] as? String
                                
                                
                            }
                            
                            
                            if (NotificationInfo["F_Facility"] as? String) != nil {
                                
                                
                                Facility = NotificationInfo["F_Facility"] as? String
                                
                                
                            }
                            
                            if (NotificationInfo["F_Dept"] as? String) != nil {
                                
                                
                                Dept = NotificationInfo["F_Dept"] as? String
                                
                                
                            }
                            
                            if (NotificationInfo["F_Model"] as? String) != nil {
                                
                                
                                Model = NotificationInfo["F_Model"] as? String
                                
                                
                            }
                            
                            if (NotificationInfo["F_Type"] as? String) != nil {
                                
                                
                                FType = NotificationInfo["F_Type"] as? String
                                
                                
                            }
                            
                            if (NotificationInfo["IMG"] as? String) != nil {
                                
                                
                                IMG  = NotificationInfo["IMG"] as? String
                                
                                self.WebImgGet(IMG!, ImageView: self.Photo)
                                
                                
                            }
                            
                            
                            if (NotificationInfo["F_Spec"] as? String) != nil {
                                
                                
                                SPEC = NotificationInfo["F_Spec"] as? String
                            }
                            
                            if (NotificationInfo["F_Cost"] as? Int) != nil {
                                
                                
                                FCOST = String(String(describing: (NotificationInfo["F_Cost"] as! Int)))
                            }
                            
                            let format = NumberFormatter()
                            format.numberStyle = .decimal
                            let Cost = format.string(from: Int(FCOST!) as! NSNumber)
                            
                            
                            if (NotificationInfo["F_Buy_Date"] as? String) != nil {
                                
                                
                                BUYDATE = NotificationInfo["F_Buy_Date"] as? String
                            }
                            
                            var str = BUYDATE!
                            //將指定字數刪減
                            let index = str.index(str.startIndex, offsetBy: 10)
                            
                            let mySubstring = str[..<index]
                            BUYDATE! = String(mySubstring)
                            
                            if (NotificationInfo["F_Storage_Date"] as? String) != nil {
                                
                                
                                StorageDate = NotificationInfo["F_Storage_Date"] as? String
                            }
                            
                            var str2 = StorageDate!
                            //將指定字數刪減
                            let index2 = str2.index(str2.startIndex, offsetBy: 10)
                            
                            let mySubstring2 = str[..<index]
                            StorageDate! = String(mySubstring2)
                            
                            if (NotificationInfo["F_Use_Year"] as? Int) != nil {
                                
                                
                                USEYEAR = String(String(describing: (NotificationInfo["F_Use_Year"] as! Int)))
                            }
                            
                            
                            if (NotificationInfo["F_Factory"] as? String) != nil {
                                
                                
                                Factory = NotificationInfo["F_Factory"] as? String
                            }
                            
                            if (NotificationInfo["F_Standard"] as? String) != nil {
                                
                                
                                FStandard = NotificationInfo["F_Standard"] as? String
                            }
                            
                            self.type.text = FType
                            
                            self.name.text = Facility
                            
                            self.partno.text = AssetNo
                            
                            self.equipno.text = Model
                            
                            self.position.text = Location
                            
                            self.keeping.text = Dept
                            
                            self.personal.text = Owner
                            
                            self.FSPEC.text = SPEC
                            
                            self.buycost.text = Cost! + " " + "NTD"
                            
                            self.buydate.text = BUYDATE
                            
                            self.storagedate.text = StorageDate
                            
                            self.DepreciationYear.text = USEYEAR! + " " + "年"
                            
                            self.FactoryOwner.text = Factory
                            
                            self.Standard.text = FStandard
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                //環形進度條停止讀取
                self.stop()
        }
    }
    
    
}


