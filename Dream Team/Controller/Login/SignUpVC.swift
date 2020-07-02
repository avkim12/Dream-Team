//
//  SignUpVC.swift
//  Dream Team
//
//  Created by Student on 5/18/20.
//  Copyright © 2020 Alla Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Properties
    
    var imageSelected = false
    
    fileprivate let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.5117964149, green: 0.8535913229, blue: 0.9996827245, alpha: 1), for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.5117964149, green: 0.8535913229, blue: 0.9996827245, alpha: 1).cgColor
        button.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate let emailTextField = UITextField.setupTextField(placeholder: "Email", isSecureTextEntry: false)
    fileprivate let fullNameTextField = UITextField.setupTextField(placeholder: "Full Name", isSecureTextEntry: false)
    fileprivate let userNameTextField = UITextField.setupTextField(placeholder: "User Name", isSecureTextEntry: false)
    fileprivate let passwordTextField = UITextField.setupTextField(placeholder: "Password", isSecureTextEntry: true)
    fileprivate let signUpButton = UIButton.setupButton(title: "Sign up", color: #colorLiteral(red: 0.5117964149, green: 0.8535913229, blue: 0.9996827245, alpha: 1))
    
    
    fileprivate let alreadyHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        // first part of button
        let attributedTitle = NSMutableAttributedString(string: "Already have an account ?  ", attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.lightGray])
        // second part of button
        attributedTitle.append(NSAttributedString(string: "Sign in", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold), .foregroundColor: #colorLiteral(red: 0.5117964149, green: 0.8535913229, blue: 0.9996827245, alpha: 1)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(goToSignIn), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func goToSignIn() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        
        setupNotificationObserver()
        setupTapGesture()
        handlers()
    }
    
    //MARK: - UIImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        imageSelected = true
        
        selectPhotoButton.layer.cornerRadius = selectPhotoButton.frame.width / 2
        selectPhotoButton.layer.masksToBounds = true
        selectPhotoButton.layer.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1).cgColor
        selectPhotoButton.layer.borderWidth = 2
        selectPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Handlers
    
    fileprivate func handlers() {
        emailTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }
    
    @objc fileprivate func handleSignUp() {
        
        self.handleTapDismiss()
        
        guard let email = emailTextField.text?.lowercased() else {return}
        guard let userName = userNameTextField.text?.lowercased() else {return}
        guard let fullName = fullNameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
    
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            print("Пользователь создан")
            
            guard let profileImage = self.selectPhotoButton.imageView?.image else {return}
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else {return}
            
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profileImage").child(fileName)
            
            storageRef.putData(uploadData, metadata: nil) { (_, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                print("Загрузка прошла успешно")
                
                storageRef.downloadURL { (downloadUrl, err) in
                    guard let profileImageUrl = downloadUrl?.absoluteString else {return}
                    if let err = err {
                        print("Profile image is nil", err.localizedDescription)
                        return
                    }
                    print("Ссылка на картинку получена")
                    
                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    
                    let docData = ["uid": uid, "name": fullName, "username": userName, "profileImageUrl": profileImageUrl]
                    
                    Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                        if let err = err {
                            print("Failed", err.localizedDescription)
                            return
                        }
                        
                        print("Данные сохранены")
                    }
                }
            }
        }
    }
    
    @objc fileprivate func formValidation() {
        guard
            emailTextField.hasText,
            fullNameTextField.hasText,
            userNameTextField.hasText,
            passwordTextField.hasText,
            imageSelected == true
        else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.5117964149, green: 0.8535913229, blue: 0.9996827245, alpha: 0.5)
            return
        }
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = #colorLiteral(red: 0.5117964149, green: 0.8535913229, blue: 0.9996827245, alpha: 1)
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        emailTextField,
        fullNameTextField,
        userNameTextField,
        passwordTextField,
        signUpButton
    ])
    
    fileprivate func configureViewComponents() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        view.addSubview(selectPhotoButton)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 150))
        selectPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectPhotoButton.layer.cornerRadius = 150 / 2
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: selectPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 280))
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 40, bottom: 10, right: 40))
    }

    //MARK: - Keyboard
    
    fileprivate func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardframe = value.cgRectValue
        
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        
        let difference = keyboardframe.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
    }
    
    @objc fileprivate func handleKeyBoardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        }, completion: nil)
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
