//
//  PauseScene.swift
//  WarFlyGame
//
//  Created by ruslan on 03.07.2021.
//

import SpriteKit

class PauseScene: ParentScene {

    override func didMove(to view: SKView) {
        
        // header setting
        setHeader(withTitle: "pause", andBackground: "header_background")
        
        // buttons setting
        let buttons = ["resume", "restart", "options", "menu"]
        setButtons(from: buttons, withOffsetY: 50)
    }
    
    // pausing
    override func update(_ currentTime: TimeInterval) {
        if let gameScene = sceneManager.gameScene {
            if !gameScene.isPaused {
                gameScene.isPaused = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // location and node determination
        let location = touches.first?.location(in: self)
        let node = self.atPoint(location!)
        
        // actions
        if node.name == "restart" {
            sceneManager.gameScene = nil
            sceneTransition(to: GameScene(size: self.size),
                            withBackScene: false)
            
        } else if node.name == "options" {
            sceneTransition(to: OptionsScene(size: self.size),
                            withBackScene: true)
            
        } else if node.name == "resume" {
            let transition = SKTransition.crossFade(withDuration: 0.5)
            guard let gameScene = sceneManager.gameScene else { return }
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
            
        } else if node.name == "menu" {
            sceneManager.gameScene = nil
            sceneTransition(to: MenuScene(size: self.size),
                            withBackScene: false)
        }
    }
}
