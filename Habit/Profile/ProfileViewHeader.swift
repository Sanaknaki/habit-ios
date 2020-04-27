//
//  ProfileViewHeader.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-21.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit

class ProfileViewHeader: UICollectionViewCell {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        
        label.text = ""
        
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    let userStatsLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textAlignment = .right
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(usernameLabel)
        addSubview(userStatsLabel)
        
        usernameLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 18, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        userStatsLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 18, width: 0, height: 0)
        userStatsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
