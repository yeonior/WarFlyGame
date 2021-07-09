//
//  ParentScene.swift
//  WarFlyGame
//
//  Created by ruslan on 04.07.2021.
//

import SpriteKit

class ParentScene: SKScene {
    
    let gameSettings = GameSettings()
    let sceneManager = SceneManager.shared
    var backScene: SKScene?
    
    // header on scene
    func setHeader(withTitle title: String?, andBackground backgroundName: String) {
        
        let header = ButtonNode(titled: title, backgroundName: backgroundName)
        header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        self.addChild(header)
    }
    
    // scene transition
    func sceneTransition(to scene: ParentScene, with transition: SKTransition, andBackScene backScene: Bool) {

        let scene = scene
        scene.scaleMode = .aspectFill
        if backScene {
            scene.backScene = self
        }
        self.scene!.view?.presentScene(scene, transition: transition)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
