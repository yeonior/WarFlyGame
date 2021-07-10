//
//  GameScene.swift
//  WarFlyGame
//
//  Created by ruslan on 16.06.2021.
//

import SpriteKit
import GameplayKit

class GameScene: ParentScene {
    
    fileprivate var player: PlayerPlane!
    fileprivate let hud = HUD()
    fileprivate let screenSize = UIScreen.main.bounds.size
    fileprivate let sprites = ["sprite", "bluePowerUp", "greenPowerUp"]
    fileprivate var backgroundMusic: SKAudioNode!
    fileprivate var lives = 3 {
        didSet {
            
            // updating displaying lives
            updateLives(withNumber: lives)
            
            if lives == 0 {
                
                // saving scores
                gameSettings.currentScore = hud.score
                gameSettings.saveScores()
                
                // scene transition
                sceneTransition(to: GameOverScene(size: self.size),
                                withBackScene: false)
            }
        }
    }
    
    // MARK: - Methods
    
    override func didMove(to view: SKView) {
        
        gameSettings.loadGameSettings()
        playMusic()
        
        self.scene?.isPaused = false
        guard sceneManager.gameScene == nil else { return }
        sceneManager.gameScene = self
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        configureStartScene()
        createHUD()
        startCountdown()
        spawnIslands()
        spawnClouds()
        player.performFly()
        spawnEnemies()
        spawnPowerUp()
    }
      
    // HUD creation
    fileprivate func createHUD() {
        
        self.addChild(hud)
        hud.configureUI(screenSize: screenSize)
    }

    // scene configuration
    fileprivate func configureStartScene() {
        
        // screen settings
        let screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        let background = Background.populateBackground(at: screenCenterPoint)
        background.size = self.size
        self.addChild(background)
        
        // sprites populating
        let island1 = Island.populate(at: CGPoint(x: Int(screenSize.width) / 2 - 100,
                                                  y: Int(screenSize.height) / 2 + 100))
        self.addChild(island1)
        
        let island2 = Island.populate(at: CGPoint(x: Int(screenSize.width) / 2 + 70,
                                                  y: Int(screenSize.height) / 2 + 300))
        self.addChild(island2)
        
        let cloud = Cloud.populate(at: CGPoint(x: Int(screenSize.width) / 2 + 40,
                                               y: Int(screenSize.height) / 2 - 200))
        self.addChild(cloud)
        
        player = PlayerPlane.populate(at: CGPoint(x: screenSize.width / 2,
                                                  y: 100))
        self.addChild(player)
    }
    
    // countdowning
    fileprivate func startCountdown() {
        
        let waitAction = SKAction.wait(forDuration: 1.0)
        let countAction = SKAction.run {
            self.hud.count -= 1
        }
        let actionsSequence = SKAction.sequence([waitAction, countAction])
        let fullAction = SKAction.repeat(actionsSequence, count: 5)
        run(fullAction)
    }
        
    // updating displaying lives
    fileprivate func updateLives(withNumber: Int) {
        
        let array = [hud.life3, hud.life2, hud.life1]
        let array1 = array[0..<withNumber]
        let array2 = array.filter { !array1.contains($0) }
        
        for i in array1 {
            i.isHidden = false
        }
        for i in array2 {
            i.isHidden = true
        }
    }
    
