//
//  LogInViewController.swift
//  warrantyKeeper
//
//  Created by anonymous on 16/12/2019.
//  Copyright © 2019 anonymous. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.isHidden = true
        setUpElements()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(emailText)
        Utilities.styleTextField(passwordText)
        Utilities.styleFilledButton(logInButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logInTapped(_ sender: Any) {
        
        activity.isHidden = false
        activity.startAnimating()
        
        let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                self.activity.isHidden = true
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            
            
            else {
                //TO GO TO HOME CATEGORIES ACTIVITY
                self.activity.isHidden = true
                self.performSegue(withIdentifier: "GoToHome", sender: nil)
                /*
                let homeViewController = self.storyboard?.instantiateViewController(identifier: "Homevc") as? CategoriesViewControllerTableViewController
                
                self.view.window?.rootViewController = homeViewController
                
                self.view.window?.makeKeyAndVisible()
                */
                
            }
            
        }
        
    }
    
}
