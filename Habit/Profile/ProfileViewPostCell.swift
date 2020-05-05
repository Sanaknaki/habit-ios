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
            guard let createdDate = post?.creationDate else { return }
            guard let isViewed = post?.hasViewed else { return }
            
            // Load the image for the post
            photoImageView.loadImage(urlString: imageUrl)
            
//            photoImageView.layer.borderColor = (isLiked == true) ? UIColor.mainBlue().cgColor : UIColor.mainGray().cgColor
//            photoImageView.layer.borderWidth = 3

            timestampLabel.text = createdDate.timeAgoDisplay(userDate: false)
            
            likedBar.layer.backgroundColor = (isViewed == true) ? UIColor.mainBlue().cgColor : UIColor.mainGray().cgColor
        }
    }
    
    let timestampLabel: UILabel = {
        let label = UILabel()
                
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 10)
        
        return label
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        
        iv.backgroundColor = UIColor.mainGray()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        iv.layer.cornerRadius = 5
        
        return iv
    }()
    
    let likedButton: UIButton = {
        let btn = UIButton()
        
        btn.setImage(#imageLiteral(resourceName: "star").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return btn
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
        
        addSubview(photoImageView)
        addSubview(timestampLabel)
        addSubview(likedBar)
        
        // photoImageView.layer.cornerRadius = self.frame.width / 2
        photoImageView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: frame.width, height: 0)
        
        likedBar.anchor(top: photoImageView.bottomAnchor, left: photoImageView.leftAnchor, bottom: nil, right: photoImageView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 5)
//        photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        // photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
        timestampLabel.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        timestampLabel.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor).isActive = true
//
//        likedButton.anchor(top: nil, left: nil, bottom: photoImageView.bottomAnchor, right: photoImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 20, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

