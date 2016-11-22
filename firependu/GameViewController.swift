    //
//  GameViewController.swift
//  firependu
//
//  Created by Julien Hennet on 21/11/2016.
//
//

import UIKit
import Firebase

var cellSize = 30
var cellSpacing = 5

class GameViewController: UIViewController {
    
    @IBOutlet weak var cvWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvLetters: UICollectionView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnAddLetter: UIButton!
    @IBOutlet weak var btnAddWord: UIButton!
    
    var game: Game?
    var letters: [String?] = [String?]()
    let alphabet = ["a","b","c","d","e","f","g","h","i","j","h","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    let gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.backgroundColor = UIColor.white
        pickerView.isHidden = true
        
        guard let game = self.game else {
            return
        }
        for char in game.word.characters {
            letters.append(char == " " || char == "-" ? "\(char)" : nil)
        }
        drawCollectionView()
        
        gameManager.gameTurnObserver(game: game) { (refresh) in
            
            if refresh == true {
                self.game?.turns = self.gameManager.turnsDataSource
                self.redrawView()
            }
        }
    }
    
    func drawCollectionView() {
        let maxWidth = Int(view.frame.size.width) - 40
        var nbLettersByLine = 0
        while nbLettersByLine < letters.count  {
            if (nbLettersByLine + 1) * cellSize + nbLettersByLine * cellSpacing < maxWidth {
                nbLettersByLine += 1
            } else {
                break
            }
        }
        let nbColumns = (letters.count / nbLettersByLine) + 1
        
        cvWidthConstraint.constant = CGFloat( nbLettersByLine * cellSize + (nbLettersByLine - 1) * cellSpacing )
        cvHeightConstraint.constant = CGFloat( nbColumns * cellSize + (nbColumns - 1) * cellSpacing )
        
        redrawView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func redrawView() {
        
        for turn in game!.turns {
            for (id, letter) in game!.word.characters.enumerated() {
                if "\(letter)" == turn.letter {
                    letters[id] = turn.letter
                }
            }
        }
        
        if game!.isOwnTurn() {
            lblInfo.text = "C'est à vous de jouer"
            lblInfo.backgroundColor = UIColor.green
            btnAddLetter.isEnabled = true
            btnAddLetter.alpha = 1.0
            btnAddWord.isEnabled = true
            btnAddWord.alpha = 1.0
        } else {
            lblInfo.text = "Veuillez attendre le tour de votre adversaire"
            lblInfo.backgroundColor = UIColor.red
            btnAddLetter.isEnabled = false
            btnAddLetter.alpha = 0.5
            btnAddWord.isEnabled = false
            btnAddWord.alpha = 0.5
        }
        
        cvLetters.reloadData()
    }

    
    @IBAction func actionAskForLetter(_ sender: AnyObject) {
        pickerView.isHidden = false
    }

    @IBAction func actionAskForWord(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToEndGame", sender: nil)
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        pickerView.isHidden = true
    }
    
    
    @IBAction func actionOK(_ sender: Any) {
        pickerView.isHidden = true
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        let letter = alphabet[picker.selectedRow(inComponent: 0)]
        let turn = Turn(turnID: nil, userID: user.uid, letter: letter)
        GameManager().addTurn(game: game!, turn: turn)
        redrawView()
    }
}


extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "letterCell", for: indexPath) as? LetterCell {
            cell.initialize(with: letters[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension GameViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return alphabet.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return alphabet[row]
    }
    
}
