//
//  Game.swift
//  firependu
//
//  Created by Vincent COUVERCHEL on 21/11/2016.
//
//

import Foundation
import Firebase
import FirebaseDatabase

class GameBase {
	var ref: FIRDatabaseReference!
	var currentGame: String? = nil
	
	init() {
		self.ref = FIRDatabase.database().reference()
	}
	
	func createGame(game: Game) {
		if let user = FIRAuth.auth()?.currentUser {
			let refGames = ref.child("Games")
			refGames.observeSingleEvent(of: .value, with: {
				snapshot in
				let nb = snapshot.childrenCount
				refGames.child("\(nb)").setValue(["name": game.name])
				refGames.child("\(nb)").child("users").child("host").setValue(["uid": user.uid,
				                                                               "name": user.displayName])
				self.currentGame = "\(nb)"
			})
		}
	}
	
	func joinGame(name: String) {
		if let user = FIRAuth.auth()?.currentUser {
			let refGames = ref.child("Games")
			refGames.child(name).child("users").child("guest").setValue(["uid": user.uid,
			                                                             "name": user.displayName])
			self.currentGame = name
		}
	}
	
	func gamesListObserver() {
		ref.child("Games").observe(.childAdded, with: {
			snapshot in
//			let gameDataSource = [Game]()
			if let games = snapshot.value as? [[String: AnyObject]] {
				for gameSnapShot in games {
					let name = gameSnapShot["name"] as? String ?? ""
					let word = gameSnapShot["word"] as? String ?? ""
					if let users = gameSnapShot["users"] as? [String: [String: String]] {
						if users["guest"] == nil {
							if let opponentName = users["host"]?["name"] {
								print(name, word, opponentName)
							}
						}
					}
				}
			}
		})
	}
	
	func gameStartObserver(name: String) {
		ref.child("Games").child(name).child("users").observeSingleEvent(of: .childAdded, with: {
			snapshot in
			if snapshot.hasChild("guest") {
				print("game start")
			}
		})
	}
	
	func gameTurnObserver() {
		if let user = FIRAuth.auth()?.currentUser, let currentGame = currentGame {
			ref.child("Games").child(currentGame).child("turns").observe(.childAdded, with: {
				snapshot in
				if let turns = snapshot.value as? [[String: String]] {
					if let newTurn = turns.last {
						if let userUid = newTurn["user"] {
							if userUid != user.uid {
								print("Opponent played")
								if let letter = newTurn["letter"] {
									print("He try the letter: \(letter)")
								}
							}
						}
					}
				}
			})
		}
		
	}
	
	func addTurn(letter: String) {
		if let user = FIRAuth.auth()?.currentUser, let currentGame = currentGame {
			let refGames = ref.child("Games")
			refGames.child(currentGame).child("turns").setValue(["letter": letter,
			                                                     "user": user.uid])
		}
	}
	
}
