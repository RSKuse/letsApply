//
//  SecurityManager.swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/24.
//

import Foundation

class SecurityManager {
    static let shared = SecurityManager()

    func isDeviceJailbroken() -> Bool {
        #if targetEnvironment(simulator)
        // Skip jailbreak check on the Simulator
        return false
        #else
        // Check for known jailbreak files
        let paths = ["/Applications/Cydia.app", "/usr/sbin/sshd", "/etc/apt"]
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        // Check if sandbox is accessible
        if FileManager.default.fileExists(atPath: "/private") {
            return true
        }

        return false
        #endif
    }
}
