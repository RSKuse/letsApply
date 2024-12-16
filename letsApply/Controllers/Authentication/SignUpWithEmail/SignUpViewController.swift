//
//  SignUpViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/10.
//

import Foundation
import FirebaseAuth
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

    lazy var locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Location"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.isUserInteractionEnabled = true
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var signUpButton: UIButton = {
        return ButtonFacade.shared.createButton(
            title: "Sign Up",
            backgroundColor: .systemBlue,
            target: self,
            action: #selector(handleSignUp))
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfilePicture)))
        return imageView
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .systemPink
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupKeyboardDismissal()
    }

    func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(locationTextField)
        view.addSubview(signUpButton)
        view.addSubview(loadingSpinner)

        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true

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
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20).isActive = true
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
              let location = locationTextField.text, !location.isEmpty,
              let profileImage = profileImageView.image else {
            showAlert(title: "Missing Information", message: "Please enter both email and password.")
            return
        }
        
        loadingSpinner.startAnimating()

        viewModel.createUser(name: name, email: email, password: password, location: location) { [weak self] error in
            guard let self = self else { return }
            self.loadingSpinner.stopAnimating()
            if let error = error {
                self.showAlert(title: "Sign Up Failed", message: error.localizedDescription)
                return
            }
            
            // Upload the profile picture to Firebase
            guard let uid = Auth.auth().currentUser?.uid else {
                self.showAlert(title: "Error", message: "User ID not found.")
                return
            }
            ProfilePictureService.shared.uploadProfilePicture(uid: uid, image: profileImage) { result in
                switch result {
                case .success(let url):
                    // Save the profile picture URL
                    self.viewModel.updateProfilePictureUrl(url, for: uid) { error in
                        if let error = error {
                            self.showAlert(title: "Error", message: "Failed to save profile picture URL: \(error.localizedDescription)")
                        } else {
                            self.showAlert(title: "Success", message: "Profile setup complete.", completion: {
                                self.navigateToDashboard()
                            })
                        }
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: "Failed to upload profile picture: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func navigateToDashboard() {
        let joblistingScreenVC = JobListingsViewController()
        let navigationController = UINavigationController(rootViewController: joblistingScreenVC)
        navigationController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(navigationController, animated: true, completion: nil)
        }
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func selectProfilePicture() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//    private func navigateToSignIn() {
//        let signInVC = SignInViewController()
//        navigationController?.setViewControllers([signInVC], animated: true)
//    }

