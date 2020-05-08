//
//  MainTabBarController.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-11.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var user: User?
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Check if there's a user logged in, show login view
        if(Auth.auth().currentUser == nil) {
            DispatchQueue.main.async {
                let loginViewController = LoginOrSignUpScreen()
                let navController = UINavigationController(rootViewController: loginViewController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated:true, completion: nil)
            }
        }
        
        // Check if there's a user logged in, show login view
        checkIfYouBrokeHabit()
        
        setupViewControllers()
    }
    
    fileprivate func checkIfYouBrokeHabit() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        let query = ref.queryLimited(toLast: 1)
        let calendar = Calendar.current
    
        query.observeSingleEvent(of: .value) { (snapshot) in
            guard let dicts = snapshot.value as? [String: Any] else { return }
            guard let dictValues = dicts.first?.value as? [String : Any] else { return }
            
            let dateFormatted = Date(timeIntervalSince1970: dictValues["creationDate"] as? Double ?? 0)
            
            if((!calendar.isDateInYesterday(dateFormatted) && !calendar.isDateInToday(dateFormatted)) && snapshot.childrenCount > 0) {
                DispatchQueue.main.async {
                    let gameOverViewController = GameOverViewController()
                    let navController = UINavigationController(rootViewController: gameOverViewController)
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated:true, completion: nil)
                }
            }
        }
        
        print("NOT GAME OVER!")
    }

    @objc func handleCamera() {
         let cameraController = CameraController()
         cameraController.modalPresentationStyle = .fullScreen
         present(cameraController, animated: true, completion: nil)
     }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 1 {
            let cameraController = CameraController()
            cameraController.modalPresentationStyle = .fullScreen
            present(cameraController, animated: true, completion: nil)
            
            return false
        }
        
        return true
        
    }
    
    func setupViewControllers() {
        
        // Home
        let timelineNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "home-clicked").withRenderingMode(.alwaysOriginal), rootViewController: TimelineViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Add
        let captureNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "capture").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "capture").withRenderingMode(.alwaysOriginal), rootViewController: UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // Profile
        let exploreNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "explore").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "explore-clicked").withRenderingMode(.alwaysOriginal), rootViewController: UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.clipsToBounds = true
        
        // Takes in an array of Nav Controllers, that show their respective ViewController
        viewControllers = [timelineNavController,
                           captureNavController
                           /*exploreNavController*/]
        
        // Modify tab bar insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
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
