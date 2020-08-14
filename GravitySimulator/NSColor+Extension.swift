//
//  NSColor+Extension.swift
//  GravitySimulator
//
//  Created by Peter Luo on 2020/7/16.
//

import AppKit

extension NSColor {
    
    static var random: NSColor {
        return NSColor.random(
            red: 0...1,
            green: 0...1,
            blue: 0...1
        )
    }
    
    static func random(
        red: ClosedRange<CGFloat>,
        green: ClosedRange<CGFloat>,
        blue: ClosedRange<CGFloat>) -> NSColor {
        return NSColor(
            red: .random(in: red),
            green: .random(in: green),
            blue: .random(in: blue),
            alpha: 1.0
        )
    }
    
    static var randomRed: NSColor {
        return NSColor.random(
            red: 0.8...1.0,
            green: 0...0.5,
            blue: 0.1...0.5
        )
    }
    
    static var randomGreen: NSColor {
        return NSColor.random(
            red: 0...0.5,
            green: 0.8...1.0,
            blue: 0.1...0.5
        )
    }
    
    static var randomBlue: NSColor {
        return NSColor.random(
            red: 0...0.5,
            green: 0.1...0.5,
            blue: 0.8...1.0
        )
    }
    
    static var magicRandom: NSColor {
        let colorType = Int.random(in: 0...2)
        switch colorType {
        case 0: // red-ish
            return NSColor.random(
                red: 0.6...0.8,
                green: 0...0.5,
                blue: 0.1...0.5
            )
        case 1: // green-ish
            return NSColor.random(
                red: 0...0.5,
                green: 0.6...0.8,
                blue: 0.1...0.5
            )
        case 2: // blue-ish
            return NSColor.random(
                red: 0...0.5,
                green: 0.1...0.5,
                blue: 0.6...8.0
            )
        default:
            return .random
        }
    }
    
}
