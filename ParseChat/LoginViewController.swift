//
//  LoginViewController.swift
//  ParseTest
//
//  Created by Kacper Raczy on 24.09.2017.
//  Copyright © 2017 Kacper Raczy. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAlertController(title:String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (usernameTextField) in
            usernameTextField.placeholder = "username"
            usernameTextField.tag = 0
        }
        alert.addTextField { (passwordTextField) in
            passwordTextField.placeholder = "password"
            passwordTextField.tag = 1
            passwordTextField.isSecureTextEntry = true
        }
        return alert
    }
    
    func createErrorAlert(msg: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        
        return alert
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let alert = createAlertController(title: "Sign Up", message: "Create account by providing username and password")
        
        let signUpAction = UIAlertAction(title: "Sign Up", style: .default) { (action) in
            guard let username = alert.textFields?.first?.text,
                let password = alert.textFields?.last?.text else {
                return alert.dismiss(animated: true, completion: nil)
            }
            let user = PFUser()
            user.username = username
            user.password = password
            user.signUpInBackground(block: { (succeded, err) in
                if let error = err {
                    let errorAlert = self.createErrorAlert(msg: error.localizedDescription)
                    self.present(errorAlert, animated: true, completion: nil)
                }else {
                    self.performSegue(withIdentifier: "showFriends", sender: self)
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(signUpAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        let alert = createAlertController(title: "Log in", message: "Log in with username and password")
        let logInAction = UIAlertAction(title: "Log in", style: .default) { (action) in
            guard let username = alert.textFields?.first?.text,
                let password = alert.textFields?.last?.text else {
                    return alert.dismiss(animated: true, completion: nil)
            }
            PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, err) in
                if let error = err {
                    let errorAlert = self.createErrorAlert(msg: error.localizedDescription)
                    self.present(errorAlert, animated: true, completion: nil)
                }else {
                    self.performSegue(withIdentifier: "showFriends", sender: self)
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(logInAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

}
