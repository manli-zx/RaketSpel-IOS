//
//  GameScene.swift
//  RaketSpel
//
//  Created by user149408 on 4/1/19.
//  Copyright © 2019 user149408. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var rocket = SKSpriteNode()
    var ballon = SKSpriteNode()
    var bear = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        if let node = self.childNode(withName: "raket")as?SKSpriteNode{
            rocket = node
            rocket.physicsBody?.usesPreciseCollisionDetection = true
        }
        if let node = self.childNode(withName: "ballon")as?SKSpriteNode{
            ballon = node
            ballon.physicsBody?.usesPreciseCollisionDetection = true
            }
       if let node = self.childNode(withName: "bear")as?SKSpriteNode{
                bear = node
        bear.removeAllActions()
               
       }
        self.physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        if let firstNode = contact.bodyA.node as?SKSpriteNode, let secondNode = contact.bodyB.node as?
            SKSpriteNode{
           print(firstNode.name!)
           print(secondNode.name!)
            ballon.removeFromParent()
            ballon.texture = SKTexture(imageNamed:"ballon_explode")
        }
    }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchPoint = touch.location(in: view)
            let touchLocation = convertPoint(fromView: touchPoint)
            //sendRocket(touchLocation)
            //moveRocket(touchLocation)
            moveBear(touchLocation)
             print(touchLocation)
            
        }
    }
    
        func moveBear(_ touchLocation:CGPoint){
            let startLocation = bear.position
            let a = touchLocation.x - startLocation.x
//            let b = touchLocation.y - startLocation.y
//            let s = sqrt(a*a + b*b)
            let time = Double(abs(a)/200)
            
            if a > 0 {
                bear.xScale = -0.5
            }else{
                bear.xScale = 0.5
            }
            
            
            if let bearAction = SKAction(named: "bearWalk"){
               bear.run(bearAction)
                bear.run(SKAction.repeatForever(bearAction))
            }
//            var alpha = -atan(a/b)
//            if b<0 {alpha = alpha + .pi}
            
            let moveAction = SKAction.moveBy(x:a,y:0,duration : time)
            
            //bear.run(moveAction)
            bear.run(moveAction,completion: {() -> Void in
                self.bear.removeAllActions()
                self.bear.texture=SKTexture(imageNamed:"bear1.jpg")
        })
        }
        
    func moveRocket(_ touchLocation:CGPoint){
        let startLocation = rocket.position
        let a = touchLocation.x - startLocation.x
        let b = touchLocation.y - startLocation.y
        let s = sqrt(a*a + b*b)
        let time = Double(s/200)
        
        
        var alpha = -atan(a/b)
        if b<0 {alpha = alpha + .pi}
        let rotateAction = SKAction.rotate(toAngle: alpha, duration: 0.3,shortestUnitArc:true)
        let moveAction = SKAction.move(to:touchLocation,duration : time)
        
        let moveSequence = SKAction.sequence([rotateAction,moveAction])
        
        rocket.run(moveSequence)
    }
    
    func sendRocket(_ touchLocation : CGPoint){
        let rocketLocation = rocket.position
        
        let a = touchLocation.x - rocketLocation.x
        let b = touchLocation.y - rocketLocation.y
        
        var alpha = -atan(a/b)
        if b<0 {alpha = alpha + .pi}
        rocket.zRotation = alpha
        
        rocket.physicsBody?.velocity = CGVector(dx: a,dy: 2*b)
        rocket.physicsBody?.affectedByGravity = true
        
       
    }
    
    
    
     override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }


}
