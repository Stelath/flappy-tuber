//
//  GameElements.swift
//  FlappyTube
//
//  Created by Alexander Korte on 1/31/19.
//  Copyright © 2019 AlexanderKorte. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let birdCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let pointCategory:UInt32 = 0x1 << 2
    static let coinCategory:UInt32 = 0x1 << 3
    static let groundCategory:UInt32 = 0x1 << 4
}

extension GameScene {
    func createBird() -> SKSpriteNode {
        
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("player-0"))
        bird.size = CGSize(width: 50, height: 50)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.pointCategory | CollisionBitMask.groundCategory
        
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:100, height:100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:40, height:40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontColor = UIColor.darkGray
        scoreLbl.fontName = "HelveticaNeue-Bold"
        return scoreLbl
    }
    
    func createCoinCountLabel() -> SKLabelNode {
        let coinCountLbl = SKLabelNode()
        coinCountLbl.position = CGPoint(x: self.frame.width - 60, y: self.frame.height - 22)
        let coinCount = UserDefaults.standard.object(forKey: "coinCount")
        coinCountLbl.text = String(coinCount as! Int)
        coinCountLbl.zPosition = 5
        coinCountLbl.fontSize = 15
        coinCountLbl.fontColor = UIColor.darkGray
        coinCountLbl.fontName = "Helvetica-Bold"
        
        let coinCountCoin: SKSpriteNode = SKSpriteNode(imageNamed: "coin")
        coinCountCoin.position = CGPoint(x: -25, y: 6)
        coinCountCoin.size = CGSize(width: 20, height: 20)
        coinCountLbl.addChild(coinCountCoin)
        
        return coinCountLbl
    }
    
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.size = CGSize(width: 200, height: 100)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createStartBtn() -> SKSpriteNode {
        let startBtn = SKSpriteNode(imageNamed: "playButton")
        startBtn.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY - 100)
        startBtn.size = CGSize(width: 75, height: 50)
        return startBtn
    }
    
    func createShopBtn() -> SKSpriteNode {
        let shopBtn = SKSpriteNode(imageNamed: "shopButton")
        shopBtn.position = CGPoint(x: self.frame.midX + 50, y: self.frame.midY - 100)
        shopBtn.size = CGSize(width: 75, height: 50)
        return shopBtn
    }
    
    func createWalls() -> SKNode  {
        
        let coinNode = SKSpriteNode(imageNamed: "coin")
        coinNode.size = CGSize(width: 40, height: 40)
        coinNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        coinNode.physicsBody = SKPhysicsBody(rectangleOf: coinNode.size)
        coinNode.physicsBody?.affectedByGravity = false
        coinNode.physicsBody?.isDynamic = false
        coinNode.physicsBody?.categoryBitMask = CollisionBitMask.coinCategory
        coinNode.physicsBody?.collisionBitMask = 0
        coinNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        coinNode.color = SKColor.blue
        
        let pointNode = SKShapeNode(circleOfRadius: 20)
        pointNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        pointNode.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        pointNode.physicsBody?.affectedByGravity = false
        pointNode.physicsBody?.isDynamic = false
        pointNode.physicsBody?.categoryBitMask = CollisionBitMask.pointCategory
        pointNode.physicsBody?.collisionBitMask = 0
        pointNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        pointNode.isHidden = true
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "piller")
        let btmWall = SKSpriteNode(imageNamed: "piller")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 575)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 575)
        
        topWall.size = CGSize(width: 50, height: 1000)
        btmWall.size = CGSize(width: 50, height: 1000)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(Double.pi)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        let randomPosition = random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(pointNode)
        
        if Int.random(in: 0...1) == 0 {
            wallPair.addChild(coinNode)
        }
        
        wallPair.run(moveAndRemove)
        
        return wallPair
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
}
