//
//  GameViewController.swift
//  firependu
//
//  Created by Julien Hennet on 21/11/2016.
//
//

import UIKit

var cellSize = 30
var cellSpacing = 5

class GameViewController: UIViewController {
    
    @IBOutlet weak var cvWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cvLetters: UICollectionView!
    var word: String = "bonjour"
    var letters: [String?] = [String?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for char in word.characters {
            letters.append(char == " " || char == "-" ? "\(char)" : nil)
        }
        drawCollectionView()
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
        
        cvLetters.reloadData()
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
