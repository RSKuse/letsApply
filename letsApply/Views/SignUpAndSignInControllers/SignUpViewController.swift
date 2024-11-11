//
//  SignUpViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/10.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    let firestoreService = FirestoreService()
    private let viewModel = SignUpViewModel()
    
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Full Name"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Location"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(locationTextField)
        view.addSubview(signUpButton)
        
        nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        locationTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        locationTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        locationTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        locationTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        signUpButton.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 20).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    @objc private func handleSignUp() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let location = locationTextField.text, !location.isEmpty else {
            print("Please fill out all fields.")
            return
        }

        viewModel.createUser(name: name, email: email, password: password, location: location) { [weak self] error in
            if let error = error {
                print("Failed to sign up:", error)
                return
            }
            print("User signed up successfully.")
            let profileSetupVC = ProfileSetupViewController()
            self?.navigationController?.pushViewController(profileSetupVC, animated: true)
        }
    }
}
    
    //    private func navigateToSignIn() {
    //        let signInVC = SignInViewController()
    //        navigationController?.setViewControllers([signInVC], animated: true)
    //    }

