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

final class GameManager {
    static let sharedInstance: GameManager = GameManager()
	var currentGame: Game? = nil
	
	private init() { }
	
//	func createGame(game: Game) {
//		if let user = FIRAuth.auth()?.currentUser {
//			let refGames = ref.child("Games")
//			refGames.observeSingleEvent(of: .value, with: {
//				snapshot in
//				let nb = snapshot.childrenCount
//				refGames.child("\(nb)").setValue(["name": game.name])
//				refGames.child("\(nb)").child("users").setValue(["host": user.uid])
//				self.currentGame = "\(nb)"
//			})
//		}
//	}
    
    func createGame(name: String) {
        guard let host = Player.currentPlayer else { return }
        
        currentGame = Game(name: name, host: host)
        currentGame!.create()
    }
    
    func join(game: Game, with block: @escaping (Bool) -> Void) {
        game.joinGame {[unowned self] (success) in
            if success {
                self.currentGame = game
            }
            
            block(success)
        }
    }
    
    func quitGame() {
        self.currentGame = nil
    }
	
//	func gameStartObserver(name: String) {
//		ref.child("Games").child(name).child("users").observeSingleEvent(of: .childAdded, with: {
//			snapshot in
//			if snapshot.hasChild("guest") {
//				print("game start")
//			}
//		})
//	}
	
//	func gameTurnObserver() {
//		if let user = FIRAuth.auth()?.currentUser, let currentGame = currentGame {
//			ref.child("Games").child(currentGame).child("turns").observe(.childAdded, with: {
//				snapshot in
//				if let turns = snapshot.value as? [[String: String]] {
//					if let newTurn = turns.last {
//						if let userUid = newTurn["user"] {
//							if userUid != user.uid {
//								print("Opponent played")
//								if let letter = newTurn["letter"] {
//									print("He try the letter: \(letter)")
//								}
//							}
//						}
//					}
//				}
//			})
//		}
//		
//	}
	
	func addTurn(letter: String) {
        guard let currentPlayerKey = Player.currentPlayer?.key,
              let currentGame = currentGame,
              letter.characters.count == 1 else { return }
        
        let turn = Turn(user: currentPlayerKey, letter: Character(letter))
        currentGame.add(turn: turn)
	}
	
}
