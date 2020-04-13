//
//  MainTabBarController.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-11.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    fileprivate func setupViewControllers() {
        
        // Home
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home-icon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "home-icon-clicked").withRenderingMode(.alwaysOriginal), rootViewController: UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Add
        let addNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "add-icon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "add-icon-clicked").withRenderingMode(.alwaysOriginal), rootViewController: UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Profile
        let profileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile-icon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "profile-icon-clicked").withRenderingMode(.alwaysOriginal), rootViewController: UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // To edit TabBar
        tabBar.tintColor = .black
        
        // Takes in an array of Nav Controllers, that show their respective ViewController
        viewControllers = [homeNavController,
                           addNavController,
                           profileNavController]
        
        // Modify tab bar insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0)
        }
    }
    
    /*
     * Each time you call this, you build a TabBarIcon that links to a ViewController.
     */
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    }
}
