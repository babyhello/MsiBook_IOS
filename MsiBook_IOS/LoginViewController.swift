//
//  ViewController.swift
//  MsiBook
//
//  Created by 俞兆 on 2018/1/9.
//  Copyright © 2018年 俞兆. All rights reserved.
//

import UIKit
import Alamofire


class LoginViewController: UIViewController {
    
    //    akljdfksdjfkjdsklfjadskjflkdjslfkjdsklf
    
    
    var Account:String!
    var Password:String!
    
    @IBOutlet weak var txt_Account: UITextField!
    
    @IBOutlet weak var txt_Password: UITextField!
    
    @IBAction func btn_Login(_ sender: Any) {
        
        Account = txt_Account.text!
        
        Password = txt_Password.text!
        
        Authority(Account, outlookPassword: Password)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func Authority(_ outlookAccount:String,outlookPassword:String)
    {
        Alamofire.request(AppClass.ServerPath + "/IMS_App_Service.asmx/AuthenticateWTSC", parameters: ["OutlookID": outlookAccount,"OutlookPassword":outlookPassword])
            .responseJSON { response in
                
                if let value = response.result.value as? [String: AnyObject] {
                    
                    let ObjectString = value["Key"]! as? [[String: AnyObject]]
                    
                    let Jstring = String(describing: value["Key"]!)
                    
                    if Jstring  != "" {
                        
                        let MemberInfo = ObjectString!
                        
                        if MemberInfo.count > 0
                        {
                            var Work_ID = ""
                            
                            var _MemberName = ""
                            
                            if (MemberInfo[0]["WorkID"] as? String) != nil {
                                Work_ID = (MemberInfo[0]["WorkID"] as? String)!
                            }
                            
                            if (MemberInfo[0]["ChineseName"] as? String) != nil {
                                _MemberName = (MemberInfo[0]["ChineseName"] as? String)!
                            }
                            
                            if Work_ID != ""
                            {
                                //                                DB_Member.addMember(self.moc,WorkID:Work_ID, outlook_Account: outlookAccount, outlook_Password:outlookPassword, MemberName:_MemberName)
                                //
                                AppUser.WorkID = Work_ID
                                
                                self.performSegue(withIdentifier: "LoginToMainPage", sender: self)
                            }
                        }
                    }
                    else
                    {
                        //AppClass.Alert("Not Verify", SelfControl: self)
                    }
                }
                else
                {
                    //AppClass.Alert("Outlook ID or Password Not Verify !!", SelfControl: self)
                }
        }
    }
}


