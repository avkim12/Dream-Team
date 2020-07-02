//
//  MessagesVC.swift
//  Dream Team
//
//  Created by Student on 5/26/20.
//  Copyright © 2020 Alla Kim. All rights reserved.
//

import UIKit
import Firebase

fileprivate let cellId = "cellId"

class MessagesVC: UITableViewController {
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MessagesCell.self, forCellReuseIdentifier: cellId)
        
        configureNavigationBar()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessagesCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("asdasd")
    }
    
    fileprivate func configureNavigationBar() {
        navigationItem.title = "Messages"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMessage))
    }
    
    @objc fileprivate func createMessage() {
        let newMessageVC = NewMessageVC()
        newMessageVC.messagesVC = self
        let navigationController = UINavigationController(rootViewController: newMessageVC)
        
        present(navigationController, animated: true, completion: nil)
        
    }
    
    func showChatController(for user: User) {
        print("show user")
        let chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.user = user
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
