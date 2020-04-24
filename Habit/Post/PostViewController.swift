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
    
    let previewImageView: CustomImageView = {
        let iv = CustomImageView()
        
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    let cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        
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
        print(123)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainGray()
        
        view.addSubview(previewImageView)
        previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 48, paddingLeft: 0, paddingBottom: 0, paddingRight: 36, width: 20, height: 20)

        view.addSubview(likeButton)
        likeButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 36, paddingRight: 0, width: 35, height: 35)
        likeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

