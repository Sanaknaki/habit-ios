//
//  Post.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-22.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import Foundation

struct Post {

    var id: String?
    
    let user: User
    let imageUrl: String
    let creationDate: Date
    
    var hasLiked = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
