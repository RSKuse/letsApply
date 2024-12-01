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


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchGreetingMessage()
    }

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

    @objc private func editProfileTapped() {
        let profileVC = ProfileSetupViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }

    @objc private func handleLogout() {
        let signInViewContrller = UINavigationController(rootViewController: SignInViewController())
        signInViewContrller.modalPresentationStyle = .fullScreen
        signInViewContrller.modalTransitionStyle = .crossDissolve
        self.present(signInViewContrller, animated: true, completion: nil)
        /*
        viewModel.logout { [weak self] loggedOut in
            DispatchQueue.main.async {
                guard let self else { return }
                if loggedOut {
                    let signInViewContrller = SignInViewController()
                    signInViewContrller.modalTransitionStyle = .crossDissolve
                    self.present(signInViewContrller, animated: true, completion: nil)
                } else {
                    print("Failed to log out.")
                }
            }
        }
        */
    }
    
    private func fetchGreetingMessage() {
        viewModel.fetchGreeting { [weak self] message in
            DispatchQueue.main.async {
                self?.greetingLabel.text = message
            }
        }
    }
}
    
    //
    //    @objc private func showJobListings() {
    //        let jobListingsVC = JobListingsViewController() // Placeholder
    //        navigationController?.pushViewController(jobListingsVC, animated: true)
    //    }
    //
    //    @objc private func showCVBuilder() {
    //        let cvBuilderVC = CVBuilderViewController() // Placeholder
    //        navigationController?.pushViewController(cvBuilderVC, animated: true)
    //    }
    //
    //    @objc private func showSkillChallenges() {
    //        let skillChallengesVC = SkillChallengesViewController() // Placeholder
    //        navigationController?.pushViewController(skillChallengesVC, animated: true)
    //    }
    //
    //    @objc private func showNotifications() {
    //        let notificationsVC = NotificationsViewController() // Placeholder
    //        navigationController?.pushViewController(notificationsVC, animated: true)
    //    }

