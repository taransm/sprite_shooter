//
//  SceneDelegate.swift
//  Sprite Shooter
//
//  Created by Tarandeep Mandhiratta
//

import UIKit
import FirebaseDatabase

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var scoreUI: UILabel!
    var score = 0
    var gameOverToMainMen = "gameOverToMainMen"
    var topFiveScore = ["1","2","3","4","5"]
    
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreUI.text = "You scored \(self.score)"
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline:.now() + 6.0, execute: {
            self.performSegue(withIdentifier:self.gameOverToMainMen,sender: self)
        })
        ref = Database.database().reference()
        ref.child(MainMenuViewController.userNameToSave).childByAutoId().setValue(String(score))
        
        
        
        
        
        
//        ref.child(MainMenuViewController.userNameToSave).observeSingleEvent(of:  .value, with:  { snapshot in
//            guard let value = snapshot.value as? String else {
//                return
//            }
//
//
//            print("HERE is retrived database value............" + value)
//        })

    }
    
//    @objc private func addnewEntry(){
//        let object:[Any: Any] = [: ""]
//    }
    
    func initWithScore(score: Int){
        print("Score")
        self.score = score
        print(self.score)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
