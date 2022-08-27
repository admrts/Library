//
//  FirebaseManager.swift
//  My_Library
//
//  Created by Ali Demirtaş on 27.08.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FirebaseManagerProtocol {
    func didUpdateBook(_ firebaseManager: FirebaseManager, newBook: Book)
}


struct FirebaseManager {
    let db = Firestore.firestore()
    var delegate: FirebaseManagerProtocol?
    
    
    func loadBooks() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.bookField)
            .addSnapshotListener { querySnapshot, error in
                if let e = error {
                    print("Loading error Firestore \(e)")
                }else {
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let sender = data[K.FStore.senderField] as? String, let bookName = data[K.FStore.bookField] as? String, let author = data[K.FStore.authorField] as? String {
                                if sender == Auth.auth().currentUser?.email {
                                    let newBook = Book(sender: sender, bookName: bookName, author: author, idString: doc.documentID)
                                    delegate?.didUpdateBook(self, newBook: newBook)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    func saveBook(sender: String, bookName: String, author: String) {
       
        db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: sender, K.FStore.bookField: bookName, K.FStore.authorField: author]) { error in
            if let e = error {
                print("Error : Saving data to firestore  \(e)")
            }else {
                print("Book saved.")
            }
        }
        
    }
    func deleteBook(selectBook: String) {
        self.db.collection(K.FStore.collectionName).document(selectBook).delete() { error in
            if let e = error {
                print("Error removing document: \(e)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    func logOut() {
        do {
            try Auth.auth().signOut()
            print("Log out success")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
