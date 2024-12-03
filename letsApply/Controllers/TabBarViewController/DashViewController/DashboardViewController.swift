//
//  DashboardViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/14.
//

import Foundation
import UIKit
import FirebaseAuth

class DashboardViewController: UIViewController {
    
    private let viewModel = DashboardViewModel()
    
    // MARK: - UI Components
    
    lazy var logoutButton: UIButton = {
        return ButtonFacade.shared.createButton(
            title: "Log Out",
            titleColor: .systemBlue,
            backgroundColor: .clear,
            target: self,
            action: #selector(handleLogout)
        )
    }()
    
    lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.text = "Welcome, User"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfileTapped)))
        return imageView
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchGreetingMessage()
        loadDashboardData()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(greetingLabel)
        view.addSubview(profileImageView)
        view.addSubview(logoutButton)
        
        greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        greetingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        logoutButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // MARK: - Data Loading
    
    private func loadDashboardData() {
        viewModel.fetchUserProfile { [weak self] profile in
            guard let self = self else { return }
            if let profile = profile {
                self.greetingLabel.text = "Welcome, \(profile.name)"
                if let url = profile.profilePictureUrl {
                    self.loadProfilePicture(from: url)
                }
            }
        }
    }

    private func loadProfilePicture(from url: String) {
        ProfilePictureService.shared.fetchProfilePicture(urlString: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.profileImageView.image = image ?? UIImage(systemName: "person.circle")
            }
        }
    }
    
    private func fetchGreetingMessage() {
        viewModel.fetchGreeting { [weak self] message in
            DispatchQueue.main.async {
                self?.greetingLabel.text = message
            }
        }
    }

    @objc private func editProfileTapped() {
        let profileVC = ProfileSetupViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func updateUI(with profile: UserProfile?) {
        DispatchQueue.main.async {
            self.greetingLabel.text = "Welcome, \(profile?.name ?? "Guest")!"
            if let profilePictureUrl = profile?.profilePictureUrl {
            }
        }
    }
    
//    private func updateProfileImage() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        viewModel.fetchProfilePicture(from: uid) { [weak self] image in
//            DispatchQueue.main.async {
//                self?.profileImageView.image = image ?? UIImage(systemName: "person.circle")
//            }
//        }
//    }

    
    @objc private func handleLogout() {
        viewModel.logout { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    let signInViewController = UINavigationController(rootViewController: SignInViewController())
                    signInViewController.modalPresentationStyle = .fullScreen
                    self?.present(signInViewController, animated: true)
                }
            } else {
                print("Failed to log out.")
            }
        }
    }
}
