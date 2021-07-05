//
//  GreenPowerUp.swift
//  WarFlyGame
//
//  Created by ruslan on 26.06.2021.
//

import SpriteKit

class GreenPowerUp: PowerUp {
    
    init() {
        
        let textureAtlas = Assets.shared.greenPowerUpAtlas
        super.init(textureAtlas: textureAtlas)
        self.name = "greenPowerUp"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
