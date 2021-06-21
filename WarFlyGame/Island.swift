//
//  Island.swift
//  WarFlyGame
//
//  Created by ruslan on 17.06.2021.
//

import SpriteKit
import GameplayKit

final class Island: SKSpriteNode, GameBackgroundSpriteable {
    
    // creation
    static func populate(at point: CGPoint?) -> Island {
        
        let islandImageName = configureName()
        let island = Island(imageNamed: islandImageName)
        island.setScale(randomScaleFactor)
        island.position = point ?? randomPoint()
        island.zPosition = 1
        island.name = "backgroundSprite"
        island.run(rotateForRandomAngle())
        island.run(move(from: island.position))
        
        return island
    }
    
    // image
    fileprivate static func configureName() -> String {
        
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
        let randomNumber = distribution.nextInt()
        let imageName = "is" + "\(randomNumber)"
        
        return imageName
    }
    
    // scaling
    fileprivate static var randomScaleFactor: CGFloat {
        
        let distribution = GKRandomDistribution(lowestValue: 4, highestValue: 10)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }
    
    // rotating
    fileprivate static func rotateForRandomAngle() -> SKAction {
        
        let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
        let randomNumber = CGFloat(distribution.nextInt())
        
        return SKAction.rotate(byAngle: randomNumber * CGFloat(Double.pi / 180), duration: 0)
    }
    
    // movement
    fileprivate static func move(from point: CGPoint) -> SKAction {
        
        let movePoint = CGPoint(x: point.x, y: -300)
        let moveDistance = point.y + 300
        let movementSpeed: CGFloat = 80.0
        let duration = moveDistance / movementSpeed
        
        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
    }
}
