//
//  Shot.swift
//  WarFlyGame
//
//  Created by ruslan on 27.06.2021.
//

import SpriteKit

class Shot: SKSpriteNode {
    
    let screenSize = UIScreen.main.bounds
    
    fileprivate let initialSize = CGSize(width: 187, height: 237)
    fileprivate let textureAtlas: SKTextureAtlas!
    fileprivate var textureNameBeginsWith = ""
    fileprivate var animationSpriteArray = [SKTexture]()
    
    init(textureAtlas: SKTextureAtlas) {
        
        self.textureAtlas = textureAtlas
        let textureName = textureAtlas.textureNames.sorted()[0]
        let texture = textureAtlas.textureNamed(textureName)
        textureNameBeginsWith = String(textureName.dropLast(6))
        
        super.init(texture: texture, color: .clear, size: initialSize)
        self.setScale(0.7)
        self.name = "shotSprite"
        self.zPosition = 30
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMovement() {
        
        performRotation()
        
        let moveForward = SKAction.moveTo(y: screenSize.height + 100, duration: 2)
        self.run(moveForward)
    }
    
    fileprivate func performRotation() {
        
        for i in 1...32 {
            let number = String(format: "%02d", arguments: [i])
            animationSpriteArray.append(SKTexture(imageNamed: textureNameBeginsWith + number))
        }
        
        SKTexture.preload(animationSpriteArray) {
            let rotation = SKAction.animate(with: self.animationSpriteArray, timePerFrame: 0.05, resize: true, restore: false)
            let rotationForever = SKAction.repeatForever(rotation)
            self.run(rotationForever)
        }
    }
}
