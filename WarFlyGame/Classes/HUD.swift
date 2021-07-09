//
//  HUD.swift
//  WarFlyGame
//
//  Created by ruslan on 03.07.2021.
//

import SpriteKit

class HUD: SKNode {
    
    let scoreIcon = SKSpriteNode(imageNamed: "scores")
    let scoreLabel = SKLabelNode(text: "0")
    let shotsIcon = SKSpriteNode(imageNamed: "shots")
    let shotsLabel = SKLabelNode(text: "10")
    let menuButton = SKSpriteNode(imageNamed: "menu")
    let life1 = SKSpriteNode(imageNamed: "life")
    let life2 = SKSpriteNode(imageNamed: "life")
    let life3 = SKSpriteNode(imageNamed: "life")
    
    var score = 0 {
        didSet { scoreLabel.text = score.description }
    }
    
    var shots = 10 {
        didSet { shotsLabel.text = shots.description }
    }
    
    func configureUI(screenSize: CGSize) {
        
        scoreIcon.setScale(0.6)
        scoreIcon.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        scoreIcon.position = CGPoint(x: 10, y: screenSize.height - 10)
        scoreIcon.zPosition = 99
        addChild(scoreIcon)
        
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: 188, y: -36)
        scoreLabel.zPosition = 100
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 30
        scoreIcon.addChild(scoreLabel)
        
        shotsIcon.setScale(0.7)
        shotsIcon.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        shotsIcon.position = CGPoint(x: 10, y: 20)
        shotsIcon.zPosition = 99
        addChild(shotsIcon)
        
        shotsLabel.horizontalAlignmentMode = .left
        shotsLabel.verticalAlignmentMode = .center
        shotsLabel.position = CGPoint(x: 47, y: 35)
        shotsLabel.zPosition = 100
        shotsLabel.fontName = "AmericanTypewriter-Bold"
        shotsLabel.fontSize = 24
        addChild(shotsLabel)
        
        menuButton.setScale(0.8)
        menuButton.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        menuButton.position = CGPoint(x: screenSize.width - 10, y: screenSize.height - 10)
        menuButton.zPosition = 100
        menuButton.name = "pause"
        addChild(menuButton)
        
        let lifes = [life1, life2, life3]
        for (index, life) in lifes.enumerated() {
            life.position = CGPoint(x: screenSize.width - CGFloat(index + 1) * (life.size.width + 3) - 7, y: 20)
            life.zPosition = 100
            life.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            addChild(life)
        }
    }
}
