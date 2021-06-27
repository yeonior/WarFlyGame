//
//  Assets.swift
//  WarFlyGame
//
//  Created by ruslan on 27.06.2021.
//

import SpriteKit

class Assets {
    
    static let shared = Assets()
    let yellowAmmoAtlas = SKTextureAtlas(named: "YellowAmmo")
    let enemy_1Atlas = SKTextureAtlas(named: "Enemy_1")
    let enemy_2Atlas = SKTextureAtlas(named: "Enemy_2")
    let bluePowerUpAtlas = SKTextureAtlas(named: "BluePowerUp")
    let greenPowerUpAtlas = SKTextureAtlas(named: "GreenPowerUp")
    let playerPlaneAtlas = SKTextureAtlas(named: "PlayerPlane")
    
    func preloadAssets() {
        yellowAmmoAtlas.preload { print("yellowAmmoAtlas is preloaded") }
        enemy_1Atlas.preload { print("enemy_1Atlas is preloaded") }
        enemy_2Atlas.preload { print("enemy_2Atlas is preloaded") }
        bluePowerUpAtlas.preload { print("bluePowerUpAtlas is preloaded") }
        greenPowerUpAtlas.preload { print("greenPowerUpAtlas is preloaded") }
        playerPlaneAtlas.preload { print("playerPlaneAtlas is preloaded") }
    }
}
