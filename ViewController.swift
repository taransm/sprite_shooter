//
//  SceneDelegate.swift
//  Sprite Shooter
//
//  Created by Tarandeep Mandhiratta 
//
import UIKit
import SceneKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var musicIcon: UIImageView!
    var musicIsPlaying = true
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var leftDirectionIndicator: UILabel!
    @IBOutlet weak var rightDirectionIndicator: UILabel!
    var segueToGameOver = "gameOverSegue"
    var fireParticleNode : SCNNode?
    var musicPlayer = MusicPlayer()
    var spaceshipNode : SCNNode?
    let gameHelper = GameHelper.sharedInstance
    
    private var userScore: Int = 0 {
        didSet {
            // ensure UI update runs on main thread
            DispatchQueue.main.async {
                self.statusLabel.text = String(self.userScore)
            }
        }
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        musicPlayer.playMusic()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new empty scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.scene.physicsWorld.contactDelegate = self
        
        let skScene = SKScene(size: CGSize(width: 500, height: 100))
        skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if musicIsPlaying {
            musicPlayer.stopMusic()
            musicIsPlaying = false
            musicIcon.image = UIImage(named: "musicOff.png")
        }
        else{
            musicPlayer.playMusic()
            musicIsPlaying = true
            musicIcon.image = UIImage(named: "musicOn.png")

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureSession()
        self.beginPlaying()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func configureSession() {
        
       // if ARWorldTrackingConfiguration.isSupported { // checks if user's device supports the more precise ARWorldTrackingSessionConfiguration
            // equivalent to `if utsname().hasAtLeastA9()`
            // Create a session configuration
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            
            // Run the view's session
            sceneView.session.delegate = self
            sceneView.session.run(configuration)
//        } else {
//            // slightly less immersive AR experience due to lower end processor
//            let configuration = ARConfiguration()
//            // Run the view's session
//            sceneView.session.run(configuration)
//        }
    }

    // MARK: - Actions
    @IBAction func didTapScreen(_ sender: UITapGestureRecognizer) { // fire missile in direction viewer is facing
        switch gameHelper.state {
        case .Playing:
            self.shootMissile()
        case .TapToPlay:
            self.beginPlaying()
        }
    }
    
    // Mark: - Direction Indicators
    
    func displayDirectionIndicatorsIfAppropriate() {
        if let enemy = gameHelper.liveEnemys.first
        {
            let (_, enemyPosition) = self.getEnemyVector(for: enemy)
            let (userDirection, _) = self.getUserVector()

            
            if(abs(enemyPosition.x) > 0.6 && enemyPosition.x > userDirection.x)
            {
                //show right indicator
                DispatchQueue.main.async {
                    if self.rightDirectionIndicator.isHidden {
                        self.rightDirectionIndicator.isHidden = false
                        self.leftDirectionIndicator.isHidden = true

                        self.animateDirectionIndicators()
                    }
                }
                
            }else if(abs(enemyPosition.x) > 0.6 && enemyPosition.x < userDirection.x) {
                //show left indicator
                DispatchQueue.main.async {
                    if self.leftDirectionIndicator.isHidden {
                        self.leftDirectionIndicator.isHidden = false
                        self.rightDirectionIndicator.isHidden = true

                        self.animateDirectionIndicators()
                    }
                }
            }else{
                //hide direction indicators
                self.hideDirectionIndicators()
            }
        }
    }
    
    func hideDirectionIndicators() {
        DispatchQueue.main.async {
            self.endDirectionIndicatorAnimations()
            
            self.rightDirectionIndicator.isHidden = true
            self.leftDirectionIndicator.isHidden = true
        }
    }
    
    func animateDirectionIndicators() {
        DispatchQueue.main.async {
            self.rightDirectionIndicator.alpha = 0
            self.leftDirectionIndicator.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.05, options:[.repeat,.autoreverse],
                           animations:{
                            self.rightDirectionIndicator.alpha = 1.0
                            self.leftDirectionIndicator.alpha = 1.0
                            
            }, completion: nil)
        }
    }
    
    func endDirectionIndicatorAnimations() {
        DispatchQueue.main.async {
            self.rightDirectionIndicator.alpha = 1.0
            self.rightDirectionIndicator.layer.removeAllAnimations()
            self.leftDirectionIndicator.alpha = 1.0
            self.leftDirectionIndicator.layer.removeAllAnimations()
        }
    }
    
    // MARK: - Node Related
    func shootMissile() {
        let missilesNode = Missile()
        
        let (direction, position) = self.getUserVector()
        missilesNode.position = position // SceneKit/AR coordinates are in meters
        let missileDirection = direction
        
        let impulseVector = SCNVector3(
            x: missileDirection.x * Float(20),
            y: missileDirection.y * Float(20),
            z: missileDirection.z * Float(20)
        )
        
        missilesNode.physicsBody?.applyForce(impulseVector, asImpulse: true)
        sceneView.scene.rootNode.addChildNode(missilesNode)
        
        //3 seconds after shooting the missile, remove the missile node
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            // remove node
            missilesNode.removeFromParentNode()
        })
    }
    
    func addSpaceship() {
        let newSpaceshipNode = Spaceship()
        newSpaceshipNode.position = self.getViewerPosition()
        sceneView.scene.rootNode.addChildNode(newSpaceshipNode)
        self.spaceshipNode = newSpaceshipNode
    }
    
    func addEnemy() {
        let enemyNode = Enemy()
        let posX = floatBetween(-0.5, and: 0.5)
        let posY = Float(0)
        let posZ = -2
        enemyNode.position = SCNVector3(posX, posY, Float(posZ)) // SceneKit/AR coordinates are in meters
        sceneView.scene.rootNode.addChildNode(enemyNode)
        gameHelper.liveEnemys.append(enemyNode)
        
        self.directNodeTowardViewer(enemyNode)
        
        print("Added Enemy! Position:\(enemyNode.position)")
    }
    
    func addInitialEnemy() {
        //Add initial enemy after 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.addEnemy()
        })
    }
    
    func beginPlaying() {        
        self.userScore = 0
        gameHelper.state = .Playing
        self.fireParticleNode?.removeFromParentNode()
        
        self.addSpaceship()
        self.addInitialEnemy()
        self.hideDirectionIndicators()
    }
    //MARK: made changes here
    func endPlaying() {
        DispatchQueue.main.async {
        
            self.statusLabel.text = "YOU COLLIDED"
            DispatchQueue.main.asyncAfter(deadline:.now() + 4.0, execute: {
                self.performSegue(withIdentifier:self.segueToGameOver,sender: self)
            })           // self.tapGestureRecognizer.isEnabled = false
            
            //Add a delay for re-enabling the tap gesture recognizer so that a user who is spam clicking to shoot will notice that he died and not be confused about why his score went to 0
            //DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
               //self.tapGestureRecognizer.isEnabled = true
               
          // })
            
            self.hideDirectionIndicators()
            //self.performSegue(withIdentifier: , sender: self)
        }
       
   
        
       
       // gameHelper.state = .TapToPlay
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        if segue.identifier == segueToGameOver {
            let gameOverVC = segue.destination as! GameOverViewController
            gameOverVC.initWithScore(score: userScore)
         
    }
    }
    func directNodeTowardViewer(_ node: SCNNode) {
        node.physicsBody?.clearAllForces()
        //Make cube node go towards viewer
        let (_, spaceshipPosition) = self.getViewerVector()
        let impulseVector = SCNVector3(
            x: self.randomOneOfTwoInputFloats(-0.50, and: 0.50),
            y: spaceshipPosition.y,
            z: spaceshipPosition.z
        )
        
        //Makes generated nodes rotate when applied with force
        let positionOnNodeToApplyForceTo = SCNVector3(x: 0.005, y: 0.005, z: 0.005)
        
        node.physicsBody?.applyForce(impulseVector, at: positionOnNodeToApplyForceTo, asImpulse: true)
    }
    
    func removeNode(_ node: SCNNode) {
        if node is Enemy {
            let particleSystem = SCNParticleSystem(named: "removeObject", inDirectory: "art.scnassets/")
            //let particleSize = particleSystem?.particleSize
            let systemNode = SCNNode()
            systemNode.addParticleSystem(particleSystem!)
            // place explosion where node is
            systemNode.position = node.presentation.position
            //node.addChildNode(systemNode)
            sceneView.scene.rootNode.addChildNode(systemNode)
            
            if let enemy = node as? Enemy
            {
                if let enemyIndex = gameHelper.liveEnemys.firstIndex(of: enemy)
                {
                    gameHelper.liveEnemys.remove(at: enemyIndex)
                }
            }
        }else if node is Spaceship {
            let particleSystem = SCNParticleSystem(named: "hitByBullet", inDirectory: "art.scnassets/")
            //let particleSize = particleSystem?.particleSize
            self.fireParticleNode = SCNNode()
            self.fireParticleNode?.addParticleSystem(particleSystem!)
            // place fire where viewer is
            self.fireParticleNode?.position = SCNVector3Make(node.presentation.position.x, node.presentation.position.y, node.presentation.position.z - 0.5)
            sceneView.pointOfView!.addChildNode(self.fireParticleNode!)
        }
        // remove node
        node.removeFromParentNode()
    }
    
    func getEnemyVector(for enemy: Enemy?) -> (SCNVector3, SCNVector3) { // (direction, position)
        guard let enemy = enemy else {return (SCNVector3Zero, SCNVector3Zero)}
        
        let mat = enemy.presentation.transform // 4x4 transform matrix describing enemy node in world space
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of enemy node in world space
        let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of enemy node world space

        return (dir, pos)
    }
    
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing viewer in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of viewer in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of viewer in world space
            
            return (dir, pos)
        }
        return (SCNVector3Zero, SCNVector3Zero)
    }
    
    func getViewerVector() -> (SCNVector3, SCNVector3)  { // (direction, position)
        
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing viewer in world space
            let dir = SCNVector3(mat.m31, mat.m32, mat.m33) // orientation of viewer in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of viewer in world space
            
            return (dir, pos)
        }
        return (SCNVector3Zero, SCNVector3Zero)
    }
    
    func getViewerPosition() -> SCNVector3 {
        let (_ , position) = self.getViewerVector()
        return position
    }
    
    func floatBetween(_ first: Float,  and second: Float) -> Float { // random float between upper and lower bound (inclusive)
        return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
    }
    
    func randomOneOfTwoInputFloats(_ first: Float, and second: Float) -> Float {
        let array = [first, second]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        
        return array[randomIndex]
    }
}

    // MARK: - SCNPhysicsContactDelegate
