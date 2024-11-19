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
        let dashboardVC = UINavigationController(rootViewController: DashboardViewController())
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)
        
        let profileVC = UINavigationController(rootViewController: ProfileSetupViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        
//        let jobListingsVC = UINavigationController(rootViewController: JobListingsViewController()) // Placeholder
//        jobListingsVC.tabBarItem = UITabBarItem(title: "Jobs", image: UIImage(systemName: "briefcase"), tag: 2)
        
        viewControllers = [dashboardVC, profileVC, /*jobListingsVC*/]
    }
}
