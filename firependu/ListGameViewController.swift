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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let destination = segue.destination as! GameViewController
                destination.game = sender as? Game
        }
    }
    

    
    @IBAction func actionCreateGame(_ sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: "Veuillez entrer un nom pour votre partie", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Nom de la partie"
        }

        let cancelAction = UIAlertAction(title: "Annuler", style: .default, handler: nil)
        let saveAction = UIAlertAction(title: "Ok", style: .default, handler: {
            alert -> Void in
            if alertController.textFields![0].text != "" {
                guard let user = FIRAuth.auth()?.currentUser else {
                    return
                }
                let game = Game(gameID: nil, name: alertController.textFields![0].text!, word: nil, host: Player(user: user), guest: nil)
                GameManager().joinGame(game: game, isHost: true)
                self.performSegue(withIdentifier: "goToGame", sender: game)
            } else {
                self.showAlert(with: nil, message: "Vous devez entrer un nom pour votre partie", actions: nil)
            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
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
        let game = gameManager.gameDataSource[indexPath.row]
        if !game.isOwnGame() && game.guest == nil {
            guard let user = FIRAuth.auth()?.currentUser else {
                return
            }
            let joinAction = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                game.guest = Player(user: user)
                self.gameManager.joinGame(game: game, isHost: false)
                self.performSegue(withIdentifier: "goToGame", sender: game)
            })
            self.showAlert(with: nil, message: "Voulez-vous rejoindre cette partie ?", actions: [joinAction], and: "Annuler")
        } else {
            self.performSegue(withIdentifier: "goToGame", sender: game)
        }
        
        
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
        cell.backgroundColor = game.isOwnGame() ? UIColor.green : UIColor.orange
        return cell
    }
    
}
