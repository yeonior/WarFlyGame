//
//  PowerUp.swift
//  WarFlyGame
//
//  Created by ruslan on 22.06.2021.
//

import SpriteKit

class PowerUp: SmallSprite {
    
    init(textureAtlas: SKTextureAtlas) {
        
        let initialSize = CGSize(width: 52, height: 52)
        let action = SKAction.moveTo(y: -300, duration: 5)
        super.init(textureAtlas: textureAtlas, size: initialSize, textureCount: 15, action: action)
        self.name = "sprite"
        self.zPosition = 20
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.powerUp
        self.physicsBody?.collisionBitMask = BitMaskCategory.player
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
