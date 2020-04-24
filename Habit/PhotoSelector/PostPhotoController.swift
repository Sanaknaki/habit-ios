//
//  PostPhotoController.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-15.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Firebase

class PostPhotoController: UIViewController {
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }

    let imageView: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        // iv.clipsToBounds = true
        
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handlePost))
        
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handlePost() {
        print(123)
    }
    
}
