//
//  DashboardViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/14.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {
    
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
    
    lazy var jobListingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Job Listings", for: .normal)
        //button.addTarget(self, action: #selector(showJobListings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cvBuilderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("CV Builder", for: .normal)
        //button.addTarget(self, action: #selector(showCVBuilder), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var skillChallengesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skill Challenges", for: .normal)
        //button.addTarget(self, action: #selector(showSkillChallenges), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var notificationsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Notifications", for: .normal)
        //button.addTarget(self, action: #selector(showNotifications), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(greetingLabel)
        view.addSubview(profileImageView)
        view.addSubview(jobListingsButton)
        view.addSubview(cvBuilderButton)
        view.addSubview(skillChallengesButton)
        view.addSubview(notificationsButton)
        
        
        greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        greetingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        jobListingsButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
        jobListingsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        jobListingsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        jobListingsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cvBuilderButton.topAnchor.constraint(equalTo: jobListingsButton.bottomAnchor, constant: 20).isActive = true
        cvBuilderButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        cvBuilderButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        cvBuilderButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        skillChallengesButton.topAnchor.constraint(equalTo: cvBuilderButton.bottomAnchor, constant: 20).isActive = true
        skillChallengesButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        skillChallengesButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        skillChallengesButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        notificationsButton.topAnchor.constraint(equalTo: skillChallengesButton.bottomAnchor, constant: 20).isActive = true
        notificationsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        notificationsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        notificationsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc private func editProfileTapped() {
        let profileVC = ProfileSetupViewController()
        navigationController?.pushViewController(profileVC, animated: true)
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
}
