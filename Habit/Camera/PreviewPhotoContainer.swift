//
//  PreviewPhotoContainer.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-21.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Photos
import Firebase

class PreviewPhotoContainer: UIView {
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    let cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(#imageLiteral(resourceName: "exit").withRenderingMode(.alwaysOriginal), for: .normal)
        
        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowOffset = .zero
        btn.layer.shadowRadius = 1
        
        return btn
    }()
    
    @objc func handleCancel() {
        self.removeFromSuperview()
    }
    
    let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setImage(#imageLiteral(resourceName: "save").withRenderingMode(.alwaysOriginal), for: .normal)
        
        btn.addTarget(self, action: #selector(handleSave), for: .touchUpInside) 
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowOffset = .zero
        btn.layer.shadowRadius = 1
        
        return btn
    }()
    
    let alreadyPostedButton: UIButton = {
        let btn = UIButton()
        
        btn.backgroundColor = .none
        btn.layer.cornerRadius = 20
        
        btn.setTitle("YOU ALREADY POSTED TODAY", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        btn.setTitleColor(.mainRed(), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return btn
    }()
    
    let postButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.backgroundColor = .none
        btn.layer.cornerRadius = 20
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 2
        
        btn.setTitle("POST", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        btn.setTitleColor(.white, for: .normal)

        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowOffset = .zero
        btn.layer.shadowRadius = 1
        
        btn.titleEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 10)
        
        btn.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        
        return btn
    }()
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    @objc func handlePost() {
        guard let image = previewImageView.image else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        // When clicking post, disable the button to not spam
        postButton.isEnabled = false
        
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (downloadURL, err) in
            if let err = err {
                self.postButton.isEnabled = false
                print("Failed to upload post image: ", err)
                DispatchQueue.main.async {
                    let label = UILabel()
                    label.text = "Couldn't post photo, try again later!"
                    label.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
                    label.textColor = .white
                    label.textAlignment = .center
                    label.numberOfLines = 0
                    label.backgroundColor = UIColor(white: 0, alpha: 0.3)
                    
                    label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 75)
                    label.center = self.center
                    
                    self.addSubview(label)
                    
                    label.layer.transform = CATransform3DMakeScale(0, 0, 0)
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        label.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    }) { (completed) in
                        UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                            
                            label.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                            label.alpha = 0
                            
                        }) { (_) in
                            label.removeFromSuperview()
                        }
                    }
                }
                return
            }
            
            // Get storage ref to grab the URL of image you just uploaded
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to fetch download URL: ", err)
                    return
                }
                
                guard let imageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded post image: ", imageUrl)
                
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            })
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        // Get image
        guard let postImage = previewImageView.image else { return }
        
        // Grab user UID
        guard let uid = Auth.auth().currentUser?.uid else { return }
    
        let userPostRef = Database.database().reference().child("posts").child(uid)
        
        // Generates new child location using uKey returning Database reference location, good for list of items, aka posts.
        let ref = userPostRef.childByAutoId()
        
        // Gotta cast it because it fits string to many different forms of values
        let values = ["imageUrl": imageUrl, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String: Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.postButton.isEnabled = false
                print("Failed to save post to DB: ", err)
                return
            }
            
            print("Successfully saved post to DB!")
            
            // Succesffully saved, dismiss view
            // self.dismiss(animated: true, completion: nil)
            self.handleCancel()
            
            // Notified app with a specific name to update feed given the name, must add observer in the HomeController
            NotificationCenter.default.post(name: PreviewPhotoContainer.updateFeedNotificationName, object: nil)
        }
    }
    
    @objc func handleSave() {
        
        guard let previewImage = previewImageView.image else { return }
        
        let library = PHPhotoLibrary.shared()
        
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, err) in
            if let err = err {
                print("Failed to save photo to library: ", err)
                return
            }
            
            print("Successfully saved image to library!")
            
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully!"
                savedLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
                savedLabel.textColor = .white
                savedLabel.textAlignment = .center
                savedLabel.numberOfLines = 0
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                
                savedLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 75)
                savedLabel.center = self.center
                
                self.addSubview(savedLabel)
                
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }) { (completed) in
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                        
                    }) { (_) in
                        savedLabel.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
        
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 36, paddingLeft: 0, paddingBottom: 0, paddingRight: 36, width: 20, height: 20)
                
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 36, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        saveButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
        
        handleShowingButton()
    }
    
    fileprivate func handleShowingButton() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let calendar = Calendar.current
        
        let ref = Database.database().reference().child("posts").child(uid).queryLimited(toLast: 1)
        
        ref.observe(.value) { (snapshot) in
            let dict = snapshot.value as? [String : Any]
            let dictValues = dict?.first?.value as? [String : Any]

            let dateFormatted = Date(timeIntervalSince1970: dictValues?["creationDate"] as? Double ?? 0)
            
            if((calendar.isDateInToday(dateFormatted))) {
                self.addSubview(self.alreadyPostedButton)
                self.alreadyPostedButton.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 36, paddingRight: 50, width: 0, height: 60)
                self.alreadyPostedButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            } else {
                self.addSubview(self.postButton)
                self.postButton.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 36, paddingRight: 50, width: 0, height: 60)
                self.postButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

