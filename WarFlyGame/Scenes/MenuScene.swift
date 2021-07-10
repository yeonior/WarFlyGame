//
//  MenuScene.swift
//  WarFlyGame
//
//  Created by ruslan on 29.06.2021.
//

import SpriteKit

class MenuScene: ParentScene {
    
    override func didMove(to view: SKView) {
        
        // preloading assets
        if !Assets.shared.isLoaded {
            Assets.shared.preloadAssets()
            Assets.shared.isLoaded = true
        }
        
        // header setting
        setHeader(withTitle: nil, andBackground: "header1")
        
        // buttons setting
        let buttons = ["play", "options", "best"]
        setButtons(from: buttons, withOffsetY: 0)
    }
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // location and node determination
        let location = touches.first?.location(in: self)
        let node = self.atPoint(location!)
        
        // actions
        if node.name == "play" {
            sceneTransition(to: GameScene(size: self.size),
                            withBackScene: false)
            
        } else if node.name == "options" {
            sceneTransition(to: OptionsScene(size: self.size),
                            withBackScene: true)
            
        } else if node.name == "best" {
            sceneTransition(to: BestScene(size: self.size),
                            withBackScene: true)
        }
    }
}
