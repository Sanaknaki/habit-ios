//
//  TimelinePostCell.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-12.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Firebase

protocol TimeLinePostCellDelegate {
    func didClickPostImage(post: Post, index: IndexPath)
    func didClickUsername(user: User)
}

class TimelinePostCell: UICollectionViewCell {
    
    var delegate: TimeLinePostCellDelegate?
    var indexPath: IndexPath?
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            guard let post = post else { return }
            postImage.loadImage(urlString: postImageUrl)
            
            // Username and post date for post
            usernameLabel.text = post.user.username
            
            timestampLabel.text = post.creationDate.timeAgoDisplay(userDate: false)
                        
            postImage.layer.cornerRadius = (frame.height - 30) / 2
            
            viewIcon.image = (post.hasViewed == true) ? #imageLiteral(resourceName: "viewed") : #imageLiteral(resourceName: "view")
            viewCount.text = post.views
            viewCount.textColor = (post.hasViewed == true) ? .mainBlue() : .mainGray()
            
            let postImageGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageClick))
            let usernameGesture = UITapGestureRecognizer(target: self, action: #selector(handleUsernameClick))
            
            postImage.isUserInteractionEnabled = true
            usernameLabel.isUserInteractionEnabled = true
            
            postImage.addGestureRecognizer(postImageGesture)
            usernameLabel.addGestureRecognizer(usernameGesture)
        }
    }
    
    let usernameTimeStampView: UIView = {
        let view = UIView()
                
        return view
    }()
    
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
    
    @objc func handleUsernameClick() {
        guard let user = post?.user else { return }
        delegate?.didClickUsername(user: user)
    }
    
    let viewStatsView: UIView = {
       let view = UIView()
    
        return view
    }()
    
    let postImage: CustomImageView = {
        let postImage = CustomImageView()
        
        postImage.backgroundColor = .lightGray
        postImage.contentMode = .scaleAspectFill
        postImage.clipsToBounds = true
    
        return postImage
    }()
    
    @objc func handleImageClick() {
        guard let post = post else { return }
        guard let indexPath = indexPath else { return }
        
        delegate?.didClickPostImage(post: post, index: indexPath)
    }
    
    let viewCount: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .right
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        
        return label
    }()
    
    let viewIcon: CustomImageView = {
        let image = CustomImageView()
                
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(postImage)
        
        postImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 15, paddingRight: 0, width: frame.height - 30, height: 0)
        
        setupPostStats()
        setupUserNameAndTimeStamp()
        
        let bottomSeperator = UIView()
        bottomSeperator.backgroundColor = .mainGray()
        addSubview(bottomSeperator)
        bottomSeperator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    fileprivate func setupPostStats() {
        viewStatsView.addSubview(viewIcon)
        viewStatsView.addSubview(viewCount)
        
        viewIcon.anchor(top: nil, left: nil, bottom: nil, right: viewStatsView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 24, height: 25)
        viewIcon.centerYAnchor.constraint(equalTo: viewStatsView.centerYAnchor).isActive = true
    
        viewCount.anchor(top: viewIcon.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        viewCount.centerXAnchor.constraint(equalTo: viewIcon.centerXAnchor).isActive = true
        
        addSubview(viewStatsView)

        viewStatsView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 24, height: frame.height)
        viewStatsView.centerYAnchor.constraint(equalTo: postImage.centerYAnchor).isActive = true
    }

    fileprivate func setupUserNameAndTimeStamp() {
        addSubview(usernameTimeStampView)
        usernameTimeStampView.addSubview(usernameLabel)
        usernameTimeStampView.addSubview(timestampLabel)

        usernameLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: usernameTimeStampView.centerXAnchor).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: usernameTimeStampView.centerYAnchor).isActive = true

        timestampLabel.anchor(top: usernameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        timestampLabel.centerXAnchor.constraint(equalTo: usernameLabel.centerXAnchor).isActive = true
    
        addSubview(usernameTimeStampView)

        usernameTimeStampView.anchor(top: nil, left: postImage.rightAnchor, bottom: nil, right: viewStatsView.leftAnchor, paddingTop: 0, paddingLeft: 55, paddingBottom: 0, paddingRight: 55, width: (frame.width), height: 50)
        usernameTimeStampView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
