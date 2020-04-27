//
//  LoginOrSignUpScreen.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-26.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit

class LoginOrSignUpScreen: UIViewController {
    
    let habitLogo: UIImageView = {
        let img = UIImageView()
        
        img.image = #imageLiteral(resourceName: "icon-white").withRenderingMode(.alwaysOriginal)
        
        return img
    }()
    
    let logoSection: UIView = {
       let view = UIView()
        
        view.backgroundColor = .mainBlue()
        
        return view
    }()
    
    let loginButton: UIButton = {
       let btn = UIButton()
        
        btn.setTitle("Log In", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .lightMainBlue()
        
        btn.addTarget(self, action: #selector(handleClickLogin), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func handleClickLogin() {
        let loginController = LoginViewController()
        
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    let signUpButton: UIButton = {
       let btn = UIButton()
        
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.mainGray(), for: .normal)
        btn.backgroundColor = .white
        
        btn.addTarget(self, action: #selector(handleClickSignup), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func handleClickSignup() {
        let signUpController = SignupViewController()
        
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationRemoving()
        
        view.addSubview(logoSection)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        
        logoSection.addSubview(habitLogo)
        
        logoSection.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        habitLogo.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        habitLogo.centerYAnchor.constraint(equalTo: logoSection.centerYAnchor).isActive = true
        habitLogo.centerXAnchor.constraint(equalTo: logoSection.centerXAnchor).isActive = true
        
        loginButton.anchor(top: logoSection.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 90)
                
        signUpButton.anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 90)
    }
    
    fileprivate func setupNavigationRemoving() {
        self.navigationController?.navigationBar.isHidden = true
    }
}
