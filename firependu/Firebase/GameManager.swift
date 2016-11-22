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

class GameManager {
	var ref: FIRDatabaseReference!
	var currentGame: String? = nil
    var gameDataSource = [Game]()
	
	init() {
		self.ref = FIRDatabase.database().reference()
	}
	
    func joinGame(game: Game, isHost: Bool) {
		if let user = FIRAuth.auth()?.currentUser {
			let refGames = ref.child("Games")
            let player = ["name": user.displayName ?? "none", "uid": user.uid]
            let values: [String: Any?] = ["id": game.gameID, "name": game.name, "word": game.word, (isHost ? "host" : "guest") : player]
            refGames.child(game.gameID).setValue(values)
		}
	}

    func gamesListObserver( completionHandler: @escaping (_ refresh: Bool) -> Void) {
		ref.child("Games").observe(.childAdded, with: {
			snapshot in
            guard let games = snapshot.value as? [String: AnyObject] else {
                completionHandler(false)
                return
            }
            let gameID = games["id"] as? String ?? ""
            let name = games["name"] as? String ?? ""
            let word = games["word"] as? String ?? ""
            guard games["guest"] == nil,
                let host = games["host"] as? [String: AnyObject],
                let uid = host["uid"] as? String,
                let nickName = host["name"] as? String else {
                    completionHandler(false)
                    return
            }
            let hostPlayer = Player(playerID: uid, nickName: nickName)
            let game = Game(gameID: gameID, name: name, word: word, host: hostPlayer, guest: nil)
            
            var index: Int?
            for (id, game) in self.gameDataSource.enumerated() {
                if game.gameID == gameID {
                    index = id
                    break
                }
            }
            if index == nil {
                self.gameDataSource.append(game)
            } else {
                self.gameDataSource[index!] = game
            }
            completionHandler(true)
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
			let refTurns = ref.child("Games").child(currentGame).child("turns")
			refTurns.observeSingleEvent(of: .value, with: {
				snapshot in
				refTurns.child("\(snapshot.childrenCount)")
					.setValue(["letter": letter,
					           "user": user.uid])
				})
		}
	}
	
}
