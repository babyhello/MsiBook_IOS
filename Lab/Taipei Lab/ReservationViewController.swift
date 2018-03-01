//
//  CalendarViewController.swift
//  CalendarDemo
//
//  Created by Matthew on 2017/1/18.
//  Copyright © 2017年 LinJian. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Foundation

public protocol ReservationViewControllerDelegate: NSObjectProtocol {
    func calendarDidSelect(index: IndexPath, date: DateComponents)
}

var contact:String?

class ReservationViewController: UIViewController {
    
    //MARK: - Property
    
    var Equipment:String?
    
    var SeialNo:String?
    
    @IBOutlet var reservedetail: UIView!
    
    @IBOutlet weak var currentDateTextField: UILabel!
    
    @IBOutlet var Equip: UILabel!
    
    @IBOutlet var SN: UILabel!
    
    @IBOutlet internal weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var nextbutton: UIButton!
    
    @IBOutlet weak var privebutton: UIButton!
    
    
    //建立Button,以navigation方式返回上一頁
    @IBAction func BtnBack_Action(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    class overtime
    {
        var overtimehour:String?
        var date:String?
        
    }
    
    
    class monthhour
    {
        var date:String?
        var hour:String?
    }
    
    var year:String?
    var month:String?
    var overtimedetail = [overtime]()
    
    
    
    var activityIndicator:UIActivityIndicatorView!
    
    
    func play(){
        //进度条开始转动
        activityIndicator.startAnimating()
        nextbutton.isHidden = true
        privebutton.isHidden = true
    }
    
    func stop(){
        //进度条停止转动
        activityIndicator.stopAnimating()
        privebutton.isHidden = false
        
    }
    
    
    
    
    
    
    //    @IBAction func declare(_ sender: Any) {
    //
    //        let Alert = UIAlertController(title: "送簽中", message: "\n若有任何問題請洽窗口\n" + contact! , preferredStyle: UIAlertControllerStyle.alert)
    //
    //            Alert.addAction(UIAlertAction(title: "關閉", style: .default, handler: { (action: UIAlertAction!) in
    //        }))
    
    //
    //        self.present(Alert, animated: true, completion: nil)
    //    }
    //往左右滑的手勢
    internal let leftSwipeGesture = UISwipeGestureRecognizer()
    internal let rightSwipeGesture = UISwipeGestureRecognizer()
    
    
    internal let dateArray = ["SU","MO","TU","WE","TH","FR","SA"]
    internal var date = Date(){
        didSet{
            self.collectionView.reloadData()
        }
    }
    internal var ArrayselectedIndexPath = [String]()
    internal var ArrayselectedComponents = [String]()
    
    internal var selectedIndexPath: IndexPath?
    internal var selectedComponents: DateComponents = DateComponents(){
        didSet{
            //            self.dailyTextView.text = UserDefaults.standard.value(forKey: selectedComponents.description) as! String!
            //            self.dateLabel.text = "\(selectedComponents.year!)年\(selectedComponents.month!)月\(selectedComponents.day!)日"
        }
    }
    
    weak var delegate: ReservationViewControllerDelegate?
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reservedetail.layer.cornerRadius = 2
        
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.gray)
        activityIndicator.center=self.view.center
        //lo出當天日期
        //    selectedComponents = dateInfo(date: date)
        
        //        currentDateTextField.addTarget(self, action: #selector(textFieldDidChanged), for: UIControlEvents.editingDidEnd)
        //        dailyTextView.text = UserDefaults.standard.value(forKey:dateInfo(date: date).description) as! String!
        configCurrentDateTitle()
        //        configGestures()
        
        Find_Window_Data(WorkID:AppUser.WorkID!)
        Find_OverTime_List_Month(WorkID: AppUser.WorkID!, Year: year!, Week: month!)
        checkmonth(CurrentDate: date as NSDate)
        
