//
//  LoginViewController.swift
//  My_Library
//
//  Created by Ali Demirtaş on 25.08.2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func loginButton(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResul, error in
                if let e = error {
                    let alertController = UIAlertController(title: "Email or Password is wrong", message: "Try Again!", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(okButton)
                    self.present(alertController, animated: true)
                    print(e)
                }else {
                    self.performSegue(withIdentifier: "goList", sender: nil)
                }
            }
        }
        
    }
}
