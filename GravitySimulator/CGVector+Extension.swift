//
//  CGVector+Extension.swift
//  GravitySimulator
//
//  Created by Peter Luo on 2020/7/16.
//

import Foundation

extension CGVector {
    
    static func acceleration(_ acceleration: CGFloat, from pointA: CGPoint, to pointB: CGPoint) -> CGVector {
        let dx = abs(pointA.x-pointB.x)
        let dy = abs(pointA.y-pointB.y)
        let x : CGFloat = {
            let x = abs(acceleration / (dy+dx) * dx)
            if pointA.x > pointB.x {
                return -x
            } else {
                return x
            }
        }()
        let y : CGFloat = {
            let y = abs(acceleration / (dy+dx) * dy)
            if pointA.y > pointB.y {
                return -y
            } else {
                return y
            }
        }()
        return CGVector(
            dx: x,
            dy: y
        )
    }
    
}
