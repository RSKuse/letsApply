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
        let homeScreenVC = UINavigationController(rootViewController: HomeScreenViewController())
        homeScreenVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let profileVC = UINavigationController(rootViewController: ProfileSetupViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)

        
        // Add Job Listings Tab
//        let jobListingsVC = UINavigationController(rootViewController: JobListingsViewController())
//        jobListingsVC.tabBarItem = UITabBarItem(title: "Jobs", image: UIImage(systemName: "briefcase"), tag: 2)
        
        let cvBuilderVC = UINavigationController(rootViewController: CVBuilderViewController())
        cvBuilderVC.tabBarItem = UITabBarItem(title: "CV", image: UIImage(systemName: "doc.text"), tag: 3)
        
        viewControllers = [homeScreenVC, profileVC, cvBuilderVC]
    }
}
