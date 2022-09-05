//
//  GameScene.swift
//  FlappyTube
//
//  Created by Alexander Korte on 1/31/19.
//  Copyright © 2019 AlexanderKorte. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isGameStarted: Bool = false
    var isDead: Bool = false
    var shopOpen: Bool = false
    //let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var coinCount = 0
    var coinCountLbl = SKLabelNode()
    var startBtn = SKSpriteNode()
    var shopBtn = SKSpriteNode()
    var shop = SKShapeNode()
    var shopCloseBtn = SKSpriteNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    
    // Create bird atlas
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites: [SKTexture] = []
    var bird = SKSpriteNode()
    var repeatActionBird = SKAction()
    
    func createScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 80, width: frame.width, height: frame.height - 80))
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            //background.size = CGSize(width: (((self.view?.frame.height)!)/2), height: (self.view?.frame.height)!)
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        //Setup bird sprites
        birdSprites.append(birdAtlas.textureNamed("player-0"))
        birdSprites.append(birdAtlas.textureNamed("player-1"))
        birdSprites.append(birdAtlas.textureNamed("player-2"))
        birdSprites.append(birdAtlas.textureNamed("player-3"))
        
        if let coins = UserDefaults.standard.object(forKey: "coinCount") {
            coinCount = coins as! Int
        } else {
            UserDefaults.standard.set(0, forKey: "coinCount")
        }
        
        self.bird = createBird()
        self.addChild(bird)
        
        //Prepare to animate the bird
        let animateBird = SKAction.animate(with: self.birdSprites, timePerFrame: 0.1)
        self.repeatActionBird = SKAction.repeatForever(animateBird)
        
        //Create Lables
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        coinCountLbl = createCoinCountLabel()
        self.addChild(coinCountLbl)
        
        createLogo()
        
        startBtn = createStartBtn()
        self.addChild(startBtn)
        
        shopBtn = createShopBtn()
        self.addChild(shopBtn)
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDead = false
        isGameStarted = false
        score = 0
        createScene()
    }
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory || firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory{
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if isDead == false{
                isDead = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pointCategory {
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.pointCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.coinCategory {
            //run(coinSound)
            coinCount += 1
            UserDefaults.standard.set(coinCount, forKey: "coinCount")
            coinCountLbl.text = "\(coinCountLbl)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.coinCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            //run(coinSound)
            coinCount += 1
            UserDefaults.standard.set(coinCount, forKey: "coinCount")
            coinCountLbl.text = "\(coinCount)"
            firstBody.node?.removeFromParent()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted == false {
            for touch in touches {
                if startBtn.contains(touch.location(in: self)) {
                    isGameStarted =  true
                    bird.physicsBody?.affectedByGravity = true
                    createPauseBtn()
                    
                    logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                        self.logoImg.removeFromParent()
                    })
                    startBtn.removeFromParent()
                    shopBtn.removeFromParent()
                    
                    self.bird.run(repeatActionBird)
                    
                    let spawn = SKAction.run({
                        () in
                        self.wallPair = self.createWalls()
                        self.addChild(self.wallPair)
                    })
                    
                    let delay = SKAction.wait(forDuration: 2)
                    let SpawnDelay = SKAction.sequence([spawn, delay])
                    let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
                    self.run(spawnDelayForever)

                    let distance = CGFloat(self.frame.width + wallPair.frame.width)
                    let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
                    let removePillars = SKAction.removeFromParent()
                    moveAndRemove = SKAction.sequence([movePillars, removePillars])

                    bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
                } else if shopBtn.contains(touch.location(in: self)) {
                    shopOpen = true
                    
                    shop = createShop()
                    shop.position = CGPoint(x: 0, y: frame.height)
                    self.addChild(shop)
                    
                    shopCloseBtn = createShopCloseBtn()
                    self.addChild(shopCloseBtn)
                    
                    let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -(frame.height)), duration: 1)
                    
                    shop.run(moveDown)
                    shopCloseBtn.run(moveDown)
                } else if shopCloseBtn.contains(touch.location(in: self)) {
                    let moveUp = SKAction.move(by: CGVector(dx: 0, dy: (frame.height)), duration: 1)
                    
                    shop.run(moveUp)
                    shopCloseBtn.run(moveUp) {
                        self.removeChildren(in: [self.shop, self.shopCloseBtn])
                    }
                }
            }
        } else {
            // MARK: Apply Upward Force To Bird
            if isDead == false {
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
        
        for touch in touches{
            let location = touch.location(in: self)
            
            if isDead == true{
                if restartBtn.contains(location){
                    if UserDefaults.standard.object(forKey: "coinCount") == nil {
                        UserDefaults.standard.set(0, forKey: "coinCount")
                    }
                    restartScene()
                }
            } else {
                if pauseBtn.contains(location){
                    bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -40))
                    if self.isPaused == false{
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    } else {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if isGameStarted == true {
            if isDead == false {
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                    }
                }))
            }
        }
    }
    
}
