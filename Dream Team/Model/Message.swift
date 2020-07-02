//
//  Message.swift
//  Dream Team
//
//  Created by Student on 28.05.2020.
//  Copyright © 2020 Alla Kim. All rights reserved.
//


import UIKit
import Firebase

class Message {
    
    let text, fromID, toID: String
    let timestamp: Timestamp
    let isMessageFromCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromID = dictionary["fromID"] as? String ?? ""
        self.toID = dictionary["told"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isMessageFromCurrentUser = Auth.auth().currentUser?.uid == self.fromID
    }
}
