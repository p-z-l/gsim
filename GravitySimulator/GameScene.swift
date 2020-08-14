//
//  GameScene.swift
//  GravitySimulator
//
//  Created by Peter Luo on 2020/7/16.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let userCamera = SKCameraNode()
    
    override func sceneDidLoad() {
        initializeScene()
    }
    
    override func keyDown(with event: NSEvent) {
        print("Key pressed down: \(event.keyCode)")
        switch Int(event.keyCode) {
        case 24: // =
            guard userCamera.xScale > 0 && userCamera.yScale > 0 else { return }
            userCamera.xScale -= 1
            userCamera.yScale -= 1
        case 27: // -
            userCamera.xScale += 1
            userCamera.yScale += 1
        case 47: // .
            self.physicsWorld.speed += 0.5
        case 43: // ,
            guard self.physicsWorld.speed > 0 else { return }
            self.physicsWorld.speed -= 0.5
        case 126: // up
            userCamera.position.y += 20
        case 125: // down
            userCamera.position.y -= 20
        case 123: // left
            userCamera.position.x -= 20
        case 124: // right
            userCamera.position.x += 20
        case 35: // p
            self.isPaused.toggle()
        case 0: // a
            addRandomObject()
        case 15: // r
            initializeScene()
        default:
            break
        }
        self.camera = userCamera
    }
    
    private var objects: [Object] {
        var results = [Object]()
        for node in self.children {
            if node.name == "object",
               let shapeNode = node as? Object {
                results.append(shapeNode)
            }
        }
        return results
    }
    
    private func initializeScene() {
        
        // Remove existing objects
        for object in objects {
            object.removeFromParent()
        }
        
        // Initialize the scene
        self.backgroundColor = .black
        self.physicsWorld.gravity = .zero
        self.physicsWorld.speed = 1
        
        // Add center gravity object
        addObject(
            mass: Constants.centerObjectMass,
            radius: 128,
            color: .white,
            isCenterObject: true
        )
        
        // Add random objects
        for _ in 0..<Constants.initialObjectCount {
            addRandomObject()
        }
        
        // Initialize camera
        userCamera.position = .zero
        self.camera = userCamera
    }
    
    override func didSimulatePhysics() {
        updateGravity()
    }
    
    private func addObject(
        mass: CGFloat,
        radius: CGFloat,
        color: NSColor = .magicRandom,
        position: CGPoint = .zero,
        initialVelocity: CGVector = .zero,
        isDynamic: Bool = true,
        isCenterObject: Bool = false
    ) {
        let object = Object(circleOfRadius: radius)
        object.position = position
        object.name = "object"
        object.fillColor = color
        object.lineWidth = 0
        object.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        object.physicsBody!.mass = mass
        object.physicsBody!.velocity = initialVelocity
        object.physicsBody!.isDynamic = isDynamic
        object.physicsBody!.restitution = 0.0
        object.physicsBody!.linearDamping = 0.0
        object.radius = radius
        object.isCenterObject = isCenterObject
        self.addChild(object)
    }
    
    private func addRandomObject() {
        let radius = CGFloat.random(in: 4...20)
        let mass = radius*25000
        addObject(
            mass: mass,
            radius: radius,
            position: CGPoint(
                x: CGFloat.random(in: Constants.objectsSpawnRangeX),
                y: CGFloat.random(in: Constants.objectsSpawnRangeY)
            ),
            initialVelocity: CGVector(
                dx: CGFloat.random(in: Constants.initialSpeedRangeX),
                dy: CGFloat.random(in: Constants.initialSpeedRangeY)
            )
        )
    }
    
    private func updateGravity() {
        let asyncGroup = DispatchGroup()
        for objectA in objects {
            asyncGroup.enter()
            for objectB in objects {
                
                guard objectA.distance(from: objectB) != 0 else { continue }
                guard !objectA.isCenterObject else { continue }
                
                let acceleration : CGFloat = {
                    let G  = Constants.gravityConst
                    let m1 = objectA.physicsBody!.mass
                    let m2 = objectB.physicsBody!.mass
                    let r  = objectA.position.distance(from: objectB.position)
                    return G*m1*m2/pow(r, 2)
                }()
                let force : CGVector = CGVector.acceleration(
                    acceleration,
                    from: objectA.position,
                    to: objectB.position
                )
                objectA.physicsBody!.applyForce(force)
            }
            asyncGroup.leave()
        }
    }
    
}
