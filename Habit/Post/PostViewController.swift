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
    var hasViewed = false
    
    let previewImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    let usernameAndTimestamp: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        
        return label
    }()
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(#imageLiteral(resourceName: "exit").withRenderingMode(.alwaysOriginal), for: .normal)
        
        btn.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        
        return btn
    }()
        
    @objc func handleClose() {
        NotificationCenter.default.post(name: PostViewController.updateFeedNotificationName, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .mainGray()
        
        view.addSubview(previewImageView)
        previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: 20, height: 20)
        
        view.addSubview(usernameAndTimestamp)
        usernameAndTimestamp.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameAndTimestamp.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
    }
    
    // Can be accessed now by calling it through the class, so can be called from anywhere
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
}

