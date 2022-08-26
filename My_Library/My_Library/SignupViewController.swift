//
//  SignupViewController.swift
//  My_Library
//
//  Created by Ali Demirtaş on 25.08.2022.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBAction func signupButton(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            if email.count == 0 {
                let alertController = UIAlertController(title: "Email is not blank", message: "Please type a email", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okButton)
                self.present(alertController, animated: true)
            }
            if password.count < 6 {
                let alertController = UIAlertController(title: "Password is least min 6 character", message: "", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(okButton)
                self.present(alertController, animated: true)
            }else {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        print(e)
                    }else {
                        self.performSegue(withIdentifier: "goList", sender: nil)
                    }
            }
            
            }
        }
        
        
        
        
    }
}
