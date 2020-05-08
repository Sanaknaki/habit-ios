//
//  SearchResultCell.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-24.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Firebase

class SearchResultCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            
            guard let joinedDate = user?.joinedDate.timeAgoDisplay(userDate: true) else { return }
            guard let uid = user?.uid else { return }
            
            let ref = Database.database().reference().child("followers").child(uid)
            var followers = "0"
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                followers = String(snapshot.childrenCount)
                let grammarFollower = (Int(followers) ?? 0 < 1 || Int(followers) ?? 0 > 1) ? " followers" : " follower"
                    
                let attributedText = NSAttributedString(string: followers + " " + grammarFollower, attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
                
                self.userStatsLabel.attributedText = attributedText
            })
        }
    }
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Username"

        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        
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
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

