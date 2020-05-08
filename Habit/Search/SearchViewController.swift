//
//  SearchViewController.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-24.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    let cellId = "cellId"
    let headerId = "headerId"
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        // Search bar has a textfield in it, and to edit it, must call it through this call.
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .darkMainBlue()
        
        sb.delegate = self
        
        return sb
    }()
    
    // Filter results
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.filteredUsers = self.users
        } else {
            self.filteredUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .mainBlue()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Back
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackClick))
        
        // Remove back button to add the custom one
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Add search bar to the navigation bar
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 80, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        collectionView?.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        // Allow to bounce it aka scroll up/down whenever
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        fetchUsers()
    }
    
    @objc func handleBackClick() {
        navigationController?.popViewController(animated: true)
    }
    
    // When moving back to search view, bring back search bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        searchBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.isHidden = true
    }
    
    var filteredUsers = [User]()
    var users = [User]()
    
    fileprivate func fetchUsers() {
        print("Fetching users")
        
        // Get to users node
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Snapshot is a dict
            // print(snapshot.value)
            
            guard let dicts = snapshot.value as? [String: Any] else { return }
            
            dicts.forEach({ (key: String, value: Any) in
                
                if key == Auth.auth().currentUser?.uid {
                    print("This is me, don't need to search for myself.")
                    return
                }
                
                guard let userDict = value as? [String: Any] else { return }
                
                let user = User(uid: key, dict: userDict)
                self.users.append(user)
            })
            
            // Alphabetically sorted
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch users for search: ", err)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder() // Hide keyboard when you select row
        
        let user = filteredUsers[indexPath.item]
        
        let userProfileController = ProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(userProfileController, animated: true)
                
        // Pass the clicked user's UID
        userProfileController.userId = user.uid
    }
    
    // Up/Down spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        
        cell.user = filteredUsers[indexPath.item]
        
        cell.backgroundColor = .lightMainBlue()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
    }
}

