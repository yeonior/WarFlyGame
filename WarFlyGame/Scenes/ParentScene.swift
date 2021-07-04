//
//  ParentScene.swift
//  WarFlyGame
//
//  Created by ruslan on 04.07.2021.
//

import SpriteKit

class ParentScene: SKScene {
    
    let sceneManager = SceneManager.shared
    var backScene: SKScene?
    
    func setHeader(withName name: String?, andBackground backgroundName: String) {
        
        let header = ButtonNode(titled: name, backgroundName: backgroundName)
        header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        self.addChild(header)
    }
}
