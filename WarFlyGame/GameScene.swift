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
        spawnPowerUp()
        spawnEnemies()
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
    
    fileprivate func spawnPowerUp() {
        
        let powerUp = PowerUp()
        powerUp.performRotation()
        powerUp.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(powerUp)
    }
    
    fileprivate func spawnGroupOfEnemies() {
        
        let spawnEnemyWait = SKAction.wait(forDuration: 1)
        let spawnEnemyAction = SKAction.run { [unowned self] in
            let enemyTextureAtlas1 = SKTextureAtlas(named: "Enemy_1")
            let enemyTextureAtlas2 = SKTextureAtlas(named: "Enemy_2")
            SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in
                
                let randomNumber = Int(arc4random_uniform(2))
                let arrayofAtlases = [enemyTextureAtlas1, enemyTextureAtlas2]
                let textureAtlas = arrayofAtlases[randomNumber]
                let textureNamesSorted = textureAtlas.textureNames.sorted()
                let enemyTexture = textureAtlas.textureNamed(textureNamesSorted[12])
                
                let enemy = Enemy(enemyTexture: enemyTexture)
                enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 50)
                enemy.flySpiral()
                self.addChild(enemy)
            }
        }
        
        let spawnEmemySequence = SKAction.sequence([spawnEnemyWait, spawnEnemyAction])
        let spawnEnemyRepeating = SKAction.repeat(spawnEmemySequence, count: 3)
        
        run(spawnEnemyRepeating)
    }
    
    fileprivate func spawnEnemies() {
        
        let spawnEnemiesWait = SKAction.wait(forDuration: 5)
        let spawnEmemiesAction = SKAction.run { [unowned self] in
            self.spawnGroupOfEnemies()
        }
        
        let spawnEmemiesSequence = SKAction.sequence([spawnEmemiesAction, spawnEnemiesWait])
        let spawnEnemiesRepeating = SKAction.repeatForever(spawnEmemiesSequence)
        
        run(spawnEnemiesRepeating)
    }
    
    override func didSimulatePhysics() {
        
        player.checkPosition()
        
        // deleting sprites
        enumerateChildNodes(withName: "sprite") { node, _ in
            if node.position.y < -200 {
                node.removeFromParent()
            }
        }
    }
}
