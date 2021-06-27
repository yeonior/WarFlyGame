//
//  YellowShot.swift
//  WarFlyGame
//
//  Created by ruslan on 27.06.2021.
//

import SpriteKit

class YellowShot: Shot {
    
    init() {
        
        let textureAtlas = SKTextureAtlas(named: "YellowAmmo")
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
