//
//  GameScene.swift
//  GravitySimulator
//
//  Created by Peter Luo on 2020/7/16.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let userCamera = SKCameraNode()
    
    private var newlyAddedObject : Object?
    
    private var selectedObject: Object? {
        willSet {
            selectedObject?.lineWidth = 0.0
            selectedObject?.strokeColor = .clear
        }
        didSet {
            selectedObject?.lineWidth = 2.0
            selectedObject?.strokeColor = .white
            NotificationCenter.default.post(Notification(name: Notification.Name("NewObjectSelected"), object: selectedObject, userInfo: nil))
            userCamera.position = (selectedObject ?? centerGravityObject!).position
            self.camera = userCamera
        }
    }
    
    private var userIsAddingObject = false {
        didSet {
            if userIsAddingObject {
                self.physicsWorld.speed = 0
            } else {
                self.physicsWorld.speed = 1
                newlyAddedObject = nil
                self.childNode(withName: "velIndicator")?.removeFromParent()
                self.children.filter { $0.name == "TrajPredict" }.forEach { $0.removeFromParent() }
            }
        }
    }
    
    override func sceneDidLoad() {
        initializeScene()
    }
    
    override func keyDown(with event: NSEvent) {
        print(event.keyCode)
        switch Int(event.keyCode) {
        case 24: // =
            guard userCamera.xScale > 1 && userCamera.yScale > 1 else { return }
            userCamera.xScale -= 0.5
            userCamera.yScale -= 0.5
        case 27: // -
            userCamera.xScale += 1
            userCamera.yScale += 1
        case 35: // p
            self.isPaused.toggle()
        case 15: // r
            initializeScene()
        default:
            break
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let position = event.location(in: self)
        var hasSelectedAnObject = false
        for object in objects {
            if position.distance(from: object.position) <= (object.radius ?? 0) {
                // Selected an object
                selectedObject = object
                hasSelectedAnObject = true
            }
        }
        if !hasSelectedAnObject {
            userAddObject()
            newlyAddedObject?.position = event.location(in: self)
            selectedObject = nil
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        let mousePos = event.location(in: self)
        newlyAddedObject?.physicsBody?.velocity = CGVector(
            dx: mousePos.x - newlyAddedObject!.position.x,
            dy: mousePos.y - newlyAddedObject!.position.y
        )
        updateVelocityIndicator()
    }
    
    override func mouseUp(with event: NSEvent) {
        userIsAddingObject = false
    }
    
    private var objects: [Object] { self.children.filter { $0.name == "object"} as! [Object] }
    private var centerGravityObject: Object? { objects.filter { $0.isCenterObject}.first }
    
    private func initializeScene() {
        
        // Remove existing objects
        self.removeAllChildren()
        
        // Initialize the scene
        self.backgroundColor = .black
        self.physicsWorld.gravity = .zero
        self.physicsWorld.speed = 1
        
        // Add center gravity object
        _ = addObject(
            mass: Constants.centerObjectMass,
            radius: 128,
            color: .white,
            isCenterObject: true
        )
        
        // Initialize camera
        userCamera.position = .zero
        userCamera.xScale = 2
        userCamera.yScale = 2
        self.camera = userCamera
        
        // Add camera dragging
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        userCamera.position = (selectedObject ?? centerGravityObject!).position
        self.camera = userCamera
        if userIsAddingObject {
            updateTrajPredictIfNeeded()
        }
    }
    
    override func didSimulatePhysics() {
        updateGravity()
        
        removeDistantObjects()
    }
    
    private func userAddObject() {
        userIsAddingObject = true
        newlyAddedObject = addRandomObject()
    }
    
    private func addObject(
        mass: CGFloat,
        radius: CGFloat,
        color: NSColor = .magicRandom,
        position: CGPoint = .zero,
        initialVelocity: CGVector = .zero,
        isDynamic: Bool = true,
        isCenterObject: Bool = false
    ) -> Object {
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
        return object
    }
    
    private func addRandomObject() -> Object {
        let radius = CGFloat.random(in: 4...20)
        let mass = radius*25000
        return addObject(
            mass: mass,
            radius: radius,
            position: CGPoint(
                x: CGFloat.random(in: Constants.objectsSpawnRangeX),
                y: CGFloat.random(in: Constants.objectsSpawnRangeY)
            ),
            initialVelocity: .zero
        )
    }
    
    private func removeDistantObjects() {
        
        let centerGravObjPos = centerGravityObject?.position ?? .zero
        
        objects
            .filter { $0.position.distance(from: centerGravObjPos) >= 12000 }
            .forEach { $0.removeFromParent() }
    }
    
    private func updateVelocityIndicator() {
        
        let indicatorName = "velIndicator"
        self.children.filter { $0.name == indicatorName }.forEach { $0.removeFromParent() }
        guard newlyAddedObject != nil else { return }
        
        let objPos = newlyAddedObject!.position
        let objVel = newlyAddedObject!.physicsBody!.velocity
        let startPos = CGPoint(x: objPos.x, y: objPos.y)
        let endPos = CGPoint(x: objPos.x + objVel.dx, y: objPos.y + objVel.dy)
        let color = newlyAddedObject!.fillColor
        let halfWidth = newlyAddedObject!.radius!
        var points = [startPos, endPos]
        
        let indicator = SKShapeNode(
            splinePoints: &points,
            count: 2
        )
        let startIndicator = SKShapeNode(circleOfRadius: halfWidth)
        startIndicator.position = startPos
        startIndicator.fillColor = color
        startIndicator.name = indicatorName
        startIndicator.lineWidth = 0.0
        let endIndicator = SKShapeNode(circleOfRadius: halfWidth)
        endIndicator.position = endPos
        endIndicator.fillColor = color
        endIndicator.lineWidth = 0.0
        indicator.strokeColor = color
        indicator.lineWidth = halfWidth*2
        indicator.name = indicatorName
        indicator.isAntialiased = true
        indicator.addChild(startIndicator)
        indicator.addChild(endIndicator)
        self.addChild(indicator)
    }
    
    private func gravitationalForce(from p1: CGPoint, m1: CGFloat, to p2:CGPoint, m2: CGFloat) -> CGVector {
        let magnitude : CGFloat = {
            let G = Constants.gravityConst
            let r = p1.distance(from: p2)
            return G*m1*m2/pow(r, 2)
        }()
        return CGVector.acceleration(
            magnitude,
            from: p1,
            to: p2
        )
    }
    
    private func updateGravity() {
        for objectA in objects {
            for objectB in objects {

                let force = gravitationalForce(
                    from: objectA.position,
                    m1: objectA.physicsBody!.mass,
                    to: objectB.position,
                    m2: objectB.physicsBody!.mass
                )
                objectA.physicsBody!.applyForce(force)
            }
        }
    }
    
    private func updateTrajPredictIfNeeded() {
        let predictNodeName = "TrajPredict"
        self.children.filter { $0.name == predictNodeName }.forEach { $0.removeFromParent() }
        let p2 = centerGravityObject!.position
        let m2 = centerGravityObject!.physicsBody!.mass
        let m1 = newlyAddedObject!.physicsBody!.mass
        var prevPos = newlyAddedObject!.position
        var prevVel = newlyAddedObject!.physicsBody!.velocity
        var points : [CGPoint] = [prevPos]
        for _ in 0..<24 {
            let p1 = prevPos
            let f = gravitationalForce(
                from: p1,
                m1: m1,
                to: p2,
                m2: m2
            )
            let vel = CGVector(dx: f.dx/m1 + prevVel.dx, dy: f.dy/m1 + prevVel.dy)
            prevVel = vel
            let pos = CGPoint(x: prevPos.x + vel.dx, y: prevPos.y + vel.dy)
            prevPos = pos
            
            points.append(pos)
        }
        let trajNode = SKShapeNode(splinePoints: &points, count: points.count)
        trajNode.name = predictNodeName
        trajNode.lineWidth = 10.0
        trajNode.strokeColor = .darkGray
        trajNode.isAntialiased = true
        self.addChild(trajNode)
    }
    
}
