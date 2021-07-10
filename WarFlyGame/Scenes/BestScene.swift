//
//  BestScene.swift
//  WarFlyGame
//
//  Created by ruslan on 04.07.2021.
//

import SpriteKit

class BestScene: ParentScene {
    
    var places: [Int]!
        
    override func didMove(to view: SKView) {
                
        // header setting
        setHeader(withTitle: "best", andBackground: "header_background")
        
        // buttons setting
        setBackButton(withOffsetY: -160)

        // showing top scores
        gameSettings.loadScores()
        places = gameSettings.highscore
        showTopScores()
    }
    
    // showing top scores
    fileprivate func showTopScores() {
        
        for (index, value) in places.enumerated() {
            let label = SKLabelNode(text: "\(index + 1). " + value.description)
            label.fontColor = UIColor(red: 219 / 255, green: 226 / 255, blue: 215 / 255, alpha: 1.0)
            label.fontName = "AmericanTypewriter-Bold"
            label.fontSize = 30
            label.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(index * 60) + 50)
            label.horizontalAlignmentMode = .center
            addChild(label)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // location and node determination
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        // actions
        if node.name == "back" {
            backSceneTransition()
        }
    }
}
