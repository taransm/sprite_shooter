//
//  SceneDelegate.swift
//  Sprite Shooter
//
//  Created by Tarandeep Mandhiratta 
//

class GameHelper {
    static let sharedInstance = GameHelper()
    
    var score:Int
    var state = GameStateType.TapToPlay
    var liveEnemys = [Enemy]()
    
    private init() {
        score = 0
    }
    
    func resetGame() {
        score = 0
    }
    
    enum GameStateType {
        case TapToPlay
        case Playing
    }
}

struct CollisionCategory: OptionSet {
    let rawValue: Int
    
    static let missiles  = CollisionCategory(rawValue: 1 << 0) //moves 0 bits to left for 0000001
    static let enemy = CollisionCategory(rawValue: 1 << 1) //moves 1 bits to left for 00000001 then you have 00000010
    static let spaceship = CollisionCategory(rawValue: 1 << 2) //moves 1 bits to left for 00000001 then you have 00000100
}
