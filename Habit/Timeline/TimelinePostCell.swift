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
            
            let attributedText = NSMutableAttributedString(string: post.user.username + "\n", attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 18), NSAttributedString.Key.foregroundColor: UIColor.black])
                
            attributedText.append(NSAttributedString(string: post.creationDate.timeAgoDisplay(userDate: false), attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 10), NSAttributedString.Key.foregroundColor: UIColor.mainGray()]))
        
            userNameAndTimestampLabel.attributedText = attributedText
            
            usernameLabel.text = post.user.username
            
            timestampLabel.text = post.creationDate.timeAgoDisplay(userDate: false)
                        
            postImage.layer.cornerRadius = (frame.height - 30) / 2
            
            viewIcon.image = (post.hasViewed == true) ? #imageLiteral(resourceName: "viewed") : #imageLiteral(resourceName: "view")

            viewCount.text = post.views
            viewCount.textColor = (post.hasViewed == true) ? .mainBlue() : .mainGray()
        }
    }

    let timestampLabel: UILabel = {
        let label = UILabel()
                
        label.numberOfLines = 0
        label.textColor = .mainGray()
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        
        return label
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
                
        label.numberOfLines = 0
        label.textColor = .black
        
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        
        return label
    }()
    
    let userNameAndTimestampLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textAlignment = .right
        
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        
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
    
    let viewCount: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .right
        label.font = UIFont(name: "AvenirNext-Regular", size: 10)
        
        return label
    }()
    
    let viewIcon: CustomImageView = {
        let image = CustomImageView()
                
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(postImage)
        addSubview(usernameLabel)
        addSubview(timestampLabel)
        addSubview(viewIcon)
        addSubview(viewCount)
        
        postImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 15, paddingRight: 0, width: frame.height - 30, height: 0)
        
        usernameLabel.anchor(top: postImage.topAnchor, left: postImage.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        timestampLabel.anchor(top: nil, left: postImage.rightAnchor, bottom: postImage.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
            
        viewIcon.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 18, height: 19)
        viewIcon.centerYAnchor.constraint(equalTo: postImage.centerYAnchor).isActive = true
            
        viewCount.anchor(top: nil, left: nil, bottom: nil, right: viewIcon.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        viewCount.centerYAnchor.constraint(equalTo: viewIcon.centerYAnchor).isActive = true
        
        let bottomSeperator = UIView()
        bottomSeperator.backgroundColor = .mainGray()
        addSubview(bottomSeperator)
        bottomSeperator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
