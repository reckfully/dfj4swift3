//
//  MainScene.swift
//  Dafeiji
//
//  Created by 陈凯 on 12/10/2016.
//  Copyright © 2016 陈凯. All rights reserved.
//

import SpriteKit

enum RoleCategory: UInt32 {
    case bullet = 1
    case foePlane = 4
    case playerPlane = 8
}

class MainScene: SKScene, SKPhysicsContactDelegate {
    
    var smallPlaneTime = 0
    var mediumPlaneTime = 0
    var bigPlaneTime = 0
    
    var adjustmentBackgroundPosition = CGFloat(0)
    
    var scoreLabel: SKLabelNode!
    var playerPlane: SKSpriteNode!
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    
    var smallFoePlaneHitAction: SKAction!
    var smallFoePlaneBlowupAction: SKAction!
    var mediumFoePlaneHitAction: SKAction!
    var mediumFoePlaneBlowupAction: SKAction!
    var bigFoePlaneHitAction: SKAction!
    var bigFoePlaneBlowupAction: SKAction!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.initPhysicWorld()
        self.initActin()
        self.initBackground()
        self.initScore()
        self.initPlayerPlane()
        self.firingBullets()
        
        NotificationCenter.default.addObserver(self, selector: #selector(restart), name: NSNotification.Name(rawValue: "restart_dafeiji"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func restart() {
        self.removeAllChildren()
        self.removeAllActions()
        
        self.initBackground()
        self.initScore()
        self.initPlayerPlane()
        self.firingBullets()
    }
    
    func initPhysicWorld() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    func initActin() {
        smallFoePlaneHitAction = Atlas.hitAction(with: .small)
        smallFoePlaneBlowupAction = Atlas.blowupAction(with: .small)
        
        mediumFoePlaneHitAction = Atlas.hitAction(with: .medium)
        mediumFoePlaneBlowupAction = Atlas.blowupAction(with: .medium)
        
        bigFoePlaneHitAction = Atlas.hitAction(with: .big)
        bigFoePlaneBlowupAction = Atlas.blowupAction(with: .big)
    }
    
    func initBackground() {
        adjustmentBackgroundPosition = self.size.height
        
        background1 = SKSpriteNode.init(texture: Atlas.texture(with: .background))
        background1.size = self.size
        background1.position = CGPoint(x: self.size.width / 2, y: 0)
        background1.anchorPoint = CGPoint(x: 0.5, y: 0)
        background1.zPosition = 0
        self.addChild(background1)
        
        background2 = SKSpriteNode.init(texture: Atlas.texture(with: .background))
        background2.size = self.size
        background2.position = CGPoint(x: self.size.width / 2, y: 0)
        background2.anchorPoint = CGPoint(x: 0.5, y: adjustmentBackgroundPosition - 1)
        background2.zPosition = 0
        self.addChild(background2)
    }
    
    func scrollBackground() {
        adjustmentBackgroundPosition -= 1
        if adjustmentBackgroundPosition <= 0 {
            // what's 568
            adjustmentBackgroundPosition = 568
        }
    }
    
