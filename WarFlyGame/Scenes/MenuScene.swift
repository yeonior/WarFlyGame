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
        
        // header
        setHeader(withTitle: nil, andBackground: "header1")
        
        // buttons
        let titles = ["play", "options", "best"]
        for (index, title) in titles.enumerated(){
            
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.setScale(0.8)
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(index * 70))
            button.name = title
            button.label.name = title
            addChild(button)
        }
    }
     
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // location and node determination
        let location = touches.first?.location(in: self)
        let node = self.atPoint(location!)
        
        // scene determination
        if node.name == "play" {
            sceneTransition(to: GameScene(size: self.size),
                            with: .crossFade(withDuration: 1),
                            andBackScene: false)
            
        } else if node.name == "options" {
            sceneTransition(to: OptionsScene(size: self.size),
                            with: .crossFade(withDuration: 1),
                            andBackScene: true)
            
        } else if node.name == "best" {
            sceneTransition(to: BestScene(size: self.size),
                            with: .crossFade(withDuration: 1),
                            andBackScene: true)
        }
    }
}
