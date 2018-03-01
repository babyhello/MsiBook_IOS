//
//  MainPageViewController.swift
//  MsiBook
//
//  Created by 俞兆 on 2018/2/2.
//  Copyright © 2018年 俞兆. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    
    @IBAction func Btn_Go_IMS(_ sender: Any) {
        
        self.performSegue(withIdentifier: "GoIssueList", sender: self)
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

