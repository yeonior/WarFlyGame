//
//  PauseScene.swift
//  WarFlyGame
//
//  Created by ruslan on 03.07.2021.
//

import SpriteKit

class PauseScene: ParentScene {

    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1)
        setHeader(withName: "pause", andBackground: "header_background")
        
        let titles = ["resume", "restart", "options"]
        for (index, title) in titles.enumerated(){
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(index * 90))
            button.name = title
            button.label.name = title
            addChild(button)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let gameScene = sceneManager.gameScene {
            if !gameScene.isPaused {
                gameScene.isPaused = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        let node = self.atPoint(location!)
        
        if node.name == "restart" {
            sceneManager.gameScene = nil
            let transition = SKTransition.crossFade(withDuration: 1)
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
            
        } else if node.name == "options" {
            
            let transition = SKTransition.crossFade(withDuration: 1)
            let optionsScene = OptionsScene(size: self.size)
            optionsScene.backScene = self
            optionsScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(optionsScene, transition: transition)
            
        } else if node.name == "resume" {
            
            let transition = SKTransition.crossFade(withDuration: 1)
            guard let gameScene = sceneManager.gameScene else { return }
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
    }
}
