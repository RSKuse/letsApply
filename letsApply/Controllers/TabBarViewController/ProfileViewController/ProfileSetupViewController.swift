//
//  ProfileSetupViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/10.
//

import Foundation
import UIKit

class ProfileSetupViewController: UIViewController, UITextFieldDelegate {

    let firestoreService = FirestoreService()
    var currentUser: UserProfile?
    private let viewModel = ProfileSetupViewModel()

    // Use ButtonFacade to create buttons
    lazy var saveButton: UIButton = {
        return ButtonFacade.shared.createButton(
            title: "Save Profile",
            titleColor: .systemBlue,
            backgroundColor: .clear,
            target: self,
            action: #selector(saveProfile)
        )
    }()

    lazy var logoutButton: UIButton = {
        return ButtonFacade.shared.createButton(
            title: "Log Out",
            titleColor: .systemBlue,
            backgroundColor: .clear,
            target: self,
            action: #selector(handleLogout)
        )
    }()

    lazy var skillsTextField: UITextField = {
        let textField = UITextField()
        textField.configureTextField(placeholder: "Skills (comma-separated)", keyboardType: .emailAddress)
        return textField
    }()

    lazy var locationTextField: UITextField = {
        let textField = UITextField()
        textField.configureTextField(placeholder: "Location", keyboardType: .emailAddress)
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchUserProfileData()
        setupKeyboardDismissal()
    }

    func setupUI() {
        view.addSubview(skillsTextField)
        view.addSubview(locationTextField)
        view.addSubview(saveButton)
        view.addSubview(logoutButton)


        skillsTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        skillsTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        skillsTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        skillsTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        locationTextField.topAnchor.constraint(equalTo: skillsTextField.bottomAnchor, constant: 20).isActive = true
        locationTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        locationTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        locationTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true

        saveButton.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 20).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        saveButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        logoutButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        logoutButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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

    private func fetchUserProfileData() {
        viewModel.fetchUserProfile { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load profile:", error)
                return
            }
            self.skillsTextField.text = self.viewModel.userProfile?.skills.joined(separator: ", ")
            self.locationTextField.text = self.viewModel.userProfile?.location
        }
    }

    @objc private func saveProfile() {
        guard let skillsText = skillsTextField.text,
              let locationText = locationTextField.text else {
            print("Please fill out all fields.")
            return
        }
        let skillsArray = skillsText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        viewModel.saveProfile(skills: skillsArray, location: locationText) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to save profile:", error)
                return
            }

            print("Profile updated successfully.")
            let mainTabBarController = MainTabBarController()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = mainTabBarController
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
        }
    }

    @objc private func handleLogout() {
        viewModel.logout { error in
            if let error = error {
                print("Failed to log out:", error)
                return
            }

            DispatchQueue.main.async {
                let signInViewController = UINavigationController(rootViewController: SignInViewController())
                signInViewController.modalTransitionStyle = .crossDissolve
                signInViewController.modalPresentationStyle = .fullScreen

                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = signInViewController
                    window.makeKeyAndVisible()

                    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            }
        }
    }
}
