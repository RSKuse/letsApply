//
//  FirebaseAuthenticationService.swift
//  letsApply
//
//  Created by Gugulethu Mhlanga on 2024/11/19.
//

import Foundation
import FirebaseAuth

class FirebaseAuthenticationService {
    
    // Singleton instance of the service
    static let shared = FirebaseAuthenticationService()
    
    init() {} // Make the initializer private to enforce singleton usage
    
    var isAuthenticatedAnonymously: Bool {
        return Auth.auth().currentUser?.isAnonymous ?? false
    }
    
    var isAuthenticatedViaEmail: Bool {
        return Auth.auth().currentUser?.email != nil
    }
    
    var isAuthenticated: Bool {
        return isAuthenticatedAnonymously || isAuthenticatedViaEmail
    }
    
    /**
     Sign in Anonymously
     */
    func signUpAnonymously(completion: @escaping (Error?) -> Void) {
        Auth.auth().signInAnonymously { authResult, error in
            completion(error)
        }
    }
    
    /**
     Email Sign Up
     */
    func signUp(email: String,
                password: String,
                completion: @escaping (Error?) -> Void) {
        let authenticationCredential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.link(with: authenticationCredential,
                                      completion: { authResult, error in
            completion(error)
        })
        /*
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
        */
    }
    /**
     Email Sign In
     */
    func signIn(email: String,
                password: String,
                completion: @escaping (Result<UserProfile, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "AuthError", code: AuthErrorCode.userNotFound.rawValue, userInfo: nil)))
                return
            }
            FirestoreService().fetchUserProfile(uid: user.uid, completion: completion)
        }
    }
    /**
     Reset Password
     */
    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    /**
     Log Out
     */
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
