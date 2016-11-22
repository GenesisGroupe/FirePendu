//
//  ListGameViewController.swift
//  firependu
//
//  Created by Julien Hennet on 21/11/2016.
//
//

import UIKit
import Firebase
import FirebaseDatabase

class ListGameViewController: GenericViewController {
    
    @IBOutlet weak var tvGames: UITableView!
    @IBOutlet weak var tfGameName: UITextField!
    let gameManager = GameManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeGames()
        navigationItem.hidesBackButton = true
        title = "Parties en cours"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tvGames.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let destination = segue.destination as! GameViewController
                destination.game = sender as? Game
        }
    }
    

    
    @IBAction func actionCreateGame(_ sender: AnyObject) {
        guard let name = tfGameName.text else { return }
        gameManager.createGame(name: name)
        self.performSegue(withIdentifier: "goToGame", sender: nil)
    }
    
    // MARK: Firebase related methods
    private func observeGames() {
        gameManager.gamesListObserver { (refresh) in
            if refresh == true { self.tvGames.reloadData() }
        }
    }
}

extension ListGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = GameManager.sharedInstance.games[indexPath.row]
        if !game.isOwnGame && game.guest == nil {
            guard let _ = Player.currentPlayer else {
                return
            }
            
            let joinAction = UIAlertAction(title: "Ok", style: .default, handler: {[unowned self] (_) in
                self.gameManager.join(game: game, with: {[unowned self] (success) in
                    if (success) {
                        self.performSegue(withIdentifier: "goToGame", sender: nil)
                    }
                })
            })
            self.showAlert(with: nil, message: "Voulez-vous rejoindre cette partie ?", actions: [joinAction], and: "Annuler")
        } else {
            self.performSegue(withIdentifier: "goToGame", sender: nil)
        }
        
        
    }
    
}

extension ListGameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameManager.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") ?? UITableViewCell(style: .default, reuseIdentifier: "gameCell")
        
        let game = gameManager.games[indexPath.row]
        cell.textLabel?.text = game.name
        cell.detailTextLabel?.text = "Créée par \(game.host?.name ?? "")"
        cell.backgroundColor = game.isOwnGame ? UIColor.green : UIColor.orange
        return cell
    }
    
}
