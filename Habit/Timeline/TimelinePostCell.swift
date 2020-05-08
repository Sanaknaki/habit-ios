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
                        
            postImage.layer.cornerRadius = 120 / 2
            
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
        
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        
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
        
        let expandTransform:CGAffineTransform = CGAffineTransform(scaleX: 1.15, y: 1.15);
        UIView.transition(with: self.postImage,
            duration:0.3,
            options: UIView.AnimationOptions.transitionCrossDissolve,
            animations: {
              self.postImage.transform = expandTransform
            },
            completion: {(finished: Bool) in
                UIView.animate(withDuration: 0.5,
                delay:0.0,
                usingSpringWithDamping:0.50,
                initialSpringVelocity:0.2,
                options:UIView.AnimationOptions.curveEaseOut,
                animations: {
                    self.postImage.transform = expandTransform.inverted()
                }, completion:nil)
          })
        
         delegate?.didClickPostImage(post: post, index: indexPath)
    }
    
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
    
    let bottomSeperator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .mainGray()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postImage)
        addSubview(usernameLabel)
        addSubview(timestampLabel)
        addSubview(bottomSeperator)
        
        bottomSeperator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 100, paddingBottom: 0, paddingRight: 100, width: 0, height: 0.5)
        
        postImage.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        postImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        postImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        setupPostStats()
                
        usernameLabel.anchor(top: topAnchor, left: nil, bottom: postImage.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        timestampLabel.anchor(top: nil, left: nil, bottom: nil, right: postImage.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        timestampLabel.centerYAnchor.constraint(equalTo: viewIcon.centerYAnchor).isActive = true
    }
    
    fileprivate func setupPostStats() {        
        viewStatsView.addSubview(viewIcon)
        viewStatsView.addSubview(viewCount)
                
        viewIcon.anchor(top: viewStatsView.topAnchor, left: viewStatsView.leftAnchor, bottom: nil, right: viewStatsView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 17, height: 18)
        viewCount.centerYAnchor.constraint(equalTo: viewStatsView.centerYAnchor).isActive = true
        
        viewCount.anchor(top: viewStatsView.topAnchor, left: viewIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        viewCount.centerYAnchor.constraint(equalTo: viewIcon.centerYAnchor).isActive = true
        
        addSubview(viewStatsView)
        
        viewStatsView.anchor(top: postImage.bottomAnchor, left: postImage.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 17, height: 18)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
