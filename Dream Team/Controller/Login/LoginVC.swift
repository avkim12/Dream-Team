//
//  LoginVC.swift
//  Dream Team
//
//  Created by Student on 5/17/20.
//  Copyright © 2020 Alla Kim. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    // MARK: -Properties
    
    fileprivate let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "team"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 150))
        logoImageView.centerInSuperview()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate let emailTextField = UITextField.setupTextField(placeholder: "Email", isSecureTextEntry: false)
    fileprivate let passwordTextField = UITextField.setupTextField(placeholder: "Password", isSecureTextEntry: true)
    fileprivate let loginButton = UIButton.setupButton(title: "Log in", color: #colorLiteral(red: 0.5117964149, green: 0.8535913229, blue: 0.9996827245, alpha: 1))
    
    fileprivate let dontHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "Don't have an account ?  ", attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign up", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: #colorLiteral(red: 0.5117964149, green: 0.8535913229, blue: 0.9996827245, alpha: 1)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        return button
    }()

    //MARK: - Handlers
    
    @objc fileprivate func goToSignUp() {
        let signUpController = SignUpVC()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
        setupTapGesture()
        handlers()
    }
    
    fileprivate func handlers() {
        emailTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    @objc fileprivate func handleLogin() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print("Failed to login with error:", err.localizedDescription)
                return
            }
            print("Пользователь вошел в профиль")
            
            let mainTabBarVC = MainTabBarVC()
            mainTabBarVC.modalPresentationStyle = .fullScreen
            self.present(mainTabBarVC, animated: true, completion: nil)
            }
    }
    
    @objc fileprivate func formValidation() {
        guard
            emailTextField.hasText,
            passwordTextField.hasText
        else {
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = #colorLiteral(red: 0.5117964149, green: 0.8535913229, blue: 0.9996827245, alpha: 0.5)
            return
        }
        loginButton.isEnabled = true
        loginButton.backgroundColor = #colorLiteral(red: 0.5117964149, green: 0.8535913229, blue: 0.9996827245, alpha: 1)
    }
    
    fileprivate func configureViewComponents() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 150))
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 215, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 180))
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 40, bottom: 10, right: 40))
    }

    //MARK: - Keyboard
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }
    
}
