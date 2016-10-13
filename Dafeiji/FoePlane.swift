//
//  FoePlane.swift
//  Dafeiji
//
//  Created by 陈凯 on 12/10/2016.
//  Copyright © 2016 陈凯. All rights reserved.
//

import SpriteKit

enum FoePlaneType: Int {
    case big = 1
    case medium = 2
    case small = 3
}

class FoePlane: SKSpriteNode {
    
    var hp = 0
    var type = FoePlaneType.small
    
    class func createBigFoePlane() -> FoePlane {
        let foePlane = FoePlane.init(texture: Atlas.texture(with: .foePlaneBig))
        foePlane.hp = 7
        foePlane.type = .big
        foePlane.physicsBody = SKPhysicsBody.init(rectangleOf: foePlane.size)
        return foePlane
    }
    
    class func createMediumFoePlane() -> FoePlane {
        let foePlane = FoePlane.init(texture: Atlas.texture(with: .foePlaneMedium))
        foePlane.hp = 4
        foePlane.type = .medium
        foePlane.physicsBody = SKPhysicsBody.init(rectangleOf: foePlane.size)
        return foePlane
    }
    
    class func createSmallFoePlane() -> FoePlane {
        let foePlane = FoePlane.init(texture: Atlas.texture(with: .foePlaneSmall))
        foePlane.hp = 1
        foePlane.type = .small
        foePlane.physicsBody = SKPhysicsBody.init(rectangleOf: foePlane.size)
        return foePlane
    }
}
