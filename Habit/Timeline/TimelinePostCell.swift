//
//  TimelinePostCell.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-12.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import Foundation
import UIKit

class TimelinePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            guard let post = post else { return }
            postImage.loadImage(urlString: postImageUrl)
            
            // Username and post date for post
            
            let attributedText = NSMutableAttributedString(string: post.user.username + "\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.black])
                
            attributedText.append(NSAttributedString(string: post.creationDate.timeAgoDisplay(userDate: false), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.mainGray()]))
        
            userNameAndTimestampLabel.attributedText = attributedText
            
            usernameLabel.text = post.user.username
            
            timestampLabel.text = post.creationDate.timeAgoDisplay(userDate: false)
                        
            postImage.layer.cornerRadius = (frame.height - 30) / 2
            
            likedBar.layer.backgroundColor = (post.hasLiked == true) ? UIColor.mainBlue().cgColor : UIColor.mainGray().cgColor
        }
    }

    let timestampLabel: UILabel = {
        let label = UILabel()
                
        label.numberOfLines = 0
        label.textColor = .mainGray()
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
                
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    let userNameAndTimestampLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textAlignment = .right
        
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    let postImage: CustomImageView = {
        let postImage = CustomImageView()
        
        postImage.backgroundColor = .lightGray
        postImage.contentMode = .scaleAspectFill
        postImage.clipsToBounds = true
        
        // postImage.layer.cornerRadius = (postImage.frame.height - 20) / 2
        
        return postImage
    }()

    let likedBar: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.mainGray()
        view.layer.cornerRadius = 2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(postImage)
        // addSubview(userNameAndTimestampLabel)
        addSubview(usernameLabel)
        addSubview(timestampLabel)
        addSubview(likedBar)
        
        postImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 15, paddingRight: 0, width: frame.height - 30, height: 0)
        
//        userNameAndTimestampLabel.anchor(top: nil, left: nil, bottom: nil, right: likedBar.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
//        userNameAndTimestampLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: nil, left: postImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        timestampLabel.anchor(top: nil, left: nil, bottom: nil, right: likedBar.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        timestampLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        likedBar.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 5, height: 0)
        
        let bottomSeperator = UIView()
        bottomSeperator.backgroundColor = .mainGray()
        addSubview(bottomSeperator)
        bottomSeperator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