    func initScore() {
        scoreLabel = SKLabelNode.init(fontNamed: "MarkerFelt-Thin")
        scoreLabel.text = "0000"
        scoreLabel.zPosition = 2
        scoreLabel.fontColor = SKColor.black
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 50, y: self.size.height - 52)
        self.addChild(scoreLabel)
    }
    
    func initPlayerPlane() {
        playerPlane = SKSpriteNode.init(texture: Atlas.texture(with: .playerPlane))
        playerPlane.position = CGPoint.init(x: 160, y: 50)
        playerPlane.zPosition = 1
        playerPlane.physicsBody = SKPhysicsBody.init(rectangleOf: playerPlane.size)
        playerPlane.physicsBody?.categoryBitMask = RoleCategory.playerPlane.rawValue
        playerPlane.physicsBody?.collisionBitMask = 0
        playerPlane.physicsBody?.contactTestBitMask = RoleCategory.foePlane.rawValue
        self.addChild(playerPlane)
        playerPlane.run(Atlas.playerPlaneAction())
        
    }
    
    func create(with type: FoePlaneType) -> FoePlane {
        
        var foePlane: FoePlane!
        switch type {
        case .big:
            foePlane = FoePlane.createBigFoePlane()
        case .medium:
            foePlane = FoePlane.createMediumFoePlane()
        case .small:
            foePlane = FoePlane.createSmallFoePlane()
        }
        
        foePlane.zPosition = 1
        foePlane.physicsBody?.categoryBitMask = RoleCategory.foePlane.rawValue
        foePlane.physicsBody?.collisionBitMask = RoleCategory.bullet.rawValue
        foePlane.physicsBody?.contactTestBitMask = RoleCategory.bullet.rawValue
        foePlane.position = CGPoint(x: CGFloat(arc4random() % 220 + 35), y: self.size.height)
        
        return foePlane
    }
    
    func createFoePlane() {
        smallPlaneTime += 1
        mediumPlaneTime += 1
        bigPlaneTime += 1
        
        // TODO : - refine level
        if smallPlaneTime > 10 {
            let foePlane = create(with: .small)
            self.addChild(foePlane)
            foePlane.run(SKAction.sequence([SKAction.moveTo(y: 0, duration: Double(arc4random() % 3 + 2)), SKAction.removeFromParent()]))
            smallPlaneTime = 0
        }
        
        if mediumPlaneTime > 50 {
            let foePlane = create(with: .medium)
            self.addChild(foePlane)
            foePlane.run(SKAction.sequence([SKAction.moveTo(y: 0, duration: Double(arc4random() % 3 + 4)), SKAction.removeFromParent()]))
            mediumPlaneTime = 0
        }
        
        if bigPlaneTime > 100 {
            let foePlane = create(with: .big)
            self.addChild(foePlane)
            foePlane.run(SKAction.sequence([SKAction.moveTo(y: 0, duration: Double(arc4random() % 3 + 6)), SKAction.removeFromParent()]))
            bigPlaneTime = 0
        }
    }
    
    func createBullets() {
        let bullet = SKSpriteNode.init(texture: Atlas.texture(with: .bullet))
        bullet.physicsBody = SKPhysicsBody.init(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = RoleCategory.bullet.rawValue
        bullet.physicsBody?.collisionBitMask = RoleCategory.foePlane.rawValue
        bullet.physicsBody?.contactTestBitMask = RoleCategory.foePlane.rawValue
        bullet.zPosition = 1
        bullet.position = CGPoint(x: playerPlane.position.x, y: playerPlane.position.y + playerPlane.size.height / 2)
        self.addChild(bullet)
        
        bullet.run(SKAction.sequence([SKAction.move(to: CGPoint(x: playerPlane.position.x, y: self.size.height), duration: 0.5), SKAction.removeFromParent()]))
        
        self.run(SKAction.playSoundFileNamed("bullet.mp3", waitForCompletion: false))
    }
    
    func firingBullets() {
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run() {
            self.createBullets()
            }, SKAction.wait(forDuration: 0.2)])))
    }
    
    func addScore(by type: FoePlaneType) {
        var score = 0
        switch type {
        case .big:
            score = 25
        case .medium:
            score = 5
        case .small:
            score = 1
        }
        scoreLabel.run(SKAction.run() {
            self.scoreLabel.text = "\(Int(self.scoreLabel.text!)! + score)"
        })
    }
    
    func foePlaneCollisionAnimation(sprite: FoePlane) {
        if sprite.action(forKey: "dieAction") == nil {
            var hitAction: SKAction? = nil
            var blowupAction: SKAction? = nil
            var soundFileName = ""
            
            // TODO: - refine file name
            switch sprite.type {
            case .big:
                sprite.hp -= 1
                hitAction = bigFoePlaneHitAction
                blowupAction = bigFoePlaneBlowupAction
                soundFileName = "enemy2_down.mp3"
            case .medium:
                sprite.hp -= 1
                hitAction = mediumFoePlaneHitAction
                blowupAction = mediumFoePlaneBlowupAction
                soundFileName = "enemy3_down.mp3"
            case .small:
                sprite.hp -= 1
                hitAction = smallFoePlaneHitAction
                blowupAction = smallFoePlaneBlowupAction
                soundFileName = "enemy1_down.mp3"
            }
            
            if sprite.hp == 0 {
                sprite.removeAllActions()
                sprite.run(blowupAction!, withKey: "dieAction")
                self.addScore(by: sprite.type)
                self.run(SKAction.playSoundFileNamed(soundFileName, waitForCompletion: false))
            } else {
                self.run(hitAction!)
            }
        }
    }
    
    func playerPlaneCollisionAnimation(sprite: SKSpriteNode) {
        self.removeAllActions()
        sprite.run(Atlas.playerPlaneBlowupAction()) {
            self.run(SKAction.sequence([SKAction.playSoundFileNamed("game_over.mp3", waitForCompletion: true), SKAction.run() {
                let label = SKLabelNode.init(fontNamed: "MarkerFelt-Thin")
                label.text = "Game Over"
                label.zPosition = 2
                label.fontColor = SKColor.black
                label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
                self.addChild(label)
                }])) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dafeiji_game_over"), object: nil)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            var location = touch.location(in: self)
            
            if location.x >= self.size.width - playerPlane.size.width / 2 {
                location.x = self.size.width - playerPlane.size.width / 2
            } else if location.x <= playerPlane.size.width / 2 {
                location.x = playerPlane.size.width / 2
            }
            
            if location.y >= self.size.height - playerPlane.size.height / 2 {
                location.x = self.size.height - playerPlane.size.height / 2
            } else if location.y <= playerPlane.size.height / 2 {
                location.x = playerPlane.size.height / 2
            }
            
            playerPlane.run(SKAction.move(to: CGPoint(x: location.x, y: location.y), duration: 0))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.createFoePlane()
        self.scrollBackground()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask & RoleCategory.foePlane.rawValue > 0 || contact.bodyB.categoryBitMask & RoleCategory.foePlane.rawValue > 0 {
            let foePlane = (contact.bodyA.categoryBitMask & RoleCategory.foePlane.rawValue > 0) ? contact.bodyA.node : contact.bodyB.node
            if contact.bodyA.categoryBitMask & RoleCategory.playerPlane.rawValue > 0 || contact.bodyB.categoryBitMask & RoleCategory.playerPlane.rawValue > 0 {
                let playerPlane = (contact.bodyA.categoryBitMask & RoleCategory.playerPlane.rawValue > 0) ? contact.bodyA.node : contact.bodyB.node
                self.playerPlaneCollisionAnimation(sprite: playerPlane as! SKSpriteNode)
            } else {
                let bullet = (contact.bodyA.categoryBitMask & RoleCategory.foePlane.rawValue > 0) ? contact.bodyB.node : contact.bodyA.node
                bullet?.removeFromParent()
                self.foePlaneCollisionAnimation(sprite: foePlane as! FoePlane)
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
