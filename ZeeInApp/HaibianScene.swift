//
//  HelloScene.swift
//  ZeeInApp
//
//  Created by WangJZ on 15/4/6.
//  Copyright (c) 2015年 WangJZ. All rights reserved.
//

import SpriteKit


class HaibianScene : SKScene {
    var contentCreated : Bool = false
    var emitter : SKEmitterNode = SKEmitterNode(fileNamed: "haibian.sks")
    
    override func didMoveToView(view: SKView) {
        if !contentCreated {
            createContent()
            contentCreated = true
        }
    }
    
    /*在这里修改粒子效果*/
    func updateParticleEmitter(movement : Int, speedScore : Int, steadyScore:Int,posture:Int,status:Int,elapse:Int){
        //movement反映速度的一个量,speedScore速度得分,steadyScore稳定得分,posture姿态,status状态
        println("mvmt:\(movement)")
        emitter.particleSpeed = 50+CGFloat(movement)
       /* emitter.particleBirthRate = 6+CGFloat(movement)*0.20*/
        emitter.particleLifetime = 10-CGFloat(movement)/20.0
       /* emitter.emissionAngleRange = CGFloat(100-steadyScore)*1.0/100.0*/
        emitter.xAcceleration = CGFloat(100-steadyScore)/10.0
    }
    
    func createContent() {
        //        backgroundColor = SKColor.blueColor()
        scaleMode = SKSceneScaleMode.AspectFit
        let bg = SKSpriteNode(imageNamed:"haibian.png")
        bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        bg.name = "BACKGROUND";
        self.addChild(bg)
        
        //        addChild(newHelloNode())
//        let sparkEmmiter = SKEmitterNode(fileNamed: "MyParticle.sks")
        emitter.position = CGPointMake(self.frame.size.width/2, self.frame.size.height * 9.0 / 10.0)
        emitter.name = "sparkEmmitter"
//        emitter.zPosition = 1
    
//        emitter.particleLifetime = 1
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var helloNode:SKNode! = childNodeWithName("helloNode")
        if helloNode != nil {
            helloNode.name = nil
            
            var moveUp:SKAction = SKAction.moveByX(0, y: 100, duration: 0.5)
            var zoom:SKAction = SKAction.scaleTo(2, duration: 0.25)
            var pause:SKAction = SKAction.waitForDuration(0.5)
            var fadeAway = SKAction.fadeOutWithDuration(0.25)
            var remove = SKAction.removeFromParent()
            var moveSequence = SKAction.sequence([moveUp, zoom, pause, fadeAway, remove])
            helloNode.runAction(moveSequence)
        }
    }
}

