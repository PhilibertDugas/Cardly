//
//  RegisterViewController.swift
//  Cardly
//
//  Created by Philibert Dugas on 2016-09-24.
//  Copyright © 2016 QH4L. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var profileImage: UIImageView!
    
    let imagePicker = UIImagePickerController.init()
    let storageReference = FIRStorage.storage().reference(forURL: "gs://cardly-86595.appspot.com")
    
    var imageDownloadUrl: String!
    
    var databaseReference: FIRDatabaseReference!

    @IBAction func choosePictureTapped(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func registerTapped(_ sender: AnyObject) {
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
        imagePicker.delegate = self
        
        databaseReference = FIRDatabase.database().reference()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setDisplayName(user: FIRUser) {
        print("Setting up display name")
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email?.components(separatedBy: "@")[0]
        changeRequest.photoURL = URL.init(string: "gs://cardly-86595.appspot.com/\(user.uid)")
        changeRequest.commitChanges { (error) in
            if let error = error {
                // TODO: We need to present an error message to the user
                print(error.localizedDescription)
                return
            }
            self.uploadImage(user: user)
        }
    }
    
    func uploadImage(user: FIRUser) {
        print("Uploading image")
        let filePath = user.uid
        let imageData = UIImageJPEGRepresentation(profileImage.image!, 0.8)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        self.storageReference.child(filePath).put(imageData!, metadata: metadata).observe(FIRStorageTaskStatus.success) { (snapshot) in
            self.imageDownloadUrl = snapshot.metadata?.downloadURL()?.absoluteString
            self.setupBeaconId(user: user)
        }
    }
    
    func setupBeaconId(user: FIRUser) {
        print("Setting up beacon id + username")
        databaseReference.child("global").observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value! as? NSDictionary
            let minor = dict?["minor"] as! String
            let major = dict?["major"] as! String
            UserDefaults.standard.set(minor, forKey: "minor")
            UserDefaults.standard.set(major, forKey: "major")
            
            let newFirebaseUser = ["\((user.uid))": ["minor": minor, "major": major, "username": user.displayName!, "photoURL": self.imageDownloadUrl!]]
            
            self.databaseReference.child("users").updateChildValues(newFirebaseUser)
            
            let newGlobalMinor = Int(minor)! + 1
            let newGlobalId = ["minor": String(newGlobalMinor), "major": major]
            
            self.databaseReference.child("global").setValue(newGlobalId)
            self.registered(user: user)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func registered(user: FIRUser) {
        AppState.sharedInstance.displayName = user.displayName ?? user.email
        AppState.sharedInstance.photoUrl = user.photoURL
        AppState.sharedInstance.signedIn = true
        AppState.sharedInstance.minor = UInt16(UserDefaults.standard.integer(forKey: "minor"))
        AppState.sharedInstance.major = UInt16(UserDefaults.standard.integer(forKey: "major"))
        performSegue(withIdentifier: Constants.Segues.Registered, sender: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.contentMode = UIViewContentMode.scaleAspectFit
            profileImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: UINavigationControllerDelegate {
    
}
