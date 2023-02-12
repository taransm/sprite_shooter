//
//  SceneDelegate.swift
//  Sprite Shooter
//
//  Created by Tarandeep Mandhiratta 

// Currently acts solely as a collision node that tracks when the spaceship is hit by a ship
import UIKit
import SceneKit

class Spaceship: SCNNode {
    override init() {
        super.init()
        let box = SCNBox(width: 0.5, height: 1, length: 0.5, chamferRadius: 0)
        self.geometry = box
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        self.opacity = 0.01
        
        self.physicsField = SCNPhysicsField.electric()
        
        // see http://texnotes.me/post/5/ for details on collisions and bit masks
        self.physicsBody?.categoryBitMask = CollisionCategory.spaceship.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = CollisionCategory.spaceship.rawValue
        
        // add texture
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "targetBackground")
        self.geometry?.materials  = [material, material, material, material, material, material]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

