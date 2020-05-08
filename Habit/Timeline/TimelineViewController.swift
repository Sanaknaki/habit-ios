//
//  TimelineViewController.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-12.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Firebase

class TimelineViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, TimeLinePostCellDelegate {
    let cellId = "cellId"
    
    var posts = [Post]()
    
    weak var cell: TimelinePostCell!
    
    let noPostsIcon: CustomImageView = {
        let image = CustomImageView()
        
        image.image = #imageLiteral(resourceName: "icon-grey").withRenderingMode(.alwaysOriginal)
        
        return image
    }()
    
    let noPostsMessage: UILabel = {
        let label = UILabel()
        
        label.text = "Start your Habit by making a post."
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        label.textColor = .mainGray()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: PreviewPhotoContainer.updateFeedNotificationName, object: nil)
        
        // Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        collectionView.backgroundColor = .white
        collectionView.register(TimelinePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationBar()
        
        fetchAllPosts()
        
        showNoPosts()
        
//        if(posts.count == 0) {
//            collectionView.alwaysBounceVertical = false
//        } else {
//            collectionView.alwaysBounceVertical = true
//        }
    }
    
    // Auto update when we upload a new post
    @objc func handleUpdateFeed() { handleRefresh() }
    
    @objc func handleRefresh() {
        print("Handling Refresh...")
        
        // Reset the posts and then you will refetch with new following info and such
        posts.removeAll()
        
        noPostsIcon.isHidden = true
        noPostsMessage.isHidden = true
        
        fetchAllPosts()
    }
    
    fileprivate func showNoPosts() {
        if(posts.count == 0) {
            view.addSubview(noPostsIcon)
            view.addSubview(noPostsMessage)
            
            noPostsIcon.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
            noPostsIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noPostsIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            noPostsIcon.isHidden = false
            
            noPostsMessage.anchor(top: noPostsIcon.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            noPostsMessage.centerXAnchor.constraint(equalTo: noPostsIcon.centerXAnchor).isActive = true
            noPostsMessage.isHidden = false
            
            collectionView.alwaysBounceVertical = false
        } else {
            noPostsIcon.isHidden = true
            noPostsMessage.isHidden = true
            
            collectionView.alwaysBounceVertical = true
        }
    }
    
    fileprivate func setupNavigationBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearchClick))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "profile").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleProfileClick))
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
                                                
                Database.database().reference().child("views").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    let hasViewed = snapshot.childSnapshot(forPath: uid).value
                    let views =  snapshot.childrenCount
                                        
                    post.views = String(views)
                    
                    if let value = hasViewed as? Int, value == 1 {
                        post.hasViewed = true
                    } else {
                        post.hasViewed = false
                    }
                    
                    self.posts.append(post)
                    
                    // Show earliest posts first
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return (p1.creationDate.compare(p2.creationDate) == .orderedDescending)
                    })
                    
                    self.collectionView?.reloadData()
                    self.showNoPosts()
                }, withCancel: { (err) in
                    print("Failed to fetch info for post: ", err)
                })
            })
        }) { (err) in
            print("Failed to fetch posts: ", err)
        }
    }
    
    // Up/Down spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((view.frame.width))
        let height = ((view.frame.height) / 3)
        
        return CGSize(width: width, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TimelinePostCell
        cell.delegate = self
        
        cell.post = posts[indexPath.item]
        
        cell.indexPath = indexPath

        return cell
    }
    
    func didClickPostImage(post: Post, index: IndexPath) {
        guard let id = post.id else { return }
        guard var viewsInt = Int(post.views ?? "0") else { return }

        let username = post.user.username
        let timestamp = post.creationDate
        let containerView = PostViewController()

        if post.hasViewed == false {
            viewsInt += 1
        }

        containerView.previewImageView.loadImage(urlString: post.imageUrl)
        containerView.postId = id
        containerView.hasViewed = post.hasViewed

        let attributedText = NSMutableAttributedString(string: username + "\n", attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 18), NSAttributedString.Key.foregroundColor: UIColor.white])

        attributedText.append(NSAttributedString(string: timestamp.timeAgoDisplay(userDate: false), attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))

        containerView.usernameAndTimestamp.attributedText = attributedText

        containerView.viewCount.text = String(viewsInt)

        let navController = UINavigationController(rootViewController: containerView)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated:true, completion: nil)

        guard let uid = Auth.auth().currentUser?.uid else { return }

        let values = [uid: 1]

        Database.database().reference().child("views").child(id).updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to like post: ", err)
                return
            }

            if post.hasViewed == false {
                self.posts[index.item].views = String(viewsInt)
                self.posts[index.item].hasViewed = true

                self.collectionView.reloadItems(at: [index])
            }
            print("Successfully liked post!")
        }
    }
    
    func didClickUsername(user: User) {
        let userProfileController = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(userProfileController, animated: true)
                
        // Pass the clicked user's UID
        userProfileController.userId = user.uid
    }
}
