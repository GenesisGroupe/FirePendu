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
    var gameDataSource = [Game]()
    var turnsDataSource = [Turn]()
	
	init() {
		self.ref = FIRDatabase.database().reference()
	}
	
    func joinGame(game: Game, isHost: Bool) {
		if let user = FIRAuth.auth()?.currentUser {
            let player = ["name": user.displayName ?? "none", "uid": user.uid]
            if isHost {
                let values: [String: Any?] = ["id": game.gameID, "name": game.name, "word": game.word, "host": player]
                ref.child("Games").setValue(values)
            } else {
                ref.child("Games").child(game.gameID).child("guest").setValue(player)
            }
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
            guard let host = games["host"] as? [String: AnyObject],
                let uid = host["uid"] as? String,
                let nickName = host["name"] as? String,
                let user = FIRAuth.auth()?.currentUser,
                games["guest"] == nil || games["guest"]!["uid"] as! String == user.uid || uid == user.uid else {
                    completionHandler(false)
                    return
            }
            let hostPlayer = Player(playerID: uid, nickName: nickName)
            var guestPlayer:Player?
            if let guest = games["guest"] as? [String: AnyObject],
                let guestID = guest["uid"] as? String,
                let guestName = guest["name"] as? String{
                guestPlayer = Player(playerID: guestID, nickName: guestName)
            }
            
            let game = Game(gameID: gameID, name: name, word: word, host: hostPlayer, guest: guestPlayer)
            
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
	
    func gameTurnObserver(game: Game, completionHandler: @escaping (_ refresh: Bool) -> Void) {
		
        ref.child("Games").child(game.gameID).child("turns").observe(.childAdded, with: {
            snapshot in
            
            guard let turns = snapshot.value as? [String: String] else {
                completionHandler(false)
                return
            }
            guard let turnID = turns["id"], let letter = turns["letter"], let userID = turns["user"] else {
                completionHandler(false)
                return
            }
            
            let turn = Turn(turnID: turnID, userID: userID, letter: letter)
            
            var index: Int?
            for (id, turn) in self.turnsDataSource.enumerated() {
                if turn.turnID == turnID {
                    index = id
                    break
                }
            }
            if index == nil {
                print(turn.letter)
                self.turnsDataSource.append(turn)
                completionHandler(true)
            }
        
        })
		
		
	}
	
    func addTurn(game: Game, turn: Turn) {
		if let user = FIRAuth.auth()?.currentUser {
			let refTurns = ref.child("Games").child(game.gameID).child("turns")
			refTurns.observeSingleEvent(of: .value, with: {
				snapshot in
				refTurns.child("\(snapshot.childrenCount)")
					.setValue(["id": turn.turnID,
                            "letter": turn.letter,
					           "user": user.uid])
				})
		}
	}
	
}
