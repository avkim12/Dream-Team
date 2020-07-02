//
//  User.swift
//  Dream Team
//
//  Created by Student on 5/25/20.
//  Copyright © 2020 Alla Kim. All rights reserved.
//

import Foundation

class User {

    var name: String!
    var username: String!
    var profileImage: String!
    var uid: String!
    
    init(dictionary: [String: Any]) {
        
        self.name = dictionary["name"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImage = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
