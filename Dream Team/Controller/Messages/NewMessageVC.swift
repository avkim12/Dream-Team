//
//  NewMessageVC.swift
//  Dream Team
//
//  Created by Student on 5/26/20.
//  Copyright © 2020 Alla Kim. All rights reserved.
//

import UIKit
import Firebase

fileprivate let cellId = "newMessageCellId"

class NewMessageVC: UITableViewController {

    var users = [User]()
    var messagesVC: MessagesVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: cellId)
        
        configureNavigationBar()
        fetchUsers()
    }
    
    // MARK: - API
    
    func fetchUsers() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, err) in
            if let err = err {
                print("Failed to fetch users: ", err.localizedDescription)
                return
            }
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                
                self.users.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewMessageCell
        
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesVC?.showChatController(for: user)
        }
    }
    
    fileprivate func configureNavigationBar() {
        navigationItem.title = "New messages"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

}
