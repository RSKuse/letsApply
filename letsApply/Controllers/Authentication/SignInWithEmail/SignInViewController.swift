//
//  ViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/09.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    let firestoreService = FirestoreService()
    private let viewModel = SignInViewModel()
    
    // Buttons created using ButtonFacade
    lazy var signInButton: UIButton = {
        return ButtonFacade.shared.createButton(
            title: "Sign In",
            titleColor: .systemBlue,
            backgroundColor: .clear,
            target: self,
            action: #selector(handleSignIn)
        )
    }()
    
    lazy var signUpButton: UIButton = {
        return ButtonFacade.shared.createButton(
            title: "Don't have an account? Sign Up",
            titleColor: .systemBlue,
            backgroundColor: .clear,
            target: self,
            action: #selector(navigateToSignUp)
        )
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        return ButtonFacade.shared.createButton(
            title: "Forgot Password?",
            titleColor: .systemBlue, // Corrected order
            backgroundColor: .clear,
            target: self,
            action: #selector(handleForgotPassword)
        )
    }()
    
    // TextFields for email and password
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
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        signInButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        signUpButton.widthAnchor.constraint(equalToConstant: 2).isActive = true
//        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        forgotPasswordButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20).isActive = true
        forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Uncomment this method
    @objc private func handleSignIn() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Invalid Input", message: "Please provide both email and password.")
            return
        }

        if !ValidationManager.shared.validateEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email format.")
            return
        }

        viewModel.signIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfile):
                    print("User signed in successfully:", userProfile)
                    let homeScreenVC = HomeScreenViewController()
                    self.navigationController?.pushViewController(homeScreenVC, animated: true)
                case .failure(let error):
                    self.showAlert(title: "Sign In Failed", message: error.localizedDescription)
                }
            }
        }
    }

    
    @objc private func handleForgotPassword() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Invalid Input", message: "Please provide an email.")
            return
        }

        if !ValidationManager.shared.validateEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email format.")
            return
        }

        viewModel.resetPassword(email: email) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Reset Failed", message: error.localizedDescription)
                } else {
                    self.showAlert(title: "Success", message: "Password reset email sent.")
                }
            }
        }
    }
    
    @objc private func navigateToSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


