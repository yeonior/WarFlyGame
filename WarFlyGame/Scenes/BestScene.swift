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
        
        gameSettings.loadScores()
        places = gameSettings.highscore
        
        // header
        setHeader(withName: "best", andBackground: "header_background")
        
        // back button
        let back = ButtonNode(titled: "back", backgroundName: "button_background")
        back.setScale(0.8)
        back.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 160)
        back.name = "back"
        back.label.name = "back"
        addChild(back)
        
        // MARK: - ***
        // top places numbering
//        for index in 0...2 {
//
//            let label = SKLabelNode(text: "\(index + 1).")
//            label.fontColor = UIColor(red: 219 / 255, green: 226 / 255, blue: 215 / 255, alpha: 1.0)
//            label.fontName = "AmericanTypewriter-Bold"
//            label.fontSize = 30
//            label.position = CGPoint(x: self.frame.midX - 60, y: self.frame.midY - CGFloat(index * 60) + 50)
//            addChild(label)
//        }

        // top scores
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
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "back" {
            
            let transition = SKTransition.crossFade(withDuration: 1)
            guard let backScene = backScene else { return }
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
        }
    }
}
