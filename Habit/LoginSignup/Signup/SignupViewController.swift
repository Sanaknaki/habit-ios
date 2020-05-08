//
//  SignupViewController.swift
//  Theday
//
//  Created by Ali Sanaknaki on 2020-04-13.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {
    let signupLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Sign Up"
        label.textColor = .mainBlue()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 22)
        
        return label
    }()
    
    let usernameView: UIView = {
        let view = UIView()
    
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Username"
        label.textColor = .mainGray()
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        
        return label
    }()
    
    let usernameTextField: LoginSignUpInputTextField = {
        let textfield = LoginSignUpInputTextField()
        
        textfield.attributedPlaceholder = NSMutableAttributedString(string: "Username", attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    let emailView: UIView = {
        let view = UIView()
    
        return view
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Email"
        
        label.textColor = .mainGray()
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        
        return label
    }()
    
    let emailTextField: LoginSignUpInputTextField = {
        let textfield = LoginSignUpInputTextField()
        
        textfield.attributedPlaceholder = NSMutableAttributedString(string: "Email", attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return textfield
    }()
    
    let passwordView: UIView = {
        let view = UIView()
    
        return view
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Password"
        
        label.textColor = .mainGray()
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        
        return label
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
        let label = UILabel()
        
        label.text = "Retype Password"
        
        label.textColor = .mainGray()
        label.font = UIFont(name: "AvenirNext-Regular", size: 14)
        
        return label
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
        let btn = UIButton(type: .system)
        
        btn.isEnabled = false
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 15)
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
        
        self.errorMessageLabel.isHidden = true
        
        if(usernameText.contains(" ")) {
            self.errorMessageLabel.attributedText = NSMutableAttributedString(string: "No spaces in username!", attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 14), NSAttributedString.Key.foregroundColor: UIColor.mainRed()])
            self.errorMessageLabel.isHidden = false
        } else if (usernameText.count > 24 || usernameText.count < 3) {
            self.errorMessageLabel.attributedText = NSMutableAttributedString(string: "Username must be between 3 and 24 characters!", attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 14), NSAttributedString.Key.foregroundColor: UIColor.mainRed()])
            self.errorMessageLabel.isHidden = false
        } else if(passwordText != retypePasswordText) {
            self.errorMessageLabel.attributedText = NSMutableAttributedString(string: "Passwords do not match!", attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 14), NSAttributedString.Key.foregroundColor: UIColor.mainRed()])
            self.errorMessageLabel.isHidden = false
        } else {
            Auth.auth().createUser(withEmail: emailText.lowercased(), password: passwordText, completion: { (user: AuthDataResult?, error: Error?) in
                if let err = error {
                    print("Failed to create user: ", err)
                    self.errorMessageLabel.attributedText = NSMutableAttributedString(string: err.localizedDescription, attributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 14), NSAttributedString.Key.foregroundColor: UIColor.mainRed()])
                    self.errorMessageLabel.isHidden = false
                    return
                }
                
                print("Successfully created user: ", user?.user.uid ?? "")
                
                guard let uid = user?.user.uid else { return }
                
                let dictValues = ["username": usernameText.lowercased(), "joined_date": Date().timeIntervalSince1970] as [String: Any]
                
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
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isHidden = false
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .white
        
        setupNavigationItems()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        view.addSubview(signupLabel)
        view.addSubview(errorMessageLabel)

        signupLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        signupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        styleTextFields()
        
        setupInputFields()
        
        errorMessageLabel.anchor(top: signupButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
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
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 580)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

