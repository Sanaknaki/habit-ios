//
//  GameOverViewController.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-29.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Firebase

class GameOverViewController: UIViewController {
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        
        label.text = "👋"
        label.font = UIFont(name: "AvenirNext-Regular", size: 75)
        
        return label
    }()
    
    let goodbyeMessageLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Seems like you broke your habit, shame."
        label.font = UIFont(name: "AvenirNext-Regular", size: 16)
        label.textColor = .white
        
        return label
    }()
    
    let deleteAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.setTitle("DELETE MY ACCOUNT", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .mainRed()
        btn.addTarget(self, action: #selector(handleAccountDeletion), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func handleAccountDeletion() {
        print(123)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .mainBlue()
        
        view.addSubview(emojiLabel)
        view.addSubview(goodbyeMessageLabel)
        view.addSubview(deleteAccountButton)
        
        emojiLabel.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emojiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        goodbyeMessageLabel.anchor(top: emojiLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        goodbyeMessageLabel.centerXAnchor.constraint(equalTo: emojiLabel.centerXAnchor).isActive = true
        
        deleteAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 90)
        deleteAccountButton.centerXAnchor.constraint(equalTo: goodbyeMessageLabel.centerXAnchor).isActive = true
    }
}
