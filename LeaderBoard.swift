//
//  LeaderBoard.swift
//  Sprite Shooter
//
//  Created by Tarandeep Mandhiratta
//

import UIKit
import FirebaseDatabase
class LeaderBoard: UIViewController {

    var ref: DatabaseReference!
    var databaseHandler:DatabaseHandle!
    var scoreArray = [String]()
    @IBOutlet weak var name: UILabel!{
        didSet{
            name.text = MainMenuViewController.userNameToSave
        }
    }
    @IBOutlet weak var scoreHistory: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        databaseHandler = ref.child(MainMenuViewController.userNameToSave).observe(.childAdded, with: { DataSnapshot in
            
            let post = DataSnapshot.value as? String
            if let acPost = post{
//                self.scoreArray.append(acPost)
                print("Score is " + acPost)
                if  self.scoreHistory.text == "You Have Not Played Yet"
                {
                    self.scoreHistory.text = ""
                }
                self.scoreHistory.text = "\(self.scoreHistory.text!) \n || \(acPost) ||"
                
            }
            
            
        })
        // Do any additional setup after loading the view.
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
