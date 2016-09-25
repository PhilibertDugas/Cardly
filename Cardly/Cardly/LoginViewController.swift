//
//  ViewController.swift
//  Cardly
//
//  Created by Philibert Dugas on 2016-09-20.
//  Copyright © 2016 QH4L. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func signInPressed(_ sender: AnyObject) {
        let email = emailField.text!
        let password = passwordField.text!
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                // TODO: We need to present an error message to the user
                print(error.localizedDescription)
                return
            }
            self.signedIn(user: user)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user: user)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func signedIn(user: FIRUser?) {
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoUrl = user?.photoURL
        AppState.sharedInstance.signedIn = true
        AppState.sharedInstance.minor = UInt16(UserDefaults.standard.integer(forKey: "minor"))
        AppState.sharedInstance.major = UInt16(UserDefaults.standard.integer(forKey: "major"))
        performSegue(withIdentifier: Constants.Segues.SignedIn, sender: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

