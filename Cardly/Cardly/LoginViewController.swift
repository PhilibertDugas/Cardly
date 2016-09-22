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

    @IBAction func registerPressed(_ sender: AnyObject) {
        let email = emailField.text!
        let password = passwordField.text!
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                // TODO: We need to present an error message to the user
                print(error.localizedDescription)
                return
            }
            self.setDisplayName(user: user!)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user: user)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDisplayName(user: FIRUser) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email?.components(separatedBy: "@")[0]
        changeRequest.commitChanges { (error) in
            if let error = error {
                // TODO: We need to present an error message to the user
                print(error.localizedDescription)
                return
            }
            self.signedIn(user: FIRAuth.auth()?.currentUser)
        }
    }
    
    func signedIn(user: FIRUser?) {
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoUrl = user?.photoURL
        AppState.sharedInstance.signedIn = true
        performSegue(withIdentifier: Constants.Segues.SignedIn, sender: nil)
    }
}

