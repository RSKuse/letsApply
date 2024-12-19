//
//  MainTabBarController.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/14.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        
        
        // Home Dashboard
        let homeScreenVC = UINavigationController(rootViewController: HomeScreenViewController())
        homeScreenVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        // Job Listings
        let jobListingScreenVC = UINavigationController(rootViewController: JobListingsViewController())
        jobListingScreenVC.tabBarItem = UITabBarItem(title: "Jobs", image: UIImage(systemName: "briefcase"), tag: 1)
        

        // Profile Setup
        let profileVC = UINavigationController(rootViewController: ProfileSetupViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
        
        // CV Builder
        let cvBuilderVC = UINavigationController(rootViewController: CVBuilderViewController())
        cvBuilderVC.tabBarItem = UITabBarItem(title: "CV", image: UIImage(systemName: "doc.text"), tag: 3)
        
        viewControllers = [homeScreenVC, jobListingScreenVC, profileVC, cvBuilderVC]
    }
    private func configureTabBarAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .white
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 5
    }
}
