//
//  Atles.swift
//  Dafeiji
//
//  Created by 陈凯 on 12/10/2016.
//  Copyright © 2016 陈凯. All rights reserved.
//

import SpriteKit

enum TextureType: Int {
    case background = 1
    case bullet = 2
    case playerPlane = 3
    case foePlaneSmall = 4
    case foePlaneMedium = 5
    case foePlaneBig = 6
}

class Atlas: SKTextureAtlas {
    
    static let atlasInstance = Atlas.init(named: "gameArts-hd")
    
    class func texture(with type: TextureType) -> SKTexture {
        switch type {
        case .background:
            return atlasInstance.textureNamed("background_2.png")
        case .bullet:
            return atlasInstance.textureNamed("bullet1.png")
        case .playerPlane:
            return atlasInstance.textureNamed("hero_fly_1.png")
        // TODO: - refine file name
        case .foePlaneSmall:
            return atlasInstance.textureNamed("enemy1_fly_1.png")
        case .foePlaneMedium:
            return atlasInstance.textureNamed("enemy3_fly_1.png")
        case .foePlaneBig:
            return atlasInstance.textureNamed("enemy2_fly_1.png")
        }
    }
    
    class func playerPlaneTexture(with index: Int) -> SKTexture {
        return atlasInstance.textureNamed("hero_fly_\(index).png")
    }
    
    class func playerPlaneBlowupTexture(with index: Int) -> SKTexture {
        return atlasInstance.textureNamed("hero_blowup_\(index).png")
    }
    
    class func hitTexture(with planeType: Int, animationIndex: Int) -> SKTexture {
        return atlasInstance.textureNamed("enemy\(planeType)_hit_\(animationIndex).png")
    }
    
    class func blowupTexture(with planeType: Int, animationIndex: Int) -> SKTexture {
        return atlasInstance.textureNamed("enemy\(planeType)_blowup_\(animationIndex).png")
    }
    
    class func hitAction(with foePlaneType: FoePlaneType) -> SKAction? {
        // TODO: - refine file name
        switch foePlaneType {
        case .big:
            return SKAction.sequence([SKAction.setTexture(self.hitTexture(with: 2, animationIndex: 1)),
                                      SKAction.setTexture(self.texture(with: TextureType.foePlaneBig))])
        case .medium:
            var textures = [SKAction]()
            for i in 1..<3 {
                textures.append(SKAction.setTexture(self.hitTexture(with: 3, animationIndex: i)))
            }
            return SKAction.sequence(textures)
        case .small:
            break
        }
        
        return nil
    }
    
    class func blowupAction(with foePlaneType: FoePlaneType) -> SKAction? {
        var textures = [SKTexture]()
        switch foePlaneType {
        case .big:
            for i in 1...7 {
                textures.append(self.blowupTexture(with: 2, animationIndex: i))
            }
        case .medium:
            for i in 1...4 {
                textures.append(self.blowupTexture(with: 3, animationIndex: i))
            }
        case .small:
            for i in 1...4 {
                textures.append(self.blowupTexture(with: 1, animationIndex: i))
            }
        }
        return SKAction.sequence([SKAction.animate(with: textures, timePerFrame: 0.1), SKAction.removeFromParent()])
    }
    
    class func playerPlaneAction() -> SKAction {
        var textures = [SKTexture]()
        for i in 1..<3 {
            textures.append(self.playerPlaneTexture(with: i))
        }
        return SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
    }
    
    class func playerPlaneBlowupAction() -> SKAction {
        var textures = [SKTexture]()
        for i in 1..<5 {
            textures.append(self.playerPlaneBlowupTexture(with: i))
        }
        return SKAction.sequence([SKAction.animate(with: textures, timePerFrame: 0.1), SKAction.removeFromParent()])
    }
}
