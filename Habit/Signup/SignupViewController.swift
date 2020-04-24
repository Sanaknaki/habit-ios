//
//  SignupViewController.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-13.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    
    let logoImageView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "icon").withRenderingMode(.alwaysOriginal))
        logoImageView.contentMode = .scaleAspectFill
    
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 60)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        return view
    }()
    
    let usernameView: UIView = {
        let view = UIView()
    
        return view
    }()
    
    let usernameLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.text = "Username"
        
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        
        return lbl
    }()
    
    let usernameTextField: LoginSignUpInputTextField = {
        let textfield = LoginSignUpInputTextField()
        
        textfield.attributedPlaceholder = NSMutableAttributedString(string: "Username", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return textfield
    }()
    
    let emailView: UIView = {
        let view = UIView()
    
        return view
    }()
    
    let emailLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.text = "Email"
        
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        
        return lbl
    }()
    
    let emailTextField: LoginSignUpInputTextField = {
        let textfield = LoginSignUpInputTextField()
        
        textfield.attributedPlaceholder = NSMutableAttributedString(string: "Email", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    let passwordView: UIView = {
        let view = UIView()
    
        return view
    }()
    
    let passwordLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.text = "Password"
        
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        
        return lbl
    }()
    
    let passwordTextField: LoginSignUpInputTextField = {
        let textfield = LoginSignUpInputTextField()
                
        textfield.isSecureTextEntry = true
        
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    let retypePasswordView: UIView = {
        let view = UIView()
    
        return view
    }()
    
    let retypePasswordLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.text = "Retype Password"
        
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        
        return lbl
    }()
    
    let retypePasswordTextField: LoginSignUpInputTextField = {
        let textfield = LoginSignUpInputTextField()
                
        textfield.isSecureTextEntry = true
        
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    // Handle disabling/enabling of login button
    @objc func handleTextInputChange() {
        let isSignUpFormValid = usernameTextField.text?.count ?? 0 > 0 && emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && retypePasswordTextField.text?.count ?? 0 > 0
        
        if isSignUpFormValid {
            signupButton.setTitleColor(.black, for: .normal)
            signupButton.isEnabled = true
        } else {
            signupButton.setTitleColor(UIColor.mainGray(), for: .normal)
            signupButton.isEnabled = false
        }
    }
    
    let signupButton: UIButton = {
       let btn = UIButton()
        
        btn.isEnabled = false
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font =  UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return btn
    }()
    
    let errorMessageLabel: UILabel = {
        let err = UILabel()
        
        err.isHidden = true
        err.numberOfLines = 0
        err.textAlignment = .center
        
        return err
    }()
    
    @objc func handleSignUp() {
        guard let emailText = emailTextField.text else { return }
        guard let usernameText = usernameTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        guard let retypePasswordText = retypePasswordTextField.text else { return }
        
        if(passwordText != retypePasswordText) {
            self.errorMessageLabel.attributedText = NSMutableAttributedString(string: "Passwords do not match!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.theRed()])
            self.errorMessageLabel.isHidden = false
        } else {
            Auth.auth().createUser(withEmail: emailText, password: passwordText, completion: { (user: AuthDataResult?, error: Error?) in
                if let err = error {
                    print("Failed to create user: ", err)
                    return
                }
                
                print("Successfully created user: ", user?.user.uid ?? "")
                
                guard let uid = user?.user.uid else { return }
                
                let dictValues = ["username": usernameText]
                
                // Tree is {users: {uid: {username : username, profileImageUrl: url}}}
                let values = [uid: dictValues]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to save user info into DB: ", err)
                        return
                    }

                    print("Successfully saved user info to DB!")
                    
                    // Object that represents entire app, shared gets the app, keyWindow is the window that you see in the app
                    // RootView = MainTabBarController that was set in AppDelegate
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    
                    mainTabBarController.setupViewControllers()
                    
                    // Gets rid of the login view and shows you as logged in
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
        retypePasswordTextField.text = ""
        usernameTextField.text = ""
        // errorMessage.text = ""
        
        signupButton.isEnabled = false
        signupButton.setTitleColor(UIColor.mainGray(), for: .normal)
    }
    
    let noAccountSignUpButton: UIButton = {
       let button = UIButton(type: .system)
       
       let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
       
       attributedTitle.append(NSAttributedString(string: "Login!", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
       
       button.setAttributedTitle(attributedTitle, for: .normal)
       
       button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
       
       return button
    }()
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        view.addSubview(logoImageView)
        view.addSubview(errorMessageLabel)
        view.addSubview(noAccountSignUpButton)
        
        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        styleTextFields()
        
        setupInputFields()
        
        errorMessageLabel.anchor(top: signupButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        
        noAccountSignUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 100, paddingRight: 50, width: 0, height: 0)

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func styleTextFields() {
        usernameView.addSubview(usernameLabel)
        usernameView.addSubview(usernameTextField)
        
        usernameLabel.anchor(top: usernameView.topAnchor, left: usernameView.leftAnchor, bottom: nil, right: usernameView.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameTextField.anchor(top: nil, left: usernameView.leftAnchor, bottom: usernameView.bottomAnchor, right: usernameView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        emailView.addSubview(emailLabel)
        emailView.addSubview(emailTextField)
        
        emailLabel.anchor(top: emailView.topAnchor, left: emailView.leftAnchor, bottom: nil, right: emailView.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        emailTextField.anchor(top: nil, left: emailView.leftAnchor, bottom: emailView.bottomAnchor, right: emailView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        passwordView.addSubview(passwordLabel)
        passwordView.addSubview(passwordTextField)
        passwordLabel.anchor(top: passwordView.topAnchor, left: passwordView.leftAnchor, bottom: nil, right: passwordView.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        passwordTextField.anchor(top: nil, left: passwordView.leftAnchor, bottom: passwordView.bottomAnchor, right: passwordView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        retypePasswordView.addSubview(retypePasswordLabel)
        retypePasswordView.addSubview(retypePasswordTextField)
        retypePasswordLabel.anchor(top: retypePasswordView.topAnchor, left: retypePasswordView.leftAnchor, bottom: nil, right: retypePasswordView.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        retypePasswordTextField.anchor(top: nil, left: retypePasswordView.leftAnchor, bottom: retypePasswordView.bottomAnchor, right: retypePasswordView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [usernameView, emailView, passwordView, retypePasswordView, signupButton])
        
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 500)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

