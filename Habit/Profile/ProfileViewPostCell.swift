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

            timestampLabel.text = createdDate.timeAgoDisplay(userDate: false)
            
            likedBar.layer.backgroundColor = (isViewed == true) ? UIColor.mainBlue().cgColor : UIColor.mainGray().cgColor
            
            viewIcon.image = (isViewed == true) ? #imageLiteral(resourceName: "viewed") : #imageLiteral(resourceName: "view")
            viewCount.textColor = (isViewed == true) ? .mainBlue() : .mainGray()
            viewCount.text = post?.views
        }
    }
    
    let timestampLabel: UILabel = {
        let label = UILabel()
                
        label.numberOfLines = 0
        label.textColor = .mainGray()
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        
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
    
    let viewStatsView: UIView = {
       let view = UIView()
    
        return view
    }()
    
    let viewCount: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .right
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        
        return label
    }()
    
    let viewIcon: CustomImageView = {
        let image = CustomImageView()
                
        return image
    }()
    
    let opaqueCover: UIView = {
        let view = UIView()
        
        view.backgroundColor = .mainGray()
        view.layer.opacity = 0.7
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        addSubview(opaqueCover)
        addSubview(timestampLabel)
                
        opaqueCover.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: frame.width, height: 0)
        
        photoImageView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: frame.width, height: 0)
        
        setupPostStats()
            
        timestampLabel.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: photoImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
         timestampLabel.centerYAnchor.constraint(equalTo: viewStatsView.centerYAnchor).isActive = true

    }
    
    fileprivate func setupPostStats() {
        viewStatsView.addSubview(viewIcon)
        viewStatsView.addSubview(viewCount)

        viewIcon.anchor(top: viewStatsView.topAnchor, left: viewStatsView.leftAnchor, bottom: nil, right: viewStatsView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 17, height: 18)
        viewCount.centerYAnchor.constraint(equalTo: viewStatsView.centerYAnchor).isActive = true

        viewCount.anchor(top: viewStatsView.topAnchor, left: viewIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        viewCount.centerYAnchor.constraint(equalTo: viewIcon.centerYAnchor).isActive = true

        addSubview(viewStatsView)

        viewStatsView.anchor(top: photoImageView.bottomAnchor, left: photoImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 17, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

