//
//  AppDelegate.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/09.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Check for jailbroken devices
        if SecurityManager.shared.isDeviceJailbroken() {
            fatalError("This app does not support jailbroken devices.")
        }
        
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Set up the main window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // Check user session
        if let user = Auth.auth().currentUser {
            // Fetch user profile to determine next screen
            FirestoreService().fetchUserProfile(uid: user.uid) { [weak self] result in
                switch result {
                case .success(let profile):
                    if profile.skills.isEmpty || profile.location.isEmpty {
                        // Show ProfileSetupViewController if profile is incomplete
                        self?.window?.rootViewController = UINavigationController(rootViewController: ProfileSetupViewController())
                    } else {
                        // Show MainTabBarController if profile is complete
                        self?.window?.rootViewController = MainTabBarController()
                    }
                case .failure:
                    // Default to SignInViewController on error
                    self?.window?.rootViewController = UINavigationController(rootViewController: SignInViewController())
                }
            }
        } else {
            // Show SignInViewController if not logged in
            window?.rootViewController = UINavigationController(rootViewController: SignInViewController())
        }
        
        return true
    }
}
