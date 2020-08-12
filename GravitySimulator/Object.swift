//
//  Object.swift
//  GravitySimulator
//
//  Created by Peter Luo on 2020/7/16.
//

import SpriteKit

class Object: SKShapeNode {
    
    var radius : CGFloat?
    var isCenterObject = false
    
    func distance(from object: Object) -> CGFloat {
        let distance = self.position.distance(from: object.position)
        return distance - (self.radius ?? 0) - (object.radius ?? 0)
    }
    
}
