//
//  GameViewController.swift
//  ZeeInApp
//
//  Created by WangJZ on 15/4/7.
//  Copyright (c) 2015年 WangJZ. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
    @IBOutlet weak var zongfenLabel: UILabel!
    @IBOutlet weak var kongzhidefenLabel: UILabel!
    @IBOutlet weak var pinghengdefenLabel: UILabel!
    @IBOutlet weak var wanchengshijianLabel: UILabel!
    
    @IBOutlet weak var zhuangzhuSlider: UISlider!
    @IBOutlet weak var qingxuSlider: UISlider!
    @IBOutlet weak var jingliSlider: UISlider!
    
    var scenType : String?
    var mysk : SKView?
    
    var updateTimes:Int = 0 //获取分数的次数
    var wanchengshijian = 0
    var pinghengdefenArray : [Int] = [Int]()
    var kongzhidefenArray : [Int] = [Int]()
    var shishidefenArray : [Int] = [Int]()
    var lastStatus:Int = 0//默认上一次状态为静止
    func computeAverageDouble(arr: [Double], num: Int)->Double{
        var accum : Double = 0
        for d in arr{
            accum += d
        }
        return accum / Double(num)
    }
    
    func computeAverageInt(arr: [Int], num: Int)-> Int{
        if num == 0{
            return 0
        }
        
        var accum : Int = 0
        for d in arr{
            accum += d
        }
        return accum / num
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("【Scene】" + self.scenType! + " In GameViewController ViewDidLoad")

        mysk = SKView(frame: self.view.frame)
        self.view.addSubview(mysk!)
        mysk!.showsNodeCount = true
        let button = UIButton(frame:CGRect(origin: CGPointMake(800, 600), size:CGSizeMake(300,150)))
        button.setTitle("退出", forState:UIControlState.Normal)
        button.addTarget(self, action:"buttonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        mysk!.addSubview(button)
        
        //切换按钮
        let trans_button = UIButton(frame:CGRect(origin: CGPointMake(50, 600), size:CGSizeMake(300,150)))
        trans_button.setTitle("切换", forState:UIControlState.Normal)
        trans_button.addTarget(self, action:"transitionSceneButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        mysk!.addSubview(trans_button)
        
        // Watch Bluetooth connection
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("receivedValue:"), name: BLEServiceReceiveNotification, object: nil)
        
    }
    
    func receivedValue(notification: NSNotification){
        let userInfo = notification.userInfo as! [String: String]
        let values:[String]! = userInfo["value"]?.componentsSeparatedByString("\t")
        
        if values.count != 5 {
            return
        }
        
        //解析 arduino 蓝牙模块传来的数据
        let movement = Int(NSNumberFormatter().numberFromString(values[0])!.intValue)//反映速度的一个量
        let speedScore = Int(NSNumberFormatter().numberFromString(values[1])!.intValue)//速度得分
        let steadyScore = Int(NSNumberFormatter().numberFromString(values[2])!.intValue)//稳定得分
        let posture = Int(NSNumberFormatter().numberFromString(values[3])!.intValue)//姿态
        let status = Int(NSNumberFormatter().numberFromString(values[4])!.intValue)//状态
        let finalScore = Int(CGFloat(speedScore)*0.5+CGFloat(steadyScore)*0.5)
        //ios端保存每一次有用的读入
        pinghengdefenArray.append(steadyScore)//涵姐说：平衡就是稳定！
        kongzhidefenArray.append(speedScore)
        shishidefenArray.append(finalScore)
        updateTimes += 1
        
        transisionSceneStatus(status, posture: posture)
        //update UI should be in main queue
        dispatch_async(dispatch_get_main_queue(), {
            if self.scenType == kSceneTypeShuiZhong{
                let scene = self.mysk!.scene as! ShuiZhongScene
                scene.updateParticleEmitter(movement, speedScore: speedScore, steadyScore: steadyScore, posture: posture, status: status)
            }else if self.scenType == kSceneTypeSenlin{
                let scene = self.mysk!.scene as! SenlinScene
                scene.updateParticleEmitter(movement, speedScore: speedScore, steadyScore: steadyScore, posture: posture, status: status)
            }else if self.scenType == kSceneTypeShanGu{
                let scene = self.mysk!.scene as! ShanGuScene
                scene.updateParticleEmitter(movement, speedScore: speedScore, steadyScore: steadyScore, posture: posture, status: status)
            }else if self.scenType == kSceneTypeHaibian{
                let scene = self.mysk!.scene as! HaibianScene
                scene.updateParticleEmitter(movement, speedScore: speedScore, steadyScore: steadyScore, posture: posture, status: status)
            }

        });
    }
    
    override func viewWillAppear(animated: Bool) {
        println("View will Appear")
        if scenType == kSceneTypeShuiZhong{
            self.mysk!.presentScene(ShuiZhongScene(size: self.view.frame.size))
        }else if scenType == kSceneTypeSenlin{
            self.mysk!.presentScene(SenlinScene(size: self.view.frame.size))
        }else if scenType == kSceneTypeShanGu{
            self.mysk!.presentScene(ShanGuScene(size: self.view.frame.size))
        }else if scenType == kSceneTypeHaibian{
            self.mysk!.presentScene(HaibianScene(size: self.view.frame.size))
        }
    }
    
//    func transitionSceneButtonClick(sender:AnyObject){
//        dispatch_async(dispatch_get_main_queue(), {
//            let fade = SKTransition.fadeWithDuration(0.5)
//            let reavea = SKTransition.crossFadeWithDuration(1.5)
//            self.mysk!.presentScene(HaibianScene(size: self.view.frame.size), transition: fade)
//            self.scenType = kSceneTypeHaibian
//        })
//    }
//    
    func transisionSceneStatus(status: Int, posture: Int){
        if(status != lastStatus ){
            if(status == 0){
                switch posture{
                case 1:
                    dispatch_async(dispatch_get_main_queue(), {
                        let fade = SKTransition.fadeWithDuration(1.5)
                        let reavea = SKTransition.crossFadeWithDuration(1.5)
                        self.mysk!.presentScene(HaibianScene(size: self.view.frame.size), transition: fade)
                        self.scenType = kSceneTypeHaibian
                })
                case 3:
                    dispatch_async(dispatch_get_main_queue(), {
                        let fade = SKTransition.fadeWithDuration(1.5)
                        let reavea = SKTransition.crossFadeWithDuration(1.5)
                        self.mysk!.presentScene(SenlinScene(size: self.view.frame.size), transition: fade)
                        self.scenType = kSceneTypeSenlin
                    })
                case 4:
                    dispatch_async(dispatch_get_main_queue(), {
                        let fade = SKTransition.fadeWithDuration(1.5)
                        let reavea = SKTransition.crossFadeWithDuration(1.5)
                        self.mysk!.presentScene(ShanGuScene(size: self.view.frame.size), transition: fade)
                        self.scenType = kSceneTypeShanGu
                    })
                default:
                    println("default")
                }

            
            }
                 else if(status == 1){
            
            dispatch_async(dispatch_get_main_queue(), {
                let fade = SKTransition.fadeWithDuration(1.5)
                let reavea = SKTransition.crossFadeWithDuration(1.5)
                self.mysk!.presentScene(ShuiZhongScene(size: self.view.frame.size), transition: fade)
                self.scenType = kSceneTypeShuiZhong

            })
                }

        }
        lastStatus = status
        
    }
    
    func buttonClick(sender: AnyObject){
        //fix sprite bugs
        /*Release SKView Things*/
        mysk!.paused = true
        mysk!.scene?.removeFromParent()
        mysk!.removeFromSuperview()
        for child in mysk!.scene!.children{
            let c = child as! SKNode
            c.removeAllActions()
            c.removeAllChildren()
        }
        mysk!.scene!.removeAllChildren()
        
        /*Calculate Score*/
        let pinghengdefen = computeAverageInt(pinghengdefenArray, num: updateTimes)
        self.pinghengdefenLabel.text = "\(pinghengdefen)"
        
        let kongzhidefen = computeAverageInt(kongzhidefenArray, num: updateTimes)
        self.kongzhidefenLabel.text = "\(kongzhidefen)"
        
        let zongfen = computeAverageInt(shishidefenArray, num: updateTimes)
        self.zongfenLabel.text = "\(zongfen)"
    }
    
    @IBAction func finishBtnPress(sender: AnyObject) {
////        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }



}
