//
//  GameViewController.swift
//  firependu
//
//  Created by Julien Hennet on 21/11/2016.
//
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var cvLetters: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionAskForLetter(_ sender: AnyObject) {
        
    }

    @IBAction func actionAskForWord(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToEndGame", sender: nil)
    }
    
}


extension LoginViewController: UICollectionViewDelegateFlowLayout {
    
}
