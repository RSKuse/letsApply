//
//  ProfileSetupViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/10.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileSetupViewController: UIViewController {

    let firestoreService = FirestoreService()
    var currentUser: UserProfile?
    private let viewModel = ProfileSetupViewModel()

    lazy var skillsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Skills (comma-separated)"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Location"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Profile", for: .normal)
        button.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchUserProfileData()
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
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true

        logoutButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
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
        viewModel.saveProfile(skills: skillsArray, location: locationText) { error in
            if let error = error {
                print("Failed to save profile:", error)
                return
            }
            print("Profile updated successfully.")
        }
    }

    @objc private func handleLogout() {
        viewModel.logout { error in
            if let error = error {
                print("Failed to log out:", error)
                return
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
