//
//  OptionsScene.swift
//  WarFlyGame
//
//  Created by ruslan on 04.07.2021.
//

import SpriteKit

class OptionsScene: ParentScene {
    
    var isMusic: Bool!
    var isSound: Bool!
    
    override func didMove(to view: SKView) {
        
        // loading settings
        isMusic = gameSettings.isMusic
        isSound = gameSettings.isSound
        
        // header setting
        setHeader(withTitle: "options", andBackground: "header_background")
        
        // buttons setting
        setButtons(for: isMusic, withName: "music", andOffsetX: -50)
        setButtons(for: isSound, withName: "sound", andOffsetX: 50)
        setBackButton(withOffsetY: -100)
    }
    
    // buttons setting
    fileprivate func setButtons(for property: Bool, withName name: String, andOffsetX offsetX: CGFloat) {
        
        let backgroundName = property ? name : "no" + name
        let button = ButtonNode(titled: nil, backgroundName: backgroundName)
        button.position = CGPoint(x: self.frame.midX + offsetX, y: self.frame.midY)
        button.name = name
        button.label.isHidden = true
        addChild(button)
    }
    
    // updating button textures
    func update(node: SKSpriteNode, property: Bool) {
        if let name = node.name {
            node.texture = property == true ? SKTexture(imageNamed: name) : SKTexture(imageNamed: "no\(name)")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // location and node determination
        let location = touches.first?.location(in: self)
        let node = self.atPoint(location!)
        
        // actions
        if node.name == "music" {
            isMusic.toggle()
            update(node: node as! SKSpriteNode, property: isMusic)
        } else if node.name == "sound" {
            isSound.toggle()
            update(node: node as! SKSpriteNode, property: isSound)
        } else if node.name == "back" {            
            gameSettings.isMusic = isMusic
            gameSettings.isSound = isSound
            gameSettings.saveGameSettings()
            backSceneTransition()
        }
    }
}
