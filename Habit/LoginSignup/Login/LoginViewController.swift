//
//  LoginViewController.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-13.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
            
    let loginLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Log In"
        label.textColor = .mainBlue()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 22)
        
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Email"
        
        label.textColor = .mainGray()
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)

        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Password"
        
        label.textColor = .mainGray()
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        
        return label
    }()
    
    let emailTextField: LoginSignUpInputTextField = {
        let textfield = LoginSignUpInputTextField()
                
        textfield.placeholder = "Email"
        
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
                
        return textfield
    }()
    
    let passwordTextField: LoginSignUpInputTextField = {
        let textfield = LoginSignUpInputTextField()
                
        textfield.isSecureTextEntry = true
        
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    let emailView: UIView = {
        let view = UIView()
    
        return view
    }()
    
    let passwordView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    // Handle disabling/enabling of login button
    @objc func handleTextInputChange() {
        let isSignUpFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isSignUpFormValid {
            loginButton.setTitleColor(.black, for: .normal)
            loginButton.isEnabled = true
        } else {
            loginButton.setTitleColor(UIColor.mainGray(), for: .normal)
            loginButton.isEnabled = false
        }
    }
    
    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.isEnabled = false
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 15)
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email.lowercased(), password: password) { (user: AuthDataResult?, err: Error?) in
            if let err = err {
                print("Failed to perform login : ", err)
                self.errorMessageLabel.attributedText = NSMutableAttributedString(string: err.localizedDescription, attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 14), NSAttributedString.Key.foregroundColor: UIColor.mainRed()])
                self.errorMessageLabel.isHidden = false
                return
            }
            
            print("Successfully logged in to account : ", user?.user.uid)
            
            // Object that represents entire app, shared gets the app, keyWindow is the window that you see in the app
            // RootView = MainTabBarController that was set in AppDelegate
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            
            mainTabBarController.setupViewControllers()
            
            // Gets rid of the login view and shows you as logged in
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    let errorMessageLabel: UILabel = {
        let err = UILabel()
        
        err.isHidden = true
        err.numberOfLines = 0
        err.textAlignment = .center
        
        return err
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
        errorMessageLabel.text = ""
        
        
        loginButton.isEnabled = false
        loginButton.setTitleColor(UIColor.mainGray(), for: .normal)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        setupNavigationItems()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        view.addSubview(loginLabel)
        view.addSubview(errorMessageLabel)
        
        loginLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        styleTextFields()
        
        setupInputFields()

        errorMessageLabel.anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 35)
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackClick))
    }
    @objc func handleBackClick() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func styleTextFields() {
        emailView.addSubview(emailLabel)
        emailView.addSubview(emailTextField)
        
        emailLabel.anchor(top: emailView.topAnchor, left: emailView.leftAnchor, bottom: nil, right: emailView.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        emailTextField.anchor(top: nil, left: emailView.leftAnchor, bottom: emailView.bottomAnchor, right: emailView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        passwordView.addSubview(passwordLabel)
        passwordView.addSubview(passwordTextField)
        passwordLabel.anchor(top: passwordView.topAnchor, left: passwordView.leftAnchor, bottom: nil, right: passwordView.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        passwordTextField.anchor(top: nil, left: passwordView.leftAnchor, bottom: passwordView.bottomAnchor, right: passwordView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailView, passwordView, loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
                
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 340)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
