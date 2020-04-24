//
//  LoginViewController.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-13.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
        
    let logoImageView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "icon").withRenderingMode(.alwaysOriginal))
        logoImageView.contentMode = .scaleAspectFill
    
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 60)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        return view
    }()
    
    let emailLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.text = "Email"
        
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        
        return lbl
    }()
    
    let passwordLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.text = "Password"
        
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        
        return lbl
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
       let btn = UIButton()
        
        btn.isEnabled = false
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font =  UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user: AuthDataResult?, err: Error?) in
            if let err = err {
                print("Failed to perform login : ", err)
                self.errorMessageLabel.attributedText = NSMutableAttributedString(string: err.localizedDescription, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.theRed()])
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
    
    let haveAnAccountLoginButton: UIButton = {
       let btn = UIButton(type: .system)
       
       let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
       
       attributedTitle.append(NSAttributedString(string: "Sign Up!", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
       
       btn.setAttributedTitle(attributedTitle, for: .normal)
       
       btn.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
       
       return btn
    }()
    
    @objc func handleShowSignUp() {
        let signUpController = SignupViewController()
        
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
        errorMessageLabel.text = ""
        
        
        loginButton.isEnabled = false
        loginButton.setTitleColor(UIColor.mainGray(), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        view.addSubview(logoImageView)
        view.addSubview(errorMessageLabel)
        view.addSubview(haveAnAccountLoginButton)
        
        
        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        styleTextFields()
        
        setupInputFields()

        errorMessageLabel.anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 35)
        
        haveAnAccountLoginButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 0)

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
        stackView.spacing = 0
        stackView.distribution = .fillEqually
                
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 300)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
