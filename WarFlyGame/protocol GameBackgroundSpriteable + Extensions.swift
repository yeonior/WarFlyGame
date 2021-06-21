//
//  protocol GameBackgroundSpriteable + Extensions.swift
//  WarFlyGame
//
//  Created by ruslan on 21.06.2021.
//

import SpriteKit
import GameplayKit

protocol GameBackgroundSpriteable {
    static func populate() -> Self
    static func randomPoint() -> CGPoint
}

extension GameBackgroundSpriteable {
    static func randomPoint() -> CGPoint {
        
        let screen = UIScreen.main.bounds
        let distribution = GKRandomDistribution(lowestValue: Int(screen.size.height) + 100, highestValue: Int(screen.size.height) + 200)
        let x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width)))
        let y = CGFloat(distribution.nextInt())
        
        return CGPoint(x: x, y: y)
    }
}
