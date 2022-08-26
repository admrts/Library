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
    
    let db = Firestore.firestore()
    var bookArray: [Book] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadBooks()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        if segue.identifier == "goDetail" {
            let goVC = segue.destination as! DetailViewController
            goVC.bookNameDetail = bookArray[index!].bookName
            goVC.authorDetail = bookArray[index!].author
        }
    }
    
    
    func loadBooks() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.bookField)
            .addSnapshotListener { querySnapshot, error in
                self.bookArray = []
                if let e = error {
                    print("Loading error Firestore \(e)")
                }else {
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let sender = data[K.FStore.senderField] as? String, let bookName = data[K.FStore.bookField] as? String, let author = data[K.FStore.authorField] as? String {
                                if sender == Auth.auth().currentUser?.email {
                                    let newBook = Book(sender: sender, bookName: bookName, author: author)
                                    self.bookArray.append(newBook)
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                    
                                }
                            }
                        }
                    }
                }
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
            if let bookText = (alerController.textFields![0] as UITextField).text, let authorText = (alerController.textFields![1] as UITextField).text, let sender = Auth.auth().currentUser?.email  {
                let bookName = bookText
                let author = authorText
                
                self.db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: sender,K.FStore.bookField: bookName,K.FStore.authorField: author]) { error in
                    if let e = error {
                        print("Error : Saving data to firestore  \(e)")
                    }else {
                        print("Book saved.")
                    }
                }
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
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
}
//MARK: - TableView Datasource
extension BooksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = bookArray[indexPath.row].bookName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goDetail", sender: indexPath.row)
    }
}
