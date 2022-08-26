//
//  DetailViewController.swift
//  My_Library
//
//  Created by Ali Demirtaş on 26.08.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var bookNameDetail = ""
    var authorDetail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookNameLabel.text = bookNameDetail
        authorLabel.text = authorDetail
    }
}
