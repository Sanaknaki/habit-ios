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
    
    lazy var followFollowingButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.titleLabel?.isHidden = true

        button.addTarget(self, action: #selector(handleFollowFollowing), for: .touchUpInside)
        return button
    }()
    
    @objc func handleFollowFollowing() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return } // You
        guard let userId = userId else { return } // User you about to follow/unfollow
        
        let refFollowing = Database.database().reference().child("following").child(currentLoggedInUserId) // Get list of people you following
        let refFollowers = Database.database().reference().child("followers").child(userId) // Get list of people that user has following them
        
        guard let image = followFollowingButton.image(for: .normal) else { return }
        let imageOfButtonYouClick = image.pngData()
        let imageOfFollowingButton = #imageLiteral(resourceName: "following").pngData()
        
        if imageOfButtonYouClick == imageOfFollowingButton {
            // Remove (nodeOfUser) in (userLoggedInID) { (nodeOfUser) }
            refFollowing.removeValue { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user: ", err)
                    return
                }
                
                print("Successfully unfollowed user: ", self.user?.username ?? "")
            }
            
            // Remove (userLoggedInID) in (nodeOfUser) { (userLoggedInID) }
            refFollowers.removeValue { (err, ref) in
                if let err = err {
                    print("Failed to remove follower for user: ", err)
                    return
                }
                
                print("Successfully lost a follower ", self.user?.username ?? "")
            }
            
            followFollowingButton.setImage(#imageLiteral(resourceName: "follow"), for: .normal)
        } else {
            // Follow
            let followingValues = [userId: 1]
            refFollowing.updateChildValues(followingValues) { (err, ref) in
                if let err = err {
                    print("Failed to follow user: ", err)
                    return
                }
                
                print("Successfully followed user: ", self.user?.username ?? "")
            }
            
            let followerValues = [currentLoggedInUserId: 1]
            refFollowers.updateChildValues(followerValues) { (err, ref) in
                if let err = err {
                    print("Failed to add to users followers list: ", err)
                    return
                }
                
                print(currentLoggedInUserId + " has successfully added follower to this user " + userId)
            }
            
            followFollowingButton.setImage(#imageLiteral(resourceName: "following"), for: .normal)
        }
    }
    
    lazy var signOutBarButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.mainBlue(), for: .normal)
        button.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()

                // Want to wrap the login view controller in navControl to not push the registration view onto the stack
                let loginOrSignupScreen = LoginOrSignUpScreen()
                let navController = UINavigationController(rootViewController: loginOrSignupScreen)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            } catch let signOutErr {
                print("Failed to sign out: ", signOutErr)
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.modalPresentationStyle = .fullScreen
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        collectionView.backgroundColor = .white
        collectionView.register(ProfileViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(ProfileViewPostCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigationBar()
        
        collectionView.alwaysBounceVertical = true
        
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
        
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackClick))
        navigationItem.setHidesBackButton(true, animated: false)
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return } // You
        guard let userId = userId else { return } // User profile who you're on
        
        if currentLoggedInUserId == userId { // If you're on your own page
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOutBarButton)
        } else {
            // Check if following
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            ref.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.followFollowingButton.setImage(#imageLiteral(resourceName: "following"), for: .normal)
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.followFollowingButton)
                } else {
                    self.followFollowingButton.setImage(#imageLiteral(resourceName: "follow"), for: .normal)
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.followFollowingButton)
                }
            }, withCancel: { (err) in
                print("Failed to check if following: ", err)
            })
            
        }
    }
    
    @objc func handleBackClick() {
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
        
        let joinedDate = user?.joinedDate.timeAgoDisplay(userDate: true) ?? ""
        
        let attributedText = NSMutableAttributedString(string: joinedDate + "\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.mainGray()])
        attributedText.append(NSAttributedString(string: "0 followers", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.mainGray()]))
        
        header.userStatsLabel.attributedText = attributedText
        
        return header
    }

    // Up/Down spacing
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }
    
    // Right/Left spacing
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((view.frame.width / 3 ) - 40)
        let height = ((view.frame.height) / 6) - 40
        
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

