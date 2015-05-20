//
//  FirstViewController.swift
//  ZeeInApp
//
//  Created by WangJZ on 15/4/4.
//  Copyright (c) 2015年 WangJZ. All rights reserved.
//

import UIKit

let kPresentGameViewControllerIdentifier = "presentGameViewController"

class FirstViewController: UIViewController {
    var chosenType : String? = kSceneTypeHaibian //kSceneTypeHaibian
    
    @IBOutlet weak var imgBluetoothStatus: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    var isPracticing: Bool? {
        didSet {
            if isPracticing == false{
                
            }else{
            
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func connectBlueTooth() {
        // Start the Bluetooth discovery process
        btDiscoverySharedInstance
    }
    
//    func receivedValue(notification: NSNotification){
//        let userInfo = notification.userInfo as [String: String]
//        let values:[String]! = userInfo["value"]?.componentsSeparatedByString("\t")
//        
//        if values.count != 3 {
//            return
//        }
//        dispatch_async(dispatch_get_main_queue(), {
//            self.label1.text = values[0]
//            self.label2.text = values[1]
//            self.label3.text = values[2]
//        });
//    }
    
    
    func connectionChanged(notification: NSNotification) {
        // Connection status changed. Indicate on GUI.
        let userInfo = notification.userInfo as! [String: Bool]
        dispatch_async(dispatch_get_main_queue(), {
            //Set image based on connection status
//            if let isConnected: Bool = userInfo["isConnected"] {
//                if isConnected {
//                    self.imgBluetoothStatus.image = UIImage(named: "Bluetooth_Connected")
//                } else {
//                    self.imgBluetoothStatus.image = UIImage(named: "Bluetooth_Disconnected")
//                }
//            }
        });
    }
    
    @IBAction func startBtnPressed(sender: UIButton) {
        println("【按钮\(sender.tag)】开始练习")
        // Watch Bluetooth connection
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("connectionChanged:"), name: BLEServiceChangedStatusNotification, object: nil)
        connectBlueTooth()
        isPracticing = true
        if sender.tag == 1{
            self.chosenType = kSceneTypeShanGu
        }else if sender.tag == 2{
            self.chosenType = kSceneTypeShuiZhong
        }else if sender.tag == 3 {
            self.chosenType = kSceneTypeHaibian
        }else if sender.tag == 4 {
            self.chosenType = kSceneTypeSenlin
        }

        self.performSegueWithIdentifier(kPresentGameViewControllerIdentifier, sender: self)
    }
    
    
    @IBAction func stopPractice() {
        println("【按钮】结束练习")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: BLEServiceChangedStatusNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: BLEServiceReceiveNotification, object: nil)
        isPracticing = false
        dispatch_async(dispatch_get_main_queue(), {
            self.label1.text = ""
            self.label2.text = ""
            self.label3.text = ""
        });
    }
    
    @IBAction func jump() {
        println("【按钮】跳转统计")
        self.tabBarController?.selectedIndex = 1
    }
    
    func readAndWrite() {
        var arr = DataManager.LoadData()
        arr?.addObject("4")
        println("\(arr)")
        DataManager.SaveData(arr)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        http://stackoverflow.com/questions/26089152/sending-data-with-segue-with-swift
        if segue.identifier == "presentGameViewController"{
        let gmv = segue.destinationViewController as! GameViewController
            gmv.scenType = self.chosenType
        }
    }
}

