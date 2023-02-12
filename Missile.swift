//
//  SceneDelegate.swift
//  Sprite Shooter
//
//  Created by Tarandeep Mandhiratta 
//

import UIKit
import SceneKit

// Spheres that are shot at the "ships"
class Missile: SCNNode {
    override init () {
        super.init()
        let sphere = SCNSphere(radius: 0.025)
        self.geometry = sphere
        let shape = SCNPhysicsShape(geometry: sphere, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false        
        self.physicsBody?.categoryBitMask = CollisionCategory.missiles.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = CollisionCategory.spaceship.rawValue
        
        self.geometry?.materials.first?.diffuse.contents = UIColor.purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