        self.Equip.text = Equipment
        self.SN.text = SeialNo
        
        
        
        
    }
    //手機搖晃即可回到當月
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == motion{
            
            date = Date()
            
            configCurrentDateTitle()
            //        configGestures()
            Find_Window_Data(WorkID:AppUser.WorkID!)
            Find_OverTime_List_Month(WorkID: AppUser.WorkID!, Year: year!, Week: month!)
            checkmonth(CurrentDate: date as NSDate)
            
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        //        self.dailyTextView.text = UserDefaults.standard.value(forKey: selectedComponents.description) as! String!
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - Private
    
    internal func dateInfo(date: Date) -> (DateComponents) {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        return components
    }
    
    internal func firstWeekDayThisMonth(date: Date) -> (Int) {
        var components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
        components.day = 1
        let firstDayOfMonthDate = Calendar.current.date(from: components)
        let firstWeekDay = Calendar.current.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: firstDayOfMonthDate!)
        return firstWeekDay!
    }
    
    internal func totalDaysThisMonth(date: Date) -> (Int) {
        let totalDaysThisMonth:Range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date)!
        return totalDaysThisMonth.count
    }
    
    
    //    internal func textFieldDidChanged(){
    //        self.date = currentDateTextField.selectedDate!
    //    }
    
    internal func configCurrentDateTitle() {
        
        let yearformatter = DateFormatter()
        yearformatter.dateFormat = "yyyy"
        let yearstring = yearformatter.string(from: date)
        
        let monthformatter = DateFormatter()
        monthformatter.dateFormat = "M"
        let monthstring = monthformatter.string(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy M"
        let dateString = dateFormatter.string(from: date)
        self.currentDateTextField.text = dateString
        year = yearstring
        month = monthstring
        
        
    }
    
    //將日期轉為月份
    func getMonth(today:NSDate) -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601)!
        let myComponents = myCalendar.components(.month, from: today as Date)
        let MonthNumber = myComponents.month
        return MonthNumber!
    }
    func getYear(today:NSDate) -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601)!
        let myComponents = myCalendar.components(.year, from: today as Date)
        let MonthNumber = myComponents.year
        return MonthNumber!
    }
    
    //    internal func configGestures() {
    //        leftSwipeGesture.direction = .left
    //        rightSwipeGesture.direction = .right
    //        leftSwipeGesture.addTarget(self, action: #selector(gestureDidSwiped))
    //        rightSwipeGesture.addTarget(self, action: #selector(gestureDidSwiped))
    //        self.view.addGestureRecognizer(leftSwipeGesture)
    //        self.view.addGestureRecognizer(rightSwipeGesture)
    //    }
    
    
    
    
    
    //MARK: - Events
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        var components = DateComponents()
        components.month = -1
        let newDate = Calendar.current.date(byAdding: components, to: date)
        date = newDate!
        configCurrentDateTitle()
        
        Find_OverTime_List_Month(WorkID: AppUser.WorkID!, Year: year!, Week: month!)
        checkmonth(CurrentDate: date as NSDate)
        
        
        
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        var components = DateComponents()
        components.month = 1
        let newDate = Calendar.current.date(byAdding: components, to: date)
        date = newDate!
        configCurrentDateTitle()
        Find_OverTime_List_Month(WorkID: AppUser.WorkID!, Year: year!, Week: month!)
        checkmonth(CurrentDate: date as NSDate)
        
        
        
    }
    
    
    func checkmonth(CurrentDate :NSDate)
    {
        
        let NowDate = Date()
        
        //如果上週小於等於當週，button隱藏，反之取消隱藏
        if((getMonth(today: CurrentDate as NSDate) >= getMonth(today: NowDate as NSDate)) && (getYear(today: CurrentDate as NSDate) >= getYear(today: NowDate as NSDate)))
        {
            nextbutton.isHidden = true
            
        }
        else
        {
            nextbutton.isHidden = false
            
        }
    }
    
    func checkyear(CurrentDate :NSDate)
    {
        
        let NewDate = Date()
        
        //如果上週小於等於當週，button隱藏，反之取消隱藏
        if(getYear(today: CurrentDate as NSDate) > getYear(today: NewDate as NSDate))
        {
            nextbutton.isHidden = true
            
        }
        else
        {
            nextbutton.isHidden = false
        }
    }
    
    
    
    //    //支援往左右滑顯示
    //    internal func gestureDidSwiped(sender: UISwipeGestureRecognizer) {
    //        if sender.direction == .left {
    //
    //            nextButtonPressed(sender)
    //        }else {
    //
    //            previousButtonPressed(sender)
    //        }
    //    }
    
    
    // MARK: - Notification
    /*
     internal func regNoti() {
     NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: .UIKeyboardWillChangeFrame, object: nil)
     }
     
     func keyboardWillChangeFrame(noti: Notification) {
     let infoDict = noti.userInfo
     let beginKeyboardRect = (infoDict?[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue
     let endKeyboardRect = (infoDict?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
     let yOffset = (endKeyboardRect?.origin.y)! - (beginKeyboardRect?.origin.y)!
     var inputFieldRect = self.view.frame
     inputFieldRect.origin.y += yOffset
     UIView.animate(withDuration: 0.5, animations: {
     self.view.frame = inputFieldRect
     })
     }
     */
    
    
    
    func Find_Window_Data(WorkID:String)
    {
        
        
        var OverTimePeopleData = ""
        
        
        Alamofire.request("http://wtsc.msi.com.tw/IMS/OverTime_App_Service.asmx/Find_Window_Data?WorkID=" + WorkID)
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    
                    if Jstring  != "" {
                        
                        for NotificationInfo in (ObjectString )! {
                            
                            
                            if (NotificationInfo["Account"] as? String) != nil {
                                
                                OverTimePeopleData =  String(describing: NotificationInfo["Account"] as! String)
                            }
                            
                            
                            contact = OverTimePeopleData
                            
                            
                            
                        }
                        
                        
                    }
                }//環形進度條停止讀取
                
        }
        
        
        
    }
    
    
    func Find_OverTime_List_Month(WorkID:String,Year:String,Week:String)
    {
        
        //環形進度條開始讀取
        //        view.addSubview(activityIndicator)
        //
        //        play()
        
        self.overtimedetail = [overtime]()
        
        Alamofire.request("http://wtsc.msi.com.tw/IMS/OverTime_App_Service.asmx/Find_OverTime_List_Month?WorkID=" + WorkID + "&Year=" + Year + "&Month=" + Week)
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    
                    if Jstring  != "" {
                        
                        for NotificationInfo in (ObjectString )! {
                            
                            let _overtime = overtime()
                            
                            
                            if (NotificationInfo["Date"] as? Int) != nil {
                                
                                _overtime.date =  String(describing: NotificationInfo["Date"] as! Int)
                            }
                            
                            if (NotificationInfo["F_TotalHour"] as? Double) != nil {
                                
                                _overtime.overtimehour =  String(describing: NotificationInfo["F_TotalHour"] as! Double)
                                
                            }
                            else
                            {
                                _overtime.overtimehour = ""
                            }
                            
                            self.overtimedetail.append(_overtime)
                            
                            
                            
                        }
                        self.collectionView.reloadData()
                        //                        self.table.reloadData()
                    }
                }//環形進度條停止讀取
                //                self.stop()
                
        }
        
        
        
    }
    
    
}


