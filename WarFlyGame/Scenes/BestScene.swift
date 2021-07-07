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
        
        setHeader(withName: "best", andBackground: "header_background")
        
        let back = ButtonNode(titled: "back", backgroundName: "button_background")
        back.setScale(0.8)
        back.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 160)
        back.name = "back"
        back.label.name = "back"
        addChild(back)
        
        for index in 0...2 {

            let l = SKLabelNode(text: "\(index + 1).")
            l.fontColor = UIColor(red: 219 / 255, green: 226 / 255, blue: 215 / 255, alpha: 1.0)
            l.fontName = "AmericanTypewriter-Bold"
            l.fontSize = 30
            l.position = CGPoint(x: self.frame.midX - 60, y: self.frame.midY - CGFloat(index * 60) + 50)
            addChild(l)
        }
                
        gameSettings.loadScores()
        places = gameSettings.highscore
        print(places.description)

        for (index, value) in places.enumerated() {
            
            let l = SKLabelNode(text: value.description)
            l.fontColor = UIColor(red: 219 / 255, green: 226 / 255, blue: 215 / 255, alpha: 1.0)
            l.fontName = "AmericanTypewriter-Bold"
            l.fontSize = 30
            l.position = CGPoint(x: self.frame.midX - 40, y: self.frame.midY - CGFloat(index * 60) + 50)
            l.horizontalAlignmentMode = .left
            addChild(l)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        let node = self.atPoint(location!)
        
        if node.name == "back" {
            
            let transition = SKTransition.crossFade(withDuration: 1)
            guard let backScene = backScene else { return }
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
        }
    }
}
