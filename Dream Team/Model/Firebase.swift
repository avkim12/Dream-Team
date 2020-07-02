//
//  Firebase.swift
//  Dream Team
//
//  Created by Student on 5/25/20.
//  Copyright © 2020 Alla Kim. All rights reserved.
//

import UIKit
import Firebase

extension Firestore {
    
    func fetchCurrentUser(completion: @escaping (User?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user, nil)
        }
    }
}
