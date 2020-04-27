//
//  SearchResultCell.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-24.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            
            guard let joinedDate = user?.joinedDate.timeAgoDisplay(userDate: true) else { return }
            
            let attributedText = NSMutableAttributedString(string: joinedDate + "\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
            
            attributedText.append(NSAttributedString(string: "0 followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
        
            userStatsLabel.attributedText = attributedText
        }
    }
    
    let usernameLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.text = "Username"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        
        return lbl
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

