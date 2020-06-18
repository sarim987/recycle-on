//
//  FirstViewController.swift
//  RecycleOn
//
//  Created by Sarim Ahmed on 11/26/18.
//  Copyright © 2018 SAKT. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createFakeUsers()
    }


    @IBAction func loginTapped(_ sender: UIButton) {
        
        print("Tapped")
        
        let authUI = FUIAuth.defaultAuthUI()
        guard authUI != nil else { return }
        
        authUI?.delegate = self
        
        let authViewController = authUI!.authViewController()
        
        present(authViewController, animated: true, completion: nil)
        
    }
    
    func createFakeUsers() {
        createFakeUser(email: "johnny@umass.edu", password: "testing1", name: "Johnny", points: 1000)
        createFakeUser(email: "rachel@umass.edu", password: "testing1", name: "Rachel", points: 850)
        createFakeUser(email: "joe@umass.edu", password: "testing1", name: "Joe", points: 840)
        createFakeUser(email: "tajour@umass.edu", password: "testing1", name: "Tajour", points: 700)
        createFakeUser(email: "sarim@umass.edu", password: "testing1", name: "Sarim", points: 680)
        createFakeUser(email: "khang@umass.edu", password: "testing1", name: "Khang", points: 650)
    }
    
    func createFakeUser(email: String, password: String, name: String, points: Int) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil { print(error ?? "") }
            if let user = result?.user {
                
                let db = Database.database().reference().child("users").child(user.uid)
                let values: [String: Any] = ["name": name,
                                             "email": email,
                                             "points": points,
                                             "uid" : user.uid]
                db.setValue(values, withCompletionBlock: { (err, db) in
                    if err != nil { print(err ?? "") }
                    print("Added \(name)")
                })
                
                
            }
        }
        
    }
}
extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            return
        }
        if let user = authDataResult?.user {
            let db = Database.database().reference().child("users").child(user.uid)
        let values: [String: Any] = ["name": user.displayName!,
                                     "email": user.email!,
                                     "points": 0,
                                     "uid": user.uid]
            db.setValue(values) { (err, db) in
                if err != nil { print(err ?? "")}
                print("Added \(user.displayName!)")
            }
        }
        performSegue(withIdentifier: "goHome", sender: self)
    }
}