    // playing music
    fileprivate func playMusic() {
        
        if gameSettings.isMusic {
            if backgroundMusic == nil {
                if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a") {
                    backgroundMusic = SKAudioNode(url: musicURL)
                    self.addChild(backgroundMusic)
                }
            }
        } else if backgroundMusic != nil {
            backgroundMusic.removeFromParent()
            backgroundMusic = nil
        }
    }
    
    // different sprites spawning
    fileprivate func spawnIslands() {
        
        let waitAction = SKAction.wait(forDuration: 4)
        let spawnAction = SKAction.run { [unowned self] in
            let island = Island.populate(at: nil)
            self.addChild(island)
        }
        let actionsSequence = SKAction.sequence([waitAction, spawnAction])
        let actionsSequenceForever = SKAction.repeatForever(actionsSequence)
        run(actionsSequenceForever)
    }
    
    fileprivate func spawnClouds() {
        
        let waitAction = SKAction.wait(forDuration: 2)
        let spawnAction = SKAction.run { [unowned self] in
            let cloud = Cloud.populate(at: nil)
            self.addChild(cloud)
        }
        let actionsSequence = SKAction.sequence([waitAction, spawnAction])
        let actionsSequenceForever = SKAction.repeatForever(actionsSequence)
        run(actionsSequenceForever)
    }
    
    fileprivate func spawnPowerUp() {
        
        let randomDuration = Double(arc4random_uniform(15) + 10)
        let waitAction = SKAction.wait(forDuration: randomDuration)
        let spawnAction = SKAction.run { [unowned self] in
            let randomNumber = Int(arc4random_uniform(2))
            let powerUp = randomNumber == 1 ? BluePowerUp() : GreenPowerUp()
            let randomPositionX = arc4random_uniform(UInt32(self.size.width - 30))
            powerUp.position = CGPoint(x: CGFloat(randomPositionX), y: self.size.height + 100)
            powerUp.startMovement()
            self.addChild(powerUp)
        }
        let actionsSequence = SKAction.sequence([waitAction, spawnAction])
        let actionsSequenceForever = SKAction.repeatForever(actionsSequence)
        run(actionsSequenceForever)
    }
    
    fileprivate func spawnGroupOfEnemies(with count: Int) {
        
        let enemyTextureAtlas1 = Assets.shared.enemy_1Atlas
        let enemyTextureAtlas2 = Assets.shared.enemy_2Atlas
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in
            
            let randomNumber = Int(arc4random_uniform(2))
            let arrayofAtlases = [enemyTextureAtlas1, enemyTextureAtlas2]
            let textureAtlas = arrayofAtlases[randomNumber]
            let waitAction = SKAction.wait(forDuration: 1)
            let spawnAction = SKAction.run { [unowned self] in
                let textureNamesSorted = textureAtlas.textureNames.sorted()
                let texture = textureAtlas.textureNamed(textureNamesSorted[12])
                let enemy = Enemy(enemyTexture: texture)
                enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 50)
                enemy.flySpiral()
                self.addChild(enemy)
            }
            let actionsSequence = SKAction.sequence([waitAction, spawnAction])
            let actionsSequenceForever = SKAction.repeat(actionsSequence, count: count)
            run(actionsSequenceForever)
        }
    }
    
    fileprivate func spawnEnemies() {
        
        let waitAction = SKAction.wait(forDuration: 5)
        let spawnAction = SKAction.run { [unowned self] in
            self.spawnGroupOfEnemies(with: 3)
        }
        let actionsSequence = SKAction.sequence([waitAction, spawnAction])
        let actionsSequenceForever = SKAction.repeatForever(actionsSequence)
        run(actionsSequenceForever)
    }
    
    // player fire action
    fileprivate func playerFire() {
        
        let shot = YellowAmmo()
        shot.position = self.player.position
        shot.startMovement()
        addChild(shot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // location and node determination
        let location = touches.first?.location(in: self)
        let node = self.atPoint(location!)
        
        // actions
        if node.name == "pause" {
            sceneManager.gameScene = self
            self.scene?.isPaused = true
            sceneTransition(to: PauseScene(size: self.size),
                            withBackScene: false)
        } else {
            if hud.shots > 0 {
                playerFire()
                hud.shots -= 1
            }
        }
    }
    
    override func didSimulatePhysics() {
        
        player.checkPosition()
        
        // deleting sprites
        for i in sprites {
            enumerateChildNodes(withName: i) { node, _ in
                if node.position.y <= -200 {
                    node.removeFromParent()
                }
            }
        }

        enumerateChildNodes(withName: "shotSprite") { [unowned self] node, _ in
            if node.position.y >= self.size.height + 100 {
                node.removeFromParent()
            }
        }
    }
}

// MARK: - Extensions
extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // contact actions with sounds and animations
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
                    
                    lives -= 1 // action
                    
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
                    
                    lives -= 1 // action
                    
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
            
        case [.player, .powerUp]:
            
            if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
                
                if contact.bodyA.node?.name == "bluePowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    
                    hud.shots += 5 // action
                    
                    player.bluePowerUp()
                    if gameSettings.isSound {
                        self.run(SKAction.playSoundFileNamed("powerupSound", waitForCompletion: false))
                    }
                } else if contact.bodyB.node?.name == "bluePowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    
                    hud.shots += 5 // action
                    
                    player.bluePowerUp()
                    if gameSettings.isSound {
                        self.run(SKAction.playSoundFileNamed("powerupSound", waitForCompletion: false))
                    }
                }
                
                if contact.bodyA.node?.name == "greenPowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    
                    if lives < 3 { lives += 1 } // action
                    
                    player.greenPowerUp()
                    if gameSettings.isSound {
                        self.run(SKAction.playSoundFileNamed("powerupSound", waitForCompletion: false))
                    }
                } else if contact.bodyB.node?.name == "greenPowerUp" {
                    contact.bodyB.node?.removeFromParent()
                    
                    if lives < 3 { lives += 1 } // action
                    
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
                
                hud.score += 5 // action
                
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
    }
}