extension ViewController : SCNPhysicsContactDelegate
{
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if (contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.enemy.rawValue && contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.missiles.rawValue) ||
            (contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.missiles.rawValue && contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.enemy.rawValue){
            //enemy was hit from missile!
            print("Hit enemy!")
//            musicPlayer.HitTarget()
            self.removeNode(contact.nodeB)
            self.removeNode(contact.nodeA)
            self.userScore += 1
            
            self.addEnemy()
        }else if (contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.enemy.rawValue &&
            contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.spaceship.rawValue) ||
            (contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.spaceship.rawValue &&
                contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.enemy.rawValue){
            //Spaceship was hit by enemy!
            print("Spaceship Dead!")
          
           // run(SKAction.playSoundFileNamed("hitByObject.caf", waitForCompletion: false))
            musicPlayer.collision()
            self.removeNode(contact.nodeA)
            self.removeNode(contact.nodeB)
            
            self.endPlaying()
        }
    }
}

    // MARK: - ARSessionDelegate
extension ViewController : ARSessionDelegate
{
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        //TODO: See if there's a better way to update spaceship position instead of repositioning it everytime
        //      the viewer gets a new frame
        self.spaceshipNode?.position = self.getViewerPosition()
        self.displayDirectionIndicatorsIfAppropriate()
    }
}

    // MARK: - SCNSceneRendererDelegate
extension ViewController : SCNSceneRendererDelegate
{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

    }
}
