//
//  NSColor+Extension.swift
//  GravitySimulator
//
//  Created by Peter Luo on 2020/7/16.
//

import AppKit

extension NSColor {
    
    static var random: NSColor {
        return NSColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0
        )
    }
    
}
