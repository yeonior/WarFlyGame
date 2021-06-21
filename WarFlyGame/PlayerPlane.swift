//
//  PlayerPlane.swift
//  WarFlyGame
//
//  Created by ruslan on 21.06.2021.
//

import SpriteKit

class PlayerPlane: SKSpriteNode {
    
    static func populate(at point: CGPoint) -> SKSpriteNode {
        
        let playerPlaneTexture = SKTexture(imageNamed: "airplane_3ver2_13")
        let playerPlane = SKSpriteNode(texture: playerPlaneTexture)
        playerPlane.setScale(0.5)
        playerPlane.position = point
        playerPlane.zPosition = 20
        
        return playerPlane
    }
}
