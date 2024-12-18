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
            print("Detected as jailbroken device.")
            fatalError("This app does not support jailbroken devices.")
        }
        
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Set up the main window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        navigateToSplashViewController()
        return true
    }
    
    private func navigateToSplashViewController() {
        if FirebaseAuthenticationService.shared.isAuthenticated {
            let mainTabBarController = MainTabBarController()
            window?.rootViewController = mainTabBarController
        } else {
            let splashViewController = SplashViewController()
            let navigationController = UINavigationController(rootViewController: splashViewController)
            navigationController.modalPresentationStyle = .fullScreen
            window?.rootViewController = navigationController
        }
    }
}

