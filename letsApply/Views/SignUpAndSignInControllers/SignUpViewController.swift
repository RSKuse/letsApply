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
        textField.configureTextField(placeholder: "Full Name", keyboardType: .emailAddress)
        return textField
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.configureTextField(placeholder: "Email", keyboardType: .emailAddress)
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.configureTextField(placeholder: "Password", isSecure: true)
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
        textField.autocapitalizationType = .none // Disable capital letters
        textField.isUserInteractionEnabled = true // Allow interaction
        textField.returnKeyType = .done // Adjust keyboard "Return" key
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupKeyboardDismissal()
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
    
    func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func handleSignUp() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let location = locationTextField.text, !location.isEmpty else {
            showAlert(title: "Invalid Input", message: "Please fill out all fields.")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email format.")
            return
        }
        
        viewModel.createUser(name: name, email: email, password: password, location: location) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(title: "Sign Up Failed", message: error.localizedDescription)
            } else {
                print("User signed up successfully.")
                DispatchQueue.main.async {
                    let profileSetupVC = ProfileSetupViewController()
                    self.navigationController?.pushViewController(profileSetupVC, animated: true)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

//    private func navigateToSignIn() {
//        let signInVC = SignInViewController()
//        navigationController?.setViewControllers([signInVC], animated: true)
//    }

