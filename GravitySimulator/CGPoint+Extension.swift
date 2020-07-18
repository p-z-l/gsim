//
//  CGPoint+Extension.swift
//  GravitySimulator
//
//  Created by Peter Luo on 2020/7/16.
//

import Foundation

extension CGPoint {
    
    func distance(from point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x-point.x, 2)+pow(self.y-point.y, 2))
    }
    
}
