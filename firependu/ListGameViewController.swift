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
    private var games = [Game]()
    
    @IBOutlet weak var tvGames: UITableView!
    @IBOutlet weak var tfGameName: UITextField!

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
        guard let name = tfGameName.text else { return }
        
        GameManager.sharedInstance.createGame(name: name)
    }
    
    // MARK: Firebase related methods
    private func observeGames() {
        // Use the observe method to listen for new
        // games being written to the Firebase DB
        gamesRefHandle = FirebaseManager().gamesRef.observe(.childAdded, with: {[unowned self] (snapshot) -> Void in
            let game = Game(snapshot: snapshot)
            self.games.append(game)
            self.tvGames.reloadData()
        })
    }
}

extension ListGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ListGameViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
