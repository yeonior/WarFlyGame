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

        setHeader(withName: "game over", andBackground: "header_background")
        
        let titles = ["restart", "options", "menu"]
        for (index, title) in titles.enumerated(){
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.setScale(0.8)
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(index * 70) + 50)
            button.name = title
            button.label.name = title
            addChild(button)
        }
        
        if !gameoverMusicStatus {
            if gameSettings.isMusic {
                run(gameoverMusicAction)
                gameoverMusicStatus = true
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
            
        } else if node.name == "menu" {
            
            sceneManager.gameScene = nil
            let transition = SKTransition.crossFade(withDuration: 1)
            let menuScene = MenuScene(size: self.size)
            menuScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(menuScene, transition: transition)
        }
    }
}
