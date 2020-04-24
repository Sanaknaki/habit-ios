//
//  User.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-22.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import Foundation

// User object that we will use to manipulate the header components
struct User {
    let uid: String
    let username: String
    
    init(uid: String, dict: [String: Any]) {
        self.uid = uid
        self.username = dict["username"] as? String ?? ""
    }
}

