//
//  NetWorkViewController.swift
//  IMS
//
//  Created by 俞兆 on 2017/7/18.
//  Copyright © 2017年 Mark. All rights reserved.
//

import UIKit

class NetWorkViewController: UIViewController {
    
    //123123213
    @IBOutlet weak var hostNameLabel: UILabel!
    
    @IBOutlet weak var networkStatus: UILabel!
    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start reachability without a hostname initially
        setupReachability(nil, useClosures: true)
        startNotifier()
        
        // After 5 seconds, stop and re-start reachability, this time using a hostname
        let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(5)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.stopNotifier()
            self.setupReachability("google.com", useClosures: true)
            self.startNotifier()
            
            let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(5)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                self.stopNotifier()
                self.setupReachability("invalidhost", useClosures: true)
                self.startNotifier()            }
            
        }
    }
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        hostNameLabel.text = hostName != nil ? hostName : "No host name"
        
        print("--- set up with host name: \(hostNameLabel.text!)")
        
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        self.reachability = reachability
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                DispatchQueue.main.async {
                    self.updateLabelColourWhenReachable(reachability)
                }
            }
            reachability?.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                    self.updateLabelColourWhenNotReachable(reachability)
                }
            }
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(NetWorkViewController.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        }
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            networkStatus.textColor = .red
            networkStatus.text = "Unable to start\nnotifier"
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
    
    func updateLabelColourWhenReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.currentReachabilityString)")
        if reachability.isReachableViaWiFi {
            self.networkStatus.textColor = .green
        } else {
            self.networkStatus.textColor = .blue
        }
        
        self.networkStatus.text = reachability.currentReachabilityString
    }
    
    func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.currentReachabilityString)")
        
        self.networkStatus.textColor = .red
        
        self.networkStatus.text = reachability.currentReachabilityString
    }
    
    
    @objc func reachabilityChanged(_ note: NSNotification) {
        
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            updateLabelColourWhenReachable(reachability)
        } else {
            updateLabelColourWhenNotReachable(reachability)
        }
    }
    
    deinit {
        stopNotifier()
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

