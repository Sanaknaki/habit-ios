//
//  PostViewController.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-22.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Photos
import Firebase

class PostViewController: UIViewController {
    
    var postId = ""
    var hasLiked = false
    
    let previewImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    let cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(#imageLiteral(resourceName: "exit").withRenderingMode(.alwaysOriginal), for: .normal)
        
        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        
        return btn
    }()
        
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    let likeButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(#imageLiteral(resourceName: "star").withRenderingMode(.alwaysOriginal), for: .normal)
        
        btn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func handleLike() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: hasLiked == true ? 0 : 1]
        
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to like post: ", err)
                return
            }
            
            print("Successfully liked post!")
            
            self.hasLiked = !self.hasLiked
            
            // Notified app with a specific name to update feed given the name, must add observer in the HomeController
            NotificationCenter.default.post(name: PostViewController.updateFeedNotificationName, object: nil)
            
            self.viewDidLoad()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeButton.setImage(hasLiked == true ? #imageLiteral(resourceName: "star-clicked").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "star").withRenderingMode(.alwaysOriginal), for: .normal)
        
        view.backgroundColor = .mainGray()
        
        view.addSubview(previewImageView)
        previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 48, paddingLeft: 0, paddingBottom: 0, paddingRight: 36, width: 20, height: 20)

        view.addSubview(likeButton)
        likeButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 36, paddingRight: 0, width: 35, height: 35)
        likeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // Can be accessed now by calling it through the class, so can be called from anywhere
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
}

