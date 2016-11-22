//
//  ListGameViewController.swift
//  firependu
//
//  Created by Julien Hennet on 21/11/2016.
//
//

import UIKit
import FirebaseDatabase

class ListGameViewController: UIViewController {
    
    private var gamesRefHandle: FIRDatabaseHandle?
    var games = [Game]()
    
    @IBOutlet weak var tvGames: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeGames()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func actionCreateGame(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToGame", sender: nil)
    }
    
    // MARK: Firebase related methods
    private func observeGames() {
        // Use the observe method to listen for new
        // games being written to the Firebase DB
        gamesRefHandle = FirebaseManager().gamesRef.observe(.childAdded, with: {[unowned self] (snapshot) -> Void in // 1
            let gamesData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            if let name = gamesData["name"] as? String, name.characters.count > 0,
                let players = gamesData["players"] as? [Player], players.count == 1 {
                let game = Game(gameID: id, name: name, players: players)
                self.games.append(game)
                self.tvGames.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
}

extension ListGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ListGameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") ?? UITableViewCell(style: .default, reuseIdentifier: "gameCell")
        
        let game = games[indexPath.row]
        cell.textLabel?.text = game.name
        cell.detailTextLabel?.text = "Crée par \(game.players[0].nickName)"
        
        return cell
    }
    
}
