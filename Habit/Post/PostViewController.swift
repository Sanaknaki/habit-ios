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
        
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = .zero
        label.layer.shadowRadius = 1
        
        return label
    }()
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(#imageLiteral(resourceName: "exit").withRenderingMode(.alwaysOriginal), for: .normal)
        
        btn.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowOffset = .zero
        btn.layer.shadowRadius = 1
        
        return btn
    }()
        
    @objc func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
        
    let viewCount: UILabel = {
        let label = UILabel()
        
        label.text = "0"
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.textColor = .white
        
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = .zero
        label.layer.shadowRadius = 1
        
        return label
    }()
    
    let viewIcon: CustomImageView = {
        let image = CustomImageView()
        
        image.image = #imageLiteral(resourceName: "view-post")

        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOpacity = 1
        image.layer.shadowOffset = .zero
        image.layer.shadowRadius = 1
        
        return image
    }()
    
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
        
        view.addSubview(viewIcon)
        view.addSubview(viewCount)
                
        viewIcon.anchor(top: nil, left: nil, bottom: viewCount.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 34, height: 35)
        viewCount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewCount.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 40, paddingRight: 0, width: 0, height: 0)
        viewCount.centerXAnchor.constraint(equalTo: viewIcon.centerXAnchor).isActive = true
    }
}

