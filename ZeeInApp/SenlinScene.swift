//
//  HelloScene.swift
//  ZeeInApp
//
//  Created by WangJZ on 15/4/6.
//  Copyright (c) 2015年 WangJZ. All rights reserved.
//

import SpriteKit

class SenlinScene : SKScene {
//    var pressed : Bool = fal
    var contentCreated : Bool = false
    var emitter : SKEmitterNode = SKEmitterNode(fileNamed: "senlin.sks")
    
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
        println("elapse:\(elapse)")
        emitter.particleSpeed = CGFloat(movement)*1.5
        emitter.particleBirthRate = 100-CGFloat(elapse)*2
            //100+CGFloat(movement)*0.2
        emitter.particleAlphaSpeed = -0.35+CGFloat(100-steadyScore)*0.002
       /* emitter.emissionAngleRange = CGFloat(100-steadyScore)*0.9*/
    }
    
    func createContent() {
        //        backgroundColor = SKColor.blueColor()
        scaleMode = SKSceneScaleMode.AspectFit
        let bg = SKSpriteNode(imageNamed:"senlin.png")
        bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        bg.name = "BACKGROUND";
        self.addChild(bg)
        
        //        addChild(newHelloNode())
//        let sparkEmmiter = SKEmitterNode(fileNamed: "MyParticle.sks")
        emitter.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
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
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        var helloNode:SKNode! = childNodeWithName("helloNode")
//        if helloNode != nil {
//            helloNode.name = nil
//            
//            var moveUp:SKAction = SKAction.moveByX(0, y: 100, duration: 0.5)
//            var zoom:SKAction = SKAction.scaleTo(2, duration: 0.25)
//            var pause:SKAction = SKAction.waitForDuration(0.5)
//            var fadeAway = SKAction.fadeOutWithDuration(0.25)
//            var remove = SKAction.removeFromParent()
//            var moveSequence = SKAction.sequence([moveUp, zoom, pause, fadeAway, remove])
//            helloNode.runAction(moveSequence)
//        }
//    }

//    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        
//    }
}

