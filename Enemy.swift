//
//  SceneDelegate.swift
//  Sprite Shooter
//
//  Created by Tarandeep Mandhiratta 
//

import UIKit
import SceneKit

// Floating boxes that appear around you
class Enemy: SCNNode {
    override init() {
        super.init()
        var geometry:SCNGeometry
        
        switch ShapeType.random() {
        case .Box:
            geometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.0)
        case .Sphere:
            geometry = SCNSphere(radius: 0.25)
        case .Capsule:
            geometry = SCNCapsule(capRadius: 0.15, height: 0.35)
        case .Cylinder:
            geometry = SCNCylinder(radius: 0.2, height: 0.5)
        }

        
        self.geometry = geometry
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.charge = -0.5
        self.physicsBody?.categoryBitMask = CollisionCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.missiles.rawValue
        self.physicsBody?.collisionBitMask = CollisionCategory.enemy.rawValue
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "targetBackground")
        self.geometry?.materials  = [material, material, material, material, material, material]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public enum ShapeType:Int {
    case Box = 0
    case Sphere
    case Capsule
    case Cylinder
    
    static func random() -> ShapeType {
        let maxValue = Cylinder.rawValue
        let rand = arc4random_uniform(UInt32(maxValue+1))
        return ShapeType(rawValue: Int(rand))!
    }
}
