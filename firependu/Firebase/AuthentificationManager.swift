//
//  UserConnection.swift
//  firependu
//
//  Created by Vincent COUVERCHEL on 21/11/2016.
//
//

import Foundation
import Firebase

class AuthentificationManager {
    
    static let shared = AuthentificationManager()
    
    
    private init() {}
	
    func register(withEmail email: String, _ password: String, andUsername username: String, completionHandler: @escaping (_ user: FIRUser?, _ error: Error?) -> Void) {
		FIRAuth.auth()?.createUser(withEmail: email, password: password) {
			(user, error) in
			if error == nil, let user = user {
				print("User created")
                self.set(name: username, for: user)
				self.sendVerificationEmail(user: user)
                completionHandler(user, error)
			}
			else {
				print("registration error: \(error)")
			}
		}
	}
	
	func logIn(withEmail email: String, andPassword password: String, completionHandler: @escaping (_ user: FIRUser?, _ error: Error?) -> Void) {
		FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
			self.printUserInfos()
            completionHandler(user, error)
		}
	}
	
	func logOut() {
		try! FIRAuth.auth()!.signOut()
	}
	
	func printUserInfos() {
		if let user = FIRAuth.auth()?.currentUser {
			for profile in user.providerData {
				print(profile.displayName)
				print(profile.email)
			}
		} else {
			print("No user is signed in.")
		}
	}
	
    func set(name: String, for user: FIRUser) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges {
            error in
            if let error = error {
                print("Erreur: Le nom n'a pas pu etre modifier: \(error)")
            } else {
                print("Le nom a été modifié")
            }
        }
	}
	
	func sendVerificationEmail(user: FIRUser) {
		
		user.sendEmailVerification() { error in
			if let error = error {
				print("sendEmailVerification error: \(error)")
			} else {
				print("Email envoyé")
			}
		}
	}
	
}
