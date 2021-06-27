//
//  Enemy.swift
//  WarFlyGame
//
//  Created by ruslan on 26.06.2021.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    static var textureAtlas: SKTextureAtlas?
    var enemyTexture: SKTexture!
    
    init(enemyTexture: SKTexture) {
        let texture = enemyTexture
        super.init(texture: texture, color: .clear, size: CGSize(width: 221, height: 204))
        self.xScale = 0.5
        self.yScale = -0.5
        self.zPosition = 20
        self.name = "sprite"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flySpiral() {
        
        let timeHorizontal = 3.0
        let timeVertical = 5.0
        let screenSize = UIScreen.main.bounds.size
        let moveLeft = SKAction.moveTo(x: 50, duration: timeHorizontal)
        moveLeft.timingMode = .easeInEaseOut
        let moveRight = SKAction.moveTo(x: screenSize.width - 50, duration: timeHorizontal)
        moveRight.timingMode = .easeInEaseOut
        
        let randomNumber = Int(arc4random_uniform(2))
                
        let asideMovementSequence = randomNumber == EnemyDirection.left.rawValue ? SKAction.sequence([moveLeft, moveRight]) : SKAction.sequence([moveRight, moveLeft])
        let foreverAsideMovement = SKAction.repeatForever(asideMovementSequence)
        
        let forwardMovement = SKAction.moveTo(y: -300, duration: timeVertical)
        let groupMovement = SKAction.group([foreverAsideMovement, forwardMovement])
        
        self.run(groupMovement)        
    }
}

enum EnemyDirection: Int {
    case left = 0
    case right
}
