//
//  SignUpViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/10.
//

import Foundation
import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let viewModel = SignUpViewModel()
    
    // MARK: - UI Elements
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfilePicture)))
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameTextField = createTextField(placeholder: "Full Name")
    lazy var emailTextField = createTextField(placeholder: "Email", keyboardType: .emailAddress)
    lazy var passwordTextField = createTextField(placeholder: "Password", isSecure: true)
    lazy var locationTextField = createTextField(placeholder: "Location")
    lazy var jobTitleTextField = createTextField(placeholder: "Desired Job Title")
    lazy var skillsTextField = createTextField(placeholder: "Skills (comma-separated)")
    lazy var qualificationsTextField = createTextField(placeholder: "Qualifications (comma-separated)")
    lazy var experienceTextField = createTextField(placeholder: "Work Experience (e.g. 5 years Developer)")
    lazy var educationTextField = createTextField(placeholder: "Education Background")

    lazy var signUpButton: UIButton = {
        return ButtonFacade.shared.createButton(
            title: "Sign Up",
            backgroundColor: .systemBlue,
            target: self,
            action: #selector(handleSignUp)
        )
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileImageView)
        let fields = [nameTextField, emailTextField, passwordTextField, locationTextField,
                      jobTitleTextField, skillsTextField, qualificationsTextField, experienceTextField, educationTextField, signUpButton]
        
        var previousField: UIView? = nil
        
        for field in fields {
            contentView.addSubview(field)
            NSLayoutConstraint.activate([
                field.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                field.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                field.heightAnchor.constraint(equalToConstant: 50)
            ])
            if let previous = previousField {
                field.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 15).isActive = true
            } else {
                field.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
            }
            previousField = field
        }
        
        profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecure
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    // MARK: - Image Picker
    
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

    // MARK: - Handle Sign Up
    
    @objc private func handleSignUp() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let location = locationTextField.text else {
            showAlert("All fields are required")
            return
        }

        // Validate Inputs
        if !ValidationManager.shared.validateInputs(fields: [name, email, password, location]) {
            showAlert("All fields are required")
            return
        }

        if !ValidationManager.shared.validateEmail(email) {
            showAlert("Invalid email format")
            return
        }

        if !ValidationManager.shared.validatePassword(password) {
            showAlert("Password must contain at least 8 characters, including an uppercase letter, a number, and a special character.")
            return
        }

        viewModel.createUser(
            name: name,
            email: email,
            password: password,
            location: location,
            jobTitle: jobTitleTextField.text ?? "",
            skills: skillsTextField.text ?? "",
            qualifications: qualificationsTextField.text ?? "",
            experience: experienceTextField.text ?? "",
            education: educationTextField.text ?? ""
        ) { [weak self] error in
            if let error = error {
                self?.showAlert("Sign Up Failed: \(error.localizedDescription)")
            } else {
                self?.showAlert("Sign Up Successful!", isSuccess: true)
            }
        }
    }
    
    private func showAlert(_ message: String, isSuccess: Bool = false) {
        let alert = UIAlertController(title: isSuccess ? "Success" : "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
