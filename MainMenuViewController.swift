//
//  SceneDelegate.swift
//  Sprite Shooter
//
//  Created by Tarandeep Mandhiratta 
//

import UIKit
import FirebaseDatabase
class MainMenuViewController: UIViewController, UITextFieldDelegate {
    var ref: DatabaseReference!

    @IBOutlet weak var hiUser: UILabel!
    @IBOutlet weak var userName: UITextField!
    static var userNameToSave = ""
    let mainToGameSegue = "mainToGameSegue"
    let goToScoreBoard = "goToScoreBoard"
    override func viewDidLoad() {
        super.viewDidLoad()
       
        ref = Database.database().reference()
        let retrievedString = UserDefaults.standard.string(
        forKey: "username") ?? ""
        print(retrievedString)
        if retrievedString != ""{
            userName.text = retrievedString
            hiUser.text = retrievedString
            }
        userName.delegate = self
        // Do any additional setup after loading the view.
    }
//    func textFieldShouldReturn(userText: UITextField!) -> Bool {
//        userText.resignFirstResponder()
//        return true;
//    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        hiUser.text = userName.text
        MainMenuViewController.userNameToSave = userName.text ?? ""
        if MainMenuViewController.userNameToSave != ""{
            self.ref.child(MainMenuViewController.userNameToSave).childByAutoId()
//            self.ref.child(MainMenuViewController.userNameToSave).setValue("100")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName.endEditing(true)
        return true
    }
    func getUserName() -> String{
        print(MainMenuViewController.userNameToSave)
        return MainMenuViewController.userNameToSave

    }
    @IBAction func tapGestureRecognizer(_ sender: Any) {
        userName.resignFirstResponder()
        hiUser.text = userName.text
      
        MainMenuViewController.userNameToSave = userName.text ?? ""
        if MainMenuViewController.userNameToSave != ""{
            self.ref.child(MainMenuViewController.userNameToSave).childByAutoId()
//            self.ref.child(MainMenuViewController.userNameToSave).setValue("100")

        }
    }
    @IBAction func unwindToStartingViewController(unwindSegue: UIStoryboardSegue){
        
    }

    @IBAction func scoreButtonPressed(_ sender: UIButton) {
        if(userName.text == ""){
            let attributedString = NSAttributedString(string: "Please enter a username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red ])

            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.setValue(attributedString, forKey: "attributedMessage")
            let action = UIAlertAction(title: "BACK", style: .default, handler: nil)
            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
            
            self.performSegue(withIdentifier:self.goToScoreBoard,sender: self)


        }
    }
    @IBAction func playButtonPressed(_ sender: Any) {
    

        
        if(userName.text == ""){
            let attributedString = NSAttributedString(string: "Please enter a username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red ])

            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.setValue(attributedString, forKey: "attributedMessage")
            let action = UIAlertAction(title: "BACK", style: .default, handler: nil)
            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            MainMenuViewController.userNameToSave = userName.text ?? ""
            if MainMenuViewController.userNameToSave != ""{
                self.ref.child(MainMenuViewController.userNameToSave).childByAutoId()
//                self.ref.child(MainMenuViewController.userNameToSave).setValue("100")

            }
            
            self.performSegue(withIdentifier:self.mainToGameSegue,sender: self)


        }
        

        
 

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
