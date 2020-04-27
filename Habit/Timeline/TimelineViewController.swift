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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        collectionView.backgroundColor = .white
        collectionView.register(TimelinePostCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigationBar()
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

    // Right/Left spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // Up/Down spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((view.frame.width-10) / 2)
        let height = ((view.frame.height-10) / 3)
        
        return CGSize(width: width, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TimelinePostCell
        
        return cell
    }
}
