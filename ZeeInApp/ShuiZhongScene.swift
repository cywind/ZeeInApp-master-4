//
//  HelloScene.swift
//  ZeeInApp
//
//  Created by WangJZ on 15/4/6.
//  Copyright (c) 2015年 WangJZ. All rights reserved.
//

import SpriteKit

let kSceneTypeShanGu = "shangu"
let kSceneTypeShuiZhong = "shuizhong"
let kSceneTypeHaibian = "haibian"
let kSceneTypeSenlin = "senlin"

class ShuiZhongScene : SKScene {
    var contentCreated : Bool = false
    var emitter : SKEmitterNode = SKEmitterNode(fileNamed: kSceneTypeShuiZhong+".sks")
    
    
    override func didMoveToView(view: SKView) {
        if !contentCreated {
            createContent()
            contentCreated = true
        }
    }
    
    /*在这里修改粒子效果*/
    func updateParticleEmitter(movement : Int, speedScore : Int, steadyScore:Int,posture:Int,status:Int){
        //movement反映速度的一个量,speedScore速度得分,steadyScore稳定得分,posture姿态,status状态
        println("mvmt:\(movement)")
        emitter.particleSpeed = CGFloat(movement)*1.5
        emitter.particleBirthRate = 20+CGFloat(movement)*0.2
        emitter.emissionAngleRange = CGFloat(100-steadyScore)*0.9

    
    }
    
    func createContent() {
        scaleMode = SKSceneScaleMode.AspectFit
        let bg = SKSpriteNode(imageNamed: kSceneTypeShuiZhong + ".png")
        bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        bg.name = "BACKGROUND";
        self.addChild(bg)
        emitter.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        emitter.name = "sparkEmmitter"
        self.addChild(emitter)
    }
    
    func newHelloNode() -> SKLabelNode! {
        var helloNode:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        helloNode.text = "Hello, World!"
        helloNode.fontSize = 42
        helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        helloNode.name = "helloNode"
        return helloNode
    }
}

