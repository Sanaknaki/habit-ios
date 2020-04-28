//
//  TimelineViewController.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-12.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Firebase

class TimelineViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
        
    let cellId = "cellId"
    
    var posts = [Post]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        collectionView.backgroundColor = .white
        collectionView.register(TimelinePostCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigationBar()
        
        fetchAllPosts()
        
        collectionView.alwaysBounceVertical = true
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearchClick))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profile").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleProfileClick))
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    @objc func handleSearchClick() {
        let searchViewController = SearchViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @objc func handleProfileClick() {
        let profileViewController = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        profileViewController.userId = currentUserId
        
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    // Do as it says
    fileprivate func fetchAllPosts() {
        fetchYourPosts()
        
        fetchUsersYouFollow()
    }
    
    fileprivate func fetchYourPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchUsersYouFollow() {
        guard let uid = Auth.auth().currentUser?.uid else { return } // Grab your ID
        
        // Grab people you follow shove them in a dict for ["ID" : 1]
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDict = snapshot.value as? [String: Any] else { return }
            userIdsDict.forEach({ (key: String, value: Any) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
            
            
        }) { (err) in
            print("Failed to fetch following user ids: ", err)
        }
    }
    
    // We want to show posts of a User, not 'currentUser', that would be just you.
    fileprivate func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Stop the refresh
            self.collectionView.refreshControl?.endRefreshing()
            
            guard let dicts = snapshot.value as? [String: Any] else { return }
            
            // Value would be the attributes
            dicts.forEach({ (key: String, value: Any) in
                guard let dict = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dict)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    
                    
                    self.posts.append(post)
                    
                    // Show earliest posts first
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    
                    self.collectionView?.reloadData()
                    
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post: ", err)
                })
            })
        }) { (err) in
            print("Failed to fetch posts: ", err)
        }
    }
    
    // Right/Left spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // Up/Down spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((view.frame.width-10) / 2)
        let height = ((view.frame.height-10) / 3)
        
        return CGSize(width: width, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TimelinePostCell
        
        if(posts.count == 0) {
            return cell
        }
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
}
