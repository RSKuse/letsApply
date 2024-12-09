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
        navigateToSplashViewController()
        return true
    }
    
    private func navigateToSplashViewController() {
        let splashViewController = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splashViewController)
        navigationController.modalPresentationStyle = .fullScreen
        window?.rootViewController = navigationController
    }
}
