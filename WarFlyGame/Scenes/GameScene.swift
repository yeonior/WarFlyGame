//
//  GameScene.swift
//  WarFlyGame
//
//  Created by ruslan on 16.06.2021.
//

import SpriteKit
import GameplayKit

class GameScene: ParentScene {
    
    let gameSettings = GameSettings()
    var backgroundMusic: SKAudioNode!
    
    fileprivate var player: PlayerPlane!
    fileprivate let hud = HUD()
    fileprivate let screenSize = UIScreen.main.bounds.size
    fileprivate var lives = 3 {
        didSet {
            switch lives {
            case 3:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = false
            case 2:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = true
            case 1:
                hud.life1.isHidden = false
                hud.life2.isHidden = true
                hud.life3.isHidden = true
            case 0:
                hud.life1.isHidden = true
                hud.life2.isHidden = true
                hud.life3.isHidden = true
            default:
                break
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        gameSettings.loadGameSettings()
        
        if gameSettings.isMusic {
            if backgroundMusic == nil {
                if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a") {
                    backgroundMusic = SKAudioNode(url: musicURL)
                    addChild(backgroundMusic)
                }
            }
        } else if backgroundMusic != nil {
            backgroundMusic.removeFromParent()
            backgroundMusic = nil
        }
        
        self.scene?.isPaused = false
        
        guard sceneManager.gameScene == nil else { return }
        
        sceneManager.gameScene = self
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        configureStartScene()
        spawnIslands()
        spawnClouds()
        player.performFly()
        spawnPowerUp()
        spawnEnemies()
        createHUD()
    }
    
    fileprivate func createHUD() {
        addChild(hud)
        hud.configureUI(screenSize: screenSize)
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
        
        let spawnAction = SKAction.run {
            
            let randomNumber = Int(arc4random_uniform(2))
            let powerUp = randomNumber == 1 ? BluePowerUp() : GreenPowerUp()
            
            let randomPositionX = arc4random_uniform(UInt32(self.size.width - 30))
            powerUp.position = CGPoint(x: CGFloat(randomPositionX), y: self.size.height + 100)
            
            powerUp.startMovement()
            self.addChild(powerUp)
        }
        
        let randomDuration = Double(arc4random_uniform(15) + 10)
        let waitAction = SKAction.wait(forDuration: randomDuration)
        
        let actionsSequence = SKAction.sequence([waitAction, spawnAction])
        let actionsSequenceForever = SKAction.repeatForever(actionsSequence)
        
        run(actionsSequenceForever)
    }
    
    fileprivate func spawnGroupOfEnemies() {
        
        let spawnEnemyWait = SKAction.wait(forDuration: 1)
        let spawnEnemyAction = SKAction.run { [unowned self] in
            let enemyTextureAtlas1 = Assets.shared.enemy_1Atlas
            let enemyTextureAtlas2 = Assets.shared.enemy_2Atlas
            SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in
                
                let randomNumber = Int(arc4random_uniform(2))
                let arrayofAtlases = [enemyTextureAtlas1, enemyTextureAtlas2]
                let textureAtlas = arrayofAtlases[randomNumber]
                let textureNamesSorted = textureAtlas.textureNames.sorted()
                let enemyTexture = textureAtlas.textureNamed(textureNamesSorted[12])
                
                let enemy = Enemy(enemyTexture: enemyTexture)
                enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 50)
                enemy.flySpiral()
                addChild(enemy)
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
    
    fileprivate func playerFire() {
        
        let shot = YellowAmmo()
        shot.position = self.player.position
        shot.startMovement()
        addChild(shot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first?.location(in: self)
        let node = self.atPoint(location!)
        
        if node.name == "pause" {
            let transition = SKTransition.doorway(withDuration: 1.0)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.scaleMode = .aspectFill
            sceneManager.gameScene = self
            self.scene?.isPaused = true
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        } else {
            playerFire()
        }
    }
    
    override func didSimulatePhysics() {
        
        player.checkPosition()
        
        // deleting sprites
        enumerateChildNodes(withName: "sprite") { node, _ in
            
            if node.position.y <= -200 {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "shotSprite") { node, _ in
            
            if node.position.y >= self.size.height + 100 {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "bluePowerUp") { node, _ in
            
            if node.position.y <= -200 {
                node.removeFromParent()
            }
        }
        
        enumerateChildNodes(withName: "greenPowerUp") { node, _ in
            
            if node.position.y <= -200 {
                node.removeFromParent()
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion")
        let contactPoint = contact.contactPoint
        explosion?.position = contactPoint
        explosion?.zPosition = 25
        let waitForExplosionAction = SKAction.wait(forDuration: 1.0)
        
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        switch contactCategory {
        case [.player, .enemy]:
            
            if contact.bodyA.node?.name == "sprite" {
                if contact.bodyA.node != nil {
                    contact.bodyA.node?.removeFromParent()
                    lives -= 1
                    
                    player.colisionToEnemy()
                    addChild(explosion!)
                    if gameSettings.isSound {
                        self.run(SKAction.playSoundFileNamed("boomSound", waitForCompletion: false))
                    }
                    self.run(waitForExplosionAction) {
                        explosion?.removeFromParent()
                    }
                }
            } else {
                if contact.bodyB.node != nil {
                    contact.bodyB.node?.removeFromParent()
                    lives -= 1
                    
                    player.colisionToEnemy()
                    addChild(explosion!)
                    if gameSettings.isSound {
                        self.run(SKAction.playSoundFileNamed("boomSound", waitForCompletion: false))
                    }
                    self.run(waitForExplosionAction) {
                        explosion?.removeFromParent()
                    }
                }
            }
            
            if lives == 0 {
                let transition = SKTransition.doorsCloseVertical(withDuration: 1)
                let gameOverScene = GameOverScene(size: self.size)
                gameOverScene.scaleMode = .aspectFill
                self.view?.presentScene(gameOverScene, transition: transition)
            }
            
        case [.player, .powerUp]:
            
            if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
                
                if contact.bodyA.node?.name == "bluePowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    lives = 3
                    player.bluePowerUp()
                    if gameSettings.isSound {
                        self.run(SKAction.playSoundFileNamed("powerupSound", waitForCompletion: false))
                    }
                } else if contact.bodyB.node?.name == "bluePowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    lives = 3
                    player.bluePowerUp()
                    if gameSettings.isSound {
                        self.run(SKAction.playSoundFileNamed("powerupSound", waitForCompletion: false))
                    }
                }
                
                if contact.bodyA.node?.name == "greenPowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    player.greenPowerUp()
                    if gameSettings.isSound {
                        self.run(SKAction.playSoundFileNamed("powerupSound", waitForCompletion: false))
                    }
                } else if contact.bodyB.node?.name == "greenPowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    player.greenPowerUp()
                    if gameSettings.isSound {
                        self.run(SKAction.playSoundFileNamed("powerupSound", waitForCompletion: false))
                    }
                }
            }
            
        case [.enemy, .shot]:
            
            if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
                
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                hud.score += 5
                addChild(explosion!)
                if gameSettings.isSound {
                    self.run(SKAction.playSoundFileNamed("hitSound", waitForCompletion: false))
                }
                self.run(waitForExplosionAction) {
                    explosion?.removeFromParent()
                }
            }
            
        default:
            preconditionFailure("Wrong category!")
        }
        
        /* let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        let player = BitMaskCategory.player
        let enemy = BitMaskCategory.enemy
        let powerUp = BitMaskCategory.powerUp
        let shot = BitMaskCategory.shot
        
        if bodyA == player && bodyB == enemy || bodyB == player && bodyA == enemy {
            print("1")
        } else if bodyA == player && bodyB == powerUp || bodyB == player && bodyA == powerUp {
            print("2")
        } else if bodyA == enemy && bodyB == shot || bodyB == enemy && bodyA == shot {
            print("3")
        } */
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
