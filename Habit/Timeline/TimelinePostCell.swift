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
            
            let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white])
            
            attributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
            
            let timeAgoDisplay = post.creationDate.timeAgoDisplay(userDate: false)
            attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
            
            userNameAndTimestampLabel.attributedText = attributedText
        }
    }
    
    let userNameAndTimestampLabel: UILabel = {
        let label = UILabel()
                
//        let attributedText = NSMutableAttributedString(string: "@username\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white])
//
//        attributedText.append(NSAttributedString(string: "12m ago", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        
//        label.attributedText = attributedText
        label.numberOfLines = 0
        
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    let postImage: CustomImageView = {
        let postImage = CustomImageView()
        
        postImage.backgroundColor = .lightGray
        postImage.layer.cornerRadius = 10
        
        return postImage
    }()
    
    let likedButton: UIButton = {
        let btn = UIButton()
        
        btn.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(postImage)

        
        postImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
        postImage.addSubview(userNameAndTimestampLabel)
        postImage.addSubview(likedButton)
        
        userNameAndTimestampLabel.anchor(top: nil, left: postImage.leftAnchor, bottom: postImage.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        
        likedButton.anchor(top: nil, left: nil, bottom: postImage.bottomAnchor, right: postImage.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 20, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
