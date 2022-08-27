//
//  LibraryViewController.swift
//  My_Library
//
//  Created by Ali Demirtaş on 25.08.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class BooksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var firebaseManager = FirebaseManager()
    
    let db = Firestore.firestore()
    var bookArray: [Book] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        firebaseManager.delegate = self
        firebaseManager.loadBooks()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        if segue.identifier == "goDetail" {
            let goVC = segue.destination as! DetailViewController
            goVC.bookNameDetail = bookArray[index!].bookName
            goVC.authorDetail = bookArray[index!].author
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alerController = UIAlertController(title: "Add Book", message: "", preferredStyle: .alert)
        alerController.addTextField { textField in
            textField.autocapitalizationType = .words
            textField.placeholder = "Book Name"
        }
        alerController.addTextField { textField in
            textField.autocapitalizationType = .words
            textField.placeholder = "Author"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            self.bookArray = []
            if let bookText = (alerController.textFields![0] as UITextField).text, let authorText = (alerController.textFields![1] as UITextField).text, let sender = Auth.auth().currentUser?.email  {
                let bookName = bookText
                let author = authorText
                
                self.firebaseManager.saveBook(sender: sender, bookName: bookName, author: author)
                
                print(bookName)
                print(author)
                print(sender)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("Canceled")
        }
        alerController.addAction(saveAction)
        alerController.addAction(cancelAction)
        self.present(alerController, animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        firebaseManager.logOut()
        navigationController?.popToRootViewController(animated: true)
    }
}
//MARK: - TableView Datasource & Delegate
extension BooksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = self.bookArray[indexPath.row].bookName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goDetail", sender: indexPath.row)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, boolValue  in
            
            let alertController = UIAlertController(title: "\(self.bookArray[indexPath.row].bookName) is Delete ?", message: "Are you sure", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "YES", style: .default) { action in
                let selectBook = self.bookArray[indexPath.row].idString
                
                self.bookArray = []
                self.firebaseManager.deleteBook(selectBook: selectBook)
                self.tableView.reloadData()
                
                
                // self.tableView.reloadData()
            }
            let noAction = UIAlertAction(title: "No", style: .cancel) { action in
                self.tableView.reloadData()
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK: - FirebaseManger Protocol
extension BooksViewController: FirebaseManagerProtocol {
    func didUpdateBook(_ firebaseManager: FirebaseManager, newBook: Book) {
        self.bookArray = []
        DispatchQueue.main.async {
            self.bookArray.append(newBook)
            self.tableView.reloadData()
        }
    }
    
    
}
