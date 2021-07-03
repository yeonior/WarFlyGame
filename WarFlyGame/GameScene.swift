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
    
    let scoreBackground = SKSpriteNode(imageNamed: "scores")
    let scoreLabel = SKLabelNode(text: "10000")
    let menuButton = SKSpriteNode(imageNamed: "menu")
    let life1 = SKSpriteNode(imageNamed: "life")
    let life2 = SKSpriteNode(imageNamed: "life")
    let life3 = SKSpriteNode(imageNamed: "life")
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        configureStartScene()
        spawnIslands()
        spawnClouds()
        player.performFly()
        spawnPowerUp()
        spawnEnemies()
        configureUI()
    }
    
    fileprivate func configureUI() {
        
        scoreBackground.setScale(0.6)
        scoreBackground.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        scoreBackground.position = CGPoint(x: 10, y: self.size.height - 10)
        scoreBackground.zPosition = 99
        addChild(scoreBackground)
        
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: 188, y: -36)
        scoreLabel.zPosition = 100
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 30
        scoreBackground.addChild(scoreLabel)
        
        menuButton.setScale(0.8)
        menuButton.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        menuButton.position = CGPoint(x: self.size.width - 10, y: self.size.height - 10)
        menuButton.zPosition = 100
        addChild(menuButton)
        
        let lifes = [life1, life2, life3]
        for (index, life) in lifes.enumerated() {
            life.position = CGPoint(x: self.size.width - CGFloat(index + 1) * (life.size.width + 3) - 7, y: 20)
            life.zPosition = 100
            life.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            addChild(life)
        }
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
    
    fileprivate func playerFire() {
        
        let shot = YellowAmmo()
        shot.position = self.player.position
        shot.startMovement()
        addChild(shot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerFire()
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
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        switch contactCategory {
        case [.player, .enemy]:
            print("player vs enemy")
        case [.player, .powerUp]:
            print("player vs powerup")
        case [.enemy, .shot]:
            print("enemy vs shot")
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
