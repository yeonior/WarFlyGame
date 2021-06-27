//
//  SmallSprites.swift
//  WarFlyGame
//
//  Created by ruslan on 27.06.2021.
//

import SpriteKit

class SmallSprite: SKSpriteNode {
    
    fileprivate let textureAtlas: SKTextureAtlas!
    fileprivate var textureNameBeginsWith = ""
    fileprivate var animationSpriteArray = [SKTexture]()
    fileprivate let textureCount: Int
    fileprivate let action: SKAction
    
    init(textureAtlas: SKTextureAtlas, size: CGSize, textureCount: Int, action: SKAction) {
        
        self.textureAtlas = textureAtlas
        
        self.action = action
        let textureName = textureAtlas.textureNames.sorted()[0]
        let texture = textureAtlas.textureNamed(textureName)
        textureNameBeginsWith = String(textureName.dropLast(6))
        self.textureCount = textureCount
        
        super.init(texture: texture, color: .clear, size: size)
        self.setScale(0.7)
    }
    
    func startMovement() {
        
        performRotation()
        
        let moveForward = action
        self.run(moveForward)
    }
    
    fileprivate func performRotation() {
        
        for i in 1...textureCount {
            let number = String(format: "%02d", arguments: [i])
            animationSpriteArray.append(SKTexture(imageNamed: textureNameBeginsWith + number))
        }
        
        SKTexture.preload(animationSpriteArray) {
            let rotation = SKAction.animate(with: self.animationSpriteArray, timePerFrame: 0.05, resize: true, restore: false)
            let rotationForever = SKAction.repeatForever(rotation)
            self.run(rotationForever)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
