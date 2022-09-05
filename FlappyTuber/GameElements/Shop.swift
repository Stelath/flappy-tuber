//
//  Shop.swift
//  FlappyTuber
//
//  Created by Alexander Korte on 2/15/19.
//  Copyright © 2019 AlexanderKorte. All rights reserved.
//

import SpriteKit

extension GameScene {
    func createShop() -> SKShapeNode {
        let shopBg = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.frame.width + 10, height: self.frame.height + 10))
        shopBg.fillColor = UIColor.white
        shopBg.zPosition = 10
        
        let coinCountLbl = SKLabelNode()
        coinCountLbl.position = CGPoint(x: self.frame.width - 60, y: self.frame.height - 75)
        let coinCount = UserDefaults.standard.object(forKey: "coinCount")
        coinCountLbl.text = String(coinCount as! Int)
        coinCountLbl.fontSize = 25
        coinCountLbl.fontColor = UIColor.darkGray
        coinCountLbl.fontName = "Helvetica-Bold"
        
        let coinCountCoin: SKSpriteNode = SKSpriteNode(imageNamed: "coin")
        coinCountCoin.position = CGPoint(x: -45, y: 12)
        coinCountCoin.size = CGSize(width: 40, height: 40)
        coinCountLbl.addChild(coinCountCoin)
        
        shopBg.addChild(coinCountLbl)
        
        let shopLbl = SKLabelNode()
        shopLbl.position = CGPoint(x: 75, y: self.frame.height - 85)
        shopLbl.text = "Shop"
        shopLbl.fontSize = 50
        shopLbl.fontColor = UIColor.darkGray
        shopLbl.fontName = "Helvetica-Bold"
        
        shopBg.addChild(shopLbl)
        
        return shopBg
    }
    
    func createShopCloseBtn() -> SKSpriteNode {
        let shopCloseBtn = SKSpriteNode(imageNamed: "shopCloseButton")
        shopCloseBtn.size = CGSize(width: 25, height: 25)
        shopCloseBtn.position = CGPoint(x: 25, y: (self.frame.height * 2) - 25)
        shopCloseBtn.zPosition = 11
        return shopCloseBtn
    }
}
