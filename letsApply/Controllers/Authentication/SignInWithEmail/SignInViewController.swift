//
//  ViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/09.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    let firestoreService = FirestoreService()
    private let viewModel = SignInViewModel()
    
    
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
    
    lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.addTarget(self, action: #selector(navigateToSignUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupKeyboardDismissal()
    }
    
    func setupUI() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(forgotPasswordButton)
        
        
        emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        signInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        signInButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        forgotPasswordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        forgotPasswordButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        forgotPasswordButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
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
    
    
    @objc private func handleSignIn() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Invalid Input", message: "Please provide both email and password.")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email format.")
            return
        }
        
        viewModel.signIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                print("User signed in successfully:", profile)
                let profileSetupVC = ProfileSetupViewController()
                self.navigationController?.pushViewController(profileSetupVC, animated: true)
            case .failure(let error):
                if (error as NSError).code == AuthErrorCode.userNotFound.rawValue {
                    self.showSignUpAlert()
                } else {
                    self.showAlert(title: "Sign In Failed", message: "Please enter a correct password." )
                }
            }
        }
    }
    
    @objc private func handleForgotPassword() {
        // ertwe
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "email required", message: "Please provide an email.")
            return
        }
        
        if !ValidationManager.shared.validateEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email format.")
            return
        }
        
        viewModel.resetPassword(email: email) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(title: "Password Reset Failed", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Success", message: "Password reset email sent.")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showSignUpAlert() {
        let alert = UIAlertController(title: "Account Not Found", message: "This email is not registered. Would you like to sign up?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let signUpVC = SignUpViewController()
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func navigateToSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}


