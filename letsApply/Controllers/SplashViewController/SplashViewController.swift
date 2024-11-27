//
//  SplashScreenViewController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/13.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {

    lazy var viewModel = SplashViewModel()

    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "app_logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var taglineLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's Apply"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        navigateToNextScreen()
    }

    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(taglineLabel)

        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        taglineLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20).isActive = true
        taglineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func animateLogo() {
        /*
        logoImageView.alpha = 0
        taglineLabel.alpha = 0

        UIView.animate(withDuration: 1.5, animations: {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = CGAffineTransform(translationX: 0, y: -20)
        }) { _ in
            UIView.animate(withDuration: 1) {
                self.taglineLabel.alpha = 1
            } completion: { _ in
                self.navigateToNextScreen()
            }
        }
        */
    }

    private func navigateToNextScreen() {
        viewModel.checkAuthentication { [weak self] authenticationState in
            DispatchQueue.main.async {
                guard let self else { return }
                switch authenticationState {
                case .signUp:
                    self.presentController(UINavigationController(rootViewController: OnboardingViewController()))
                case .profileSetup:
                    self.presentController(ProfileSetupViewController())
                case .homeScreen:
                    self.presentController(MainTabBarController())
                }
            }
        }
    }
    
    private func presentController(_ controller: UIViewController) {
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
}