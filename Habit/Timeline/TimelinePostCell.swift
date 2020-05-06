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
            
            saveIcon.image = (post.hasViewed == false) ? #imageLiteral(resourceName: "saved-stat") : #imageLiteral(resourceName: "save-stat")
            viewCount1.textColor = (post.hasViewed == false) ? .mainBlue() : .mainGray()
            
            let postImageGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageClick))
            let usernameGesture = UITapGestureRecognizer(target: self, action: #selector(handleUsernameClick))
            
            postImage.isUserInteractionEnabled = true
            usernameLabel.isUserInteractionEnabled = true
            
            postImage.addGestureRecognizer(postImageGesture)
            usernameLabel.addGestureRecognizer(usernameGesture)
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
    
    @objc func handleUsernameClick() {
        guard let user = post?.user else { return }
        delegate?.didClickUsername(user: user)
    }
    
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
    
    let viewCount1: UILabel = {
        let label = UILabel()
        
        label.text = "0"
        label.textAlignment = .right
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        
        return label
    }()
    
    let viewIcon: CustomImageView = {
        let image = CustomImageView()
                
        return image
    }()
    
    let saveIcon: CustomImageView = {
        let image = CustomImageView()
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(postImage)
        addSubview(usernameLabel)
        addSubview(timestampLabel)
//        addSubview(viewIcon)
//        addSubview(viewCount)
        
        postImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 15, paddingRight: 0, width: frame.height - 30, height: 0)
        
        usernameLabel.anchor(top: postImage.topAnchor, left: postImage.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        timestampLabel.anchor(top: nil, left: postImage.rightAnchor, bottom: postImage.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
//        timestampLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        setupPostStats()
//
//        viewCount.anchor(top: nil, left: postImage.rightAnchor, bottom: postImage.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
//
//        viewIcon.anchor(top: nil, left: viewCount.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 18, height: 19)
//        viewIcon.centerYAnchor.constraint(equalTo: viewCount.centerYAnchor).isActive = true
            
        
        let bottomSeperator = UIView()
        bottomSeperator.backgroundColor = .mainGray()
        addSubview(bottomSeperator)
        bottomSeperator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    fileprivate func setupPostStats() {
        let viewsView = UIView()
        viewsView.addSubview(viewCount)
        viewsView.addSubview(viewIcon)
        
        viewCount.anchor(top: viewsView.topAnchor, left: viewsView.leftAnchor, bottom: viewsView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        viewIcon.anchor(top: nil, left: viewCount.rightAnchor, bottom: nil, right: viewsView.rightAnchor, paddingTop: 0, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 18, height: 19)
        viewIcon.centerYAnchor.constraint(equalTo: viewCount.centerYAnchor).isActive = true
        
        let savesView = UIView()
        savesView.addSubview(viewCount1)
        savesView.addSubview(saveIcon)
        
        viewCount1.anchor(top: savesView.topAnchor, left: savesView.leftAnchor, bottom: savesView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        saveIcon.anchor(top: nil, left: viewCount1.rightAnchor, bottom: nil, right: savesView.rightAnchor, paddingTop: 0, paddingLeft: 3, paddingBottom: 0, paddingRight: 0, width: 18, height: 19)
        
        addSubview(viewsView)
//        addSubview(savesView)

        viewsView.anchor(top: postImage.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        viewsView.centerYAnchor.constraint(equalTo: postImage.centerYAnchor).isActive = true
//        savesView.anchor(top: nil, left: nil, bottom: postImage.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 15, width: 0, height: 0)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
