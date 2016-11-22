//
//  UserConnection.swift
//  firependu
//
//  Created by Vincent COUVERCHEL on 21/11/2016.
//
//

import Foundation
import Firebase

class User {
	
	func register(withEmail email: String, andPassword password: String) {
		FIRAuth.auth()?.createUser(withEmail: email, password: password) {
			(user, error) in
			if error == nil, let user = user {
				print("User created")
				
				self.sendVerificationEmail(user: user)
			}
			else {
				print("registration error: \(error)")
			}
		}
	}
	
	func logIn(withEmail email: String, andPassword password: String) {
		FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
			self.printUserInfos()
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
	
	func set(name: String) {
		let user = FIRAuth.auth()?.currentUser
		if let user = user {
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
