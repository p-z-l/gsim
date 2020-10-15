//
//  ViewController.swift
//  GravitySimulator
//
//  Created by Peter Luo on 2020/7/16.
//

import AppKit
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    @IBOutlet weak var velocityLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
            NotificationCenter.default.addObserver(
                self, selector: #selector(newObjcSelected(_:)), name: Notification.Name("NewObjectSelected"), object: nil)
        }
    }
    
    @objc func newObjcSelected(_ notification: Notification) {
        
        guard let object = notification.object as? Object else {
            velocityLabel.isHidden = true
            return
        }

        velocityLabel.isHidden = false
        let vel = object.physicsBody!.velocity
        velocityLabel.stringValue = "Velocity: (\(vel.dx.rounded()),\(vel.dy.rounded()))"
        
    }
    
}

