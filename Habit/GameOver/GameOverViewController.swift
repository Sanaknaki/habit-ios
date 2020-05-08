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
        label.font = UIFont(name: "AvenirNext-Regular", size: 65)
        
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
        btn.backgroundColor = .mainGray()
        btn.addTarget(self, action: #selector(handleAccountDeletion), for: .touchUpInside)
        
        btn.isEnabled = false
        
        return btn
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Email"
        
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)

        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Password"
        
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-Regular", size: 12)
        
        return label
    }()
    
    let emailTextField: DeleteInputTextField = {
        let textfield = DeleteInputTextField()
                
        textfield.placeholder = "Email"
        
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
                
        return textfield
    }()
    
    let passwordTextField: DeleteInputTextField = {
        let textfield = DeleteInputTextField()
                
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
    
    let errorMessageLabel: UILabel = {
        let err = UILabel()
        
        err.isHidden = true
        err.numberOfLines = 0
        err.textAlignment = .center
        
        return err
    }()
    
    // Handle disabling/enabling of login button
    @objc func handleTextInputChange() {
        let isSignUpFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isSignUpFormValid {
            deleteAccountButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            deleteAccountButton.setTitleColor(.white, for: .normal)
            deleteAccountButton.backgroundColor = .mainRed()
            deleteAccountButton.isEnabled = true
        } else {
            deleteAccountButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            deleteAccountButton.setTitleColor(.white, for: .normal)
            deleteAccountButton.backgroundColor = .mainGray()
            deleteAccountButton.isEnabled = false
        }
    }
    
    @objc func handleAccountDeletion() {
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
            
            Database.database().reference().child("users").child(user?.user.uid ?? "").observe(.value) { (snapshot) in
                snapshot.ref.removeValue()
            }
            
            Database.database().reference().child("posts").child(user?.user.uid ?? "").observe(.value) { (snapshot) in
                snapshot.ref.removeValue()
            }
            
            Database.database().reference().child("following").child(user?.user.uid ?? "").observe(.value) { (snapshot) in
                snapshot.ref.removeValue()
            }
            
            Database.database().reference().child("followers").child(user?.user.uid ?? "").observe(.value) { (snapshot) in
                snapshot.ref.removeValue()
            }
            
            user?.user.delete { error in
              if let error = error {
                print(error)
              } else {
                DispatchQueue.main.async {
                    let loginViewController = LoginOrSignUpScreen()
                    let navController = UINavigationController(rootViewController: loginViewController)
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated:true, completion: nil)
                }
              }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        view.backgroundColor = .mainBlue()
        
        view.addSubview(emojiLabel)
        view.addSubview(goodbyeMessageLabel)
        view.addSubview(deleteAccountButton)
        view.addSubview(errorMessageLabel)
        
        emojiLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        goodbyeMessageLabel.anchor(top: emojiLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        goodbyeMessageLabel.centerXAnchor.constraint(equalTo: emojiLabel.centerXAnchor).isActive = true
        
        styleTextFields()
        
        setupInputFields()
        
        errorMessageLabel.anchor(top: nil, left: view.leftAnchor, bottom: deleteAccountButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 10, paddingRight: 30, width: 0, height: 35)
        
        deleteAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 90)
        deleteAccountButton.centerXAnchor.constraint(equalTo: goodbyeMessageLabel.centerXAnchor).isActive = true
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
        let stackView = UIStackView(arrangedSubviews: [emailView, passwordView])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
                
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 240)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
