//
//  Shot.swift
//  WarFlyGame
//
//  Created by ruslan on 27.06.2021.
//

import SpriteKit

class Shot: SmallSprite {
    
    init(textureAtlas: SKTextureAtlas) {
        
        let initialSize = CGSize(width: 187, height: 237)
        let screenSize = UIScreen.main.bounds
        let action = SKAction.moveTo(y: screenSize.height + 100, duration: 2)
        super.init(textureAtlas: textureAtlas, size: initialSize, textureCount: 32, action: action)
        self.name = "shotSprite"
        self.zPosition = 30
        self.setScale(0.3)
        
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = BitMaskCategory.shot.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.enemy.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
