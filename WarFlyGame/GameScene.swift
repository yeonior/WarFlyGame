//
//  GameScene.swift
//  WarFlyGame
//
//  Created by ruslan on 16.06.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: PlayerPlane!
    
    override func didMove(to view: SKView) {
        
        configureStartScene()
        spawnIslands()
        spawnClouds()
        player.performFly()
        
        let powerUp = PowerUp()
        powerUp.performRotation()
        powerUp.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(powerUp)
    }
    
    fileprivate func configureStartScene() {
        
        // screen settings
        let screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        let background = Background.populateBackground(at: screenCenterPoint)
        background.size = self.size
        self.addChild(background)
        
        // screen size
        let screen = UIScreen.main.bounds
        
        // sprites
        let island1 = Island.populate(at: CGPoint(x: Int(screen.size.width) / 2 - 100, y: Int(screen.size.height) / 2 + 100))
        self.addChild(island1)
        let island2 = Island.populate(at: CGPoint(x: Int(screen.size.width) / 2 + 70, y: Int(screen.size.height) / 2 + 300))
        self.addChild(island2)
        let cloud = Cloud.populate(at: CGPoint(x: Int(screen.size.width) / 2 + 40, y: Int(screen.size.height) / 2 - 200))
        self.addChild(cloud)
        
        player = PlayerPlane.populate(at: CGPoint(x: screen.size.width / 2, y: 100))
        self.addChild(player)
    }
    
    fileprivate func spawnIslands() {
        
        let spawnIslandWait = SKAction.wait(forDuration: 4)
        let spawnIslandAction = SKAction.run {
            let island = Island.populate(at: nil)
            self.addChild(island)
        }
        
        let spawnIslandSequence = SKAction.sequence([spawnIslandWait, spawnIslandAction])
        let spawnIslandForever = SKAction.repeatForever(spawnIslandSequence)
        
        run(spawnIslandForever)
    }
    
    fileprivate func spawnClouds() {
        
        let spawnCloudWait = SKAction.wait(forDuration: 2)
        let spawnCloudAction = SKAction.run {
            let cloud = Cloud.populate(at: nil)
            self.addChild(cloud)
        }
        
        let spawnCloudSequence = SKAction.sequence([spawnCloudWait, spawnCloudAction])
        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
        
        run(spawnCloudForever)
    }
    
    override func didSimulatePhysics() {
        
        player.checkPosition()
        
        enumerateChildNodes(withName: "backgroundSprite") { node, _ in
            if node.position.y < -200 {
                node.removeFromParent()
            }
        }
    }
}
