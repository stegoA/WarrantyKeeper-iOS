//
//  SignUpViewController.swift
//  warrantyKeeper
//
//  Created by anonymous on 16/12/2019.
//  Copyright © 2019 anonymous. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
            setUpElements()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameText)
        Utilities.styleTextField(lastNameText)
        Utilities.styleTextField(emailText)
        Utilities.styleTextField(firstNameText)
        Utilities.styleTextField(passwordText)
        Utilities.styleFilledButton(signUpButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //checks the field
    func validateFields()->String?{
        
        //Check all fields are filled in
        if firstNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Fill All Fields"
        }
        // password is secure
        let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            return "Password must be atleast 8 characters, contains a special character and a number"
        }
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
    

        
    let error = validateFields()
        if error != nil {
            activity.isHidden = true
            showError(error!)
        }
            
        else {
            
            activity.isHidden = false
            activity.startAnimating()
            
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    self.activity.isHidden = true
                    self.showError("Error Creating User")
                }
                else {
                    let userId = Auth.auth().currentUser!.uid
                    let db = Firestore.firestore()
                    db.collection(userId).document("Categories").setData(["0" : "General"])
                    self.performSegue(withIdentifier: "GoToLogin", sender: nil)

                   // self.transitionToHome()
                    
                }
            }
        }
    }
    
    func showError(_ message:String){
        errorLabel.text=message
        errorLabel.alpha=1
    }
    
//    func transitionToHome(){
//        activity.isHidden = true
//        let homeViewController =
//            storyboard?.instantiateViewController(identifier: "loginScreen") as? LogInViewController
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
//    }
    
}
