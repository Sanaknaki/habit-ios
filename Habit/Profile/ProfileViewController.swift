//
//  ProfileViewController.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-12.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.view.backgroundColor = .white
        
        collectionView.backgroundColor = .white
        collectionView.register(ProfileViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(ProfileViewPostCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigationBar()
        
        fetchUser()
    }
    
    // To be called in fetchUser() and header
    var user: User?
    
    fileprivate func fetchUser() {
        
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
        // Call the extension
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user

            self.collectionView?.reloadData()
            
            // Get posts when you get the right user
            self.paginatePosts()
        }
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profile-clicked").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLeaveProfile))
    }

    @objc func handleLeaveProfile() {
        navigationController?.popViewController(animated: true)
    }

    // Render out the size of the header section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    // Build the header, give it an Id to be altered
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Downcast to be the UserProfileHeader
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ProfileViewHeader
        
        header.usernameLabel.text = user?.username
        
        return header
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((view.frame.width) / 2)
        let height = ((view.frame.height) / 3)
        
        return CGSize(width: width, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Fire off paginate call
        if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
            paginatePosts()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileViewPostCell
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    var posts = [Post]()
    var isFinishedPaging = false
    
    fileprivate func paginatePosts() {
        print("Start paging for more posts.")
        
        // Get user of profile, could be you, could be someone you searching
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        // Limit results by toFirst
        var query = ref.queryOrdered(byChild: "creationDate")
        
        // Grab last cell posted
        if posts.count > 0 {
            let value = posts.last?.creationDate.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // All of the remaining objects in snapshot
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.reverse()
            
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.posts.count > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
            }

            guard let user = self.user else { return }
            
            allObjects.forEach ({ (snapshot) in
                // print(snapshot.key)
                
                guard let dict = snapshot.value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dict)
                
                post.id = snapshot.key // have to capture post id
                self.posts.append(post)
            })
            
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to paginate for posts: ", err)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let containerView = PostViewController()
        
        containerView.previewImageView.loadImage(urlString: posts[indexPath.item].imageUrl)
        
        let navController = UINavigationController(rootViewController: containerView)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated:true, completion: nil)
        
    }
    
}

