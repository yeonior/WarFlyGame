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
    
    // header setting
    func setHeader(withTitle title: String?, andBackground backgroundName: String) {
        
        let header = ButtonNode(titled: title, backgroundName: backgroundName)
        header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        self.addChild(header)
    }
    
    // buttons setting
    func setButtons(from array: [String], withOffsetY offsetY: CGFloat) {
        
        for (index, title) in array.enumerated(){
            let button = ButtonNode(titled: title, backgroundName: "button_background")
            button.setScale(0.8)
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(index * 70) + offsetY)
            button.name = title
            button.label.name = title
            addChild(button)
        }
    }
    
    // back button setting
    func setBackButton(withOffsetY offsetY: CGFloat) {
        
        let back = ButtonNode(titled: "back", backgroundName: "button_background")
        back.setScale(0.8)
        back.position = CGPoint(x: self.frame.midX, y: self.frame.midY + offsetY)
        back.name = "back"
        back.label.name = "back"
        addChild(back)
    }
    
    // scene transition
    func sceneTransition(to scene: ParentScene, withBackScene backScene: Bool) {

        let scene = scene
        scene.scaleMode = .aspectFill
        let transition = SKTransition.crossFade(withDuration: 0.5)
        if backScene {
            scene.backScene = self
        }
        self.scene!.view?.presentScene(scene, transition: transition)
    }
    
    // back scene transition
    func backSceneTransition() {
        
        let transition = SKTransition.crossFade(withDuration: 0.5)
        guard let backScene = backScene else { return }
        backScene.scaleMode = .aspectFill
        self.scene!.view?.presentScene(backScene, transition: transition)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
