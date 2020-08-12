//
//  Constants.swift
//  GravitySimulator
//
//  Created by Peter Luo on 2020/7/16.
//

import Foundation

struct Constants {
    
    private init() {}
    
    // Object spawning
    static let objectsSpawnRangeX : ClosedRange<CGFloat> = 300...500
    static let objectsSpawnRangeY : ClosedRange<CGFloat> = 0...0
    static let initialObjectCount : Int = 10
    static let initialSpeedRangeX : ClosedRange<CGFloat> = 0...0
    static let initialSpeedRangeY : ClosedRange<CGFloat> = 700...1200
    
    // Center object
    static let centerObjectMass : CGFloat = 800000000
    
    // Gravity constant, can be any number
    static let gravityConst : CGFloat = 0.6
    
}
