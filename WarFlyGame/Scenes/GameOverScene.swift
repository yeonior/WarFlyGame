//
//  GameOverScene.swift
//  WarFlyGame
//
//  Created by ruslan on 05.07.2021.
//

import SpriteKit

class GameOverScene: ParentScene {
    
    var gameoverMusicStatus = false
    let gameoverMusicAction = SKAction.playSoundFileNamed("gameoverMusic", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        
        // header setting
        setHeader(withTitle: "game over", andBackground: "header_background")
        
        // buttons setting
        let buttons = ["restart", "options", "menu"]
        setButtons(from: buttons, withOffsetY: 50)
        
        // playing music
        playMusic()
    }
    
    // playing music
    fileprivate func playMusic() {
        if !gameoverMusicStatus {
            if gameSettings.isMusic {
                run(gameoverMusicAction)
                gameoverMusicStatus = true
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
            
        } else if node.name == "menu" {
            sceneManager.gameScene = nil
            sceneTransition(to: MenuScene(size: self.size),
                            withBackScene: false)
        }
    }
}