// MARK: - Extensions

extension ReservationViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 : 37
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentDateComponents = dateInfo(date: Date())
        var indexPathComponent = dateInfo(date: date)
        indexPathComponent.day = indexPath.item - firstWeekDayThisMonth(date: date) + 2
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayOfAWeekCell", for: indexPath) as! CalendarDateCell
            cell.dateLabel.text = dateArray[indexPath.item]
            cell.dateLabel.textColor = UIColor(hexString: "#1799DD")
            
            return cell
        } else {
            let cell = collectionView .dequeueReusableCell(withReuseIdentifier:"CalendarCell", for: indexPath) as! CalendarDateCell
            
            
            if indexPath.item < firstWeekDayThisMonth(date: date) - 1 {
                cell.dateLabel.text = " "
                
                cell.backgroundColor = UIColor(hexString: "#FFFFFF")
            }
                
            else if indexPath.item >= firstWeekDayThisMonth(date: date) - 1 && (indexPath.item - firstWeekDayThisMonth(date: date) + 2) <= totalDaysThisMonth(date: date) {
                //show出行事曆上日期
                cell.dateLabel.text = "\(indexPath.item - firstWeekDayThisMonth(date: date) + 2)"
                
                
                
                if currentDateComponents == indexPathComponent {
                    //                    if selectedIndexPath == nil {
                    //                     selectedIndexPath = indexPath
                    //                        cell.icon.isHidden = true
                    //                        cell.hour.isHidden = true
                    //
                    //                    }
                }else {
                    
                    
                    for overtime in overtimedetail {
                        
                        if(overtime.date == cell.dateLabel.text!)
                        {
                            
                            
                        }
                    }
                    
                    
                    
                    
                    cell.backgroundColor = UIColor.white
                }
            }else {
                cell.backgroundColor = UIColor(hexString: "#FFFFFF")
                
                cell.dateLabel.text = " "
                
            }
            
            
            return cell
        }
    }
}



extension ReservationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.item >= firstWeekDayThisMonth(date: date) - 1 && (indexPath.item - firstWeekDayThisMonth(date: date) + 2) <= totalDaysThisMonth(date: date) {
                var selectedComponent = dateInfo(date: date)
                selectedComponent.day = indexPath.item - firstWeekDayThisMonth(date: date) + 2
                let currentDateComponents = dateInfo(date: Date())
                if selectedIndexPath != nil {
                    currentDateComponents == self.selectedComponents ? (collectionView.cellForItem(at: selectedIndexPath!)?.backgroundColor = UIColor.white) : (collectionView.cellForItem(at: selectedIndexPath!)?.backgroundColor = UIColor(hexString: "#ffffff"))
                }
                self.selectedIndexPath = indexPath
                self.selectedComponents = selectedComponent
                collectionView.reloadData()
                collectionView.cellForItem(at: selectedIndexPath!)?.backgroundColor = UIColor(hexString: "#477eba")
            }
        }
    }
}

extension ReservationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeItem : CGFloat = CGFloat(collectionView.bounds.size.width - 32 - 12) / 7.0
        let size = CGSize(width: sizeItem, height: sizeItem)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsetsMake(0, 0, 10, 0)
        return insets
    }
}






