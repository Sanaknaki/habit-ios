//
//  ProfileViewPostCell.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-21.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewPostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            guard let username = post?.user.username else { return }
            guard let createdDate = post?.creationDate else { return }
            
            // Load the image for the post
            photoImageView.loadImage(urlString: imageUrl)
            
            // Load creted date for the post
            let attributedText = NSMutableAttributedString(string: username + "\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white])
            
            attributedText.append(NSAttributedString(string: createdDate.timeAgoDisplay(userDate: false), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
            
            userNameAndTimestampLabel.attributedText = attributedText
        }
    }
    
    let userNameAndTimestampLabel: UILabel = {
        let label = UILabel()
                
        label.numberOfLines = 0
                
        label.layer.shadowColor = UIColor.black.cgColor;
        label.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.layer.shadowOpacity = 0.5;
        label.layer.shadowRadius = 0.5;
        return label
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        
        iv.backgroundColor = UIColor.mainGray()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let likedButton: UIButton = {
        let btn = UIButton()
        
        btn.setImage(#imageLiteral(resourceName: "star").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(photoImageView)
        photoImageView.layer.cornerRadius = self.frame.width / 2
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
//        photoImageView.addSubview(userNameAndTimestampLabel)
//        photoImageView.addSubview(likedButton)
//
//        userNameAndTimestampLabel.anchor(top: nil, left: photoImageView.leftAnchor, bottom: photoImageView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
//
//        likedButton.anchor(top: nil, left: nil, bottom: photoImageView.bottomAnchor, right: photoImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 20, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

