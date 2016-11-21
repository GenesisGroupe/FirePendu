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
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Firebase related methods
    private func observeGames() {
        // Use the observe method to listen for new
        // games being written to the Firebase DB
        gamesRefHandle = FirebaseManager().gamesRef.observe(.childAdded, with: {[unowned self] (snapshot) -> Void in // 1
            let gamesData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            if let name = gamesData["name"] as? String, name.characters.count > 0 {
                let game = Game(gameID: id, name: name)
                self.games.append(game)
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }

}
