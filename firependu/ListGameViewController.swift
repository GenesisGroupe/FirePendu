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
    
    @IBOutlet weak var tvGames: UITableView!
    let gameManager = GameManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeGames()
        navigationItem.hidesBackButton = true
        title = "Parties en cours"
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
        gameManager.gamesListObserver { (refresh) in
            if refresh == true { self.tvGames.reloadData() }
        }
    }
}

extension ListGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ListGameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameManager.gameDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") ?? UITableViewCell(style: .default, reuseIdentifier: "gameCell")
        
        let game = gameManager.gameDataSource[indexPath.row]
        cell.textLabel?.text = game.name
        cell.detailTextLabel?.text = "Créée par \(game.host.nickName)"
        
        return cell
    }
    
}
