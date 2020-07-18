//
//  Constants.swift
//  GravitySimulator
//
//  Created by Peter Luo on 2020/7/16.
//

import Foundation

struct Constants {
    
    private init() {}
    
    static let objectsSpawnRangeX : ClosedRange<CGFloat> = 300...500
    static let objectsSpawnRangeY : ClosedRange<CGFloat> = 300...500
    
    static let objectCount : Int = 10
    
    static let centerObjectMass : CGFloat = 800000000
    
    static let initialSpeedRangeX : ClosedRange<CGFloat> = -600...(-400)
    static let initialSpeedRangeY : ClosedRange<CGFloat> = 400...600
    
    static let gravityConst : CGFloat = 0.6
    
}
