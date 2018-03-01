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


class MachineViewCell:UITableViewCell
{
    @IBOutlet var photo: UIImageView!
    
    @IBOutlet var reserveBG: UIView!
    
    @IBOutlet var reserve: UILabel!
    
    @IBOutlet var position: UILabel!
    
    @IBOutlet var personnel: UILabel!
    
    @IBOutlet var serialNo: UILabel!
    
    @IBOutlet var barrowdate: UILabel!
    
    @IBOutlet var machinename: UILabel!
    
    @IBOutlet var Reseve: UIButton!
}


class Machine
{
    
    var AssetNo:String?
    var Location:String?
    var Owner:String?
    var HourCost:String?
    var Equipment:String?
    var Dept:String?
    var IMG:String?
    var SeqNo:String?
    var Status:String?
    var Using:String?
    
}

class Machine_ViewController: UIViewController,IndicatorInfoProvider,UITableViewDelegate,UITableViewDataSource {
    
    var activityIndicator:UIActivityIndicatorView!
    
    @IBOutlet var table: UITableView!
    
    
    var MachineList = [Machine]()
    
    //XLPagerTabStrip套件
    var itemInfo: IndicatorInfo = "機構配備"
    
    var equip:String?
    
    var PartNo:String?
    
    func play(){
        //进度条开始转动
        activityIndicator.startAnimating()
    }
    
    func stop(){
        //进度条停止转动
        activityIndicator.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MachineList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PartNo = MachineList[indexPath.row].SeqNo
        print(PartNo)
        performSegue(withIdentifier: "Page1", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MachineViewCell", for: indexPath) as! MachineViewCell
        
        
        
        if MachineList.count >= indexPath.row && MachineList != nil {
            
            cell.machinename.text = MachineList[indexPath.row].Equipment
            cell.serialNo.text = MachineList[indexPath.row].AssetNo
            cell.position.text = MachineList[indexPath.row].Location
            cell.personnel.text = MachineList[indexPath.row].Owner
            cell.photo.layer.cornerRadius = cell.photo.frame.size.width/2
            cell.photo.clipsToBounds = true
            cell.layer.borderColor = UIColor(hexString: "#e2e2e2").cgColor
            cell.layer.borderWidth = 6
            //buttom帶資料進下一頁
            cell.Reseve.tag = indexPath.row
            cell.Reseve.addTarget(self, action:#selector(action(_:)), for: .touchDown)
            //            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
        }
        
        
        
        WebImgGet(MachineList[indexPath.row].IMG!,ImageView: cell.photo)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
        
        //Find_Fac_List(Type: "1")
        
        table.dataSource = self
        table.delegate = self
        
    }
    
    @objc func action(_ sender:UIButton!) {
        
        var index = sender.tag
        
        equip = MachineList[index].Equipment
        PartNo = MachineList[index].AssetNo
        
        
        
        
        performSegue(withIdentifier: "Page2", sender: self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "Page1"
        {
            let ViewController = segue.destination as! LabDetailViewController
            
            ViewController.FtypeNo = PartNo
            
            
            
            
        }
        if segue.identifier == "Page2"
        {
            let ViewController = segue.destination as! ReservationViewController
            
            ViewController.Equipment = equip
            ViewController.SeialNo = PartNo
            
            
            
            
            
        }
        
        
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
    
    
    
    public func Find_Fac_List(Type:String)
    {
        
        
        //環形進度條開始讀取
        self.view.addSubview(activityIndicator)
        
        play()
        
        MachineList = [Machine]()
        
        Alamofire.request(AppClass.LabPath() + "Find_Fac_List?Type="+Type)
            .responseJSON { response in
                
                
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    
                    
                    
                    if Jstring  != "" {
                        
                        
                        
                        for NotificationInfo in (ObjectString )! {
                            
                            let _Machine = Machine()
                            
                            
                            if (NotificationInfo["F_AssetNo"] as? String) != nil {
                                
                                
                                _Machine.AssetNo = NotificationInfo["F_AssetNo"] as? String
                                
                            }
                            
                            if (NotificationInfo["F_Location"] as? String) != nil {
                                
                                
                                _Machine.Location = NotificationInfo["F_Location"] as? String
                            }
                            
                            if (NotificationInfo["F_Owner"] as? String) != nil {
                                
                                
                                _Machine.Owner = NotificationInfo["F_Owner"] as? String
                                
                                
                            }
                            
                            
                            if (NotificationInfo["F_Facility"] as? String) != nil {
                                
                                
                                _Machine.Equipment = NotificationInfo["F_Facility"] as? String
                                
                                
                            }
                            
                            
                            if (NotificationInfo["IMG"] as? String) != nil {
                                
                                
                                _Machine.IMG = NotificationInfo["IMG"] as? String
                                
                                
                            }
                            
                            if (NotificationInfo["F_SeqNo"] as? Int) != nil {
                                
                                
                                _Machine.SeqNo = String(String(describing: (NotificationInfo["F_SeqNo"] as! Int)))
                                
                                
                            }
                            
                            if (NotificationInfo["Using"] as? Int) != nil {
                                
                                
                                _Machine.Using = String(String(describing: (NotificationInfo["Using"] as! Int)))
                                
                                
                            }
                            
                            if (NotificationInfo["F_Status"] as? Int) != nil {
                                
                                
                                _Machine.Status = String(String(describing: (NotificationInfo["F_Status"] as! Int)))
                                
                                
                            }
                            
                            //                        if _Equipment.Status == 0{
                            //
                            //
                            
                            
                            
                            
                            
                            self.MachineList.append(_Machine)
                            
                            
                        }
                        
                        
                        //將資料庫內容lo進tableview
                        self.table.reloadData()
                        
                        
                    }
                    
                    
                    
                }
                
                //環形進度條停止讀取
                self.stop()
        }
    }
}


