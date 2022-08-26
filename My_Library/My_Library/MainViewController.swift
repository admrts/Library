//
//  MainViewController.swift
//  My_Library
//
//  Created by Ali Demirtaş on 25.08.2022.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func loginButton(_ sender: Any) {
        performSegue(withIdentifier: "goLogin", sender: nil)
    }
    
    @IBAction func signupButton(_ sender: Any) {
        performSegue(withIdentifier: "goSignup", sender: nil)
    }
}
