//
//  LetterCell.swift
//  firependu
//
//  Created by Julien Hennet on 21/11/2016.
//
//

import UIKit

class LetterCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblLetter: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
    }
    
    func initialize(with letter: String?) {
        lblLetter.backgroundColor = letter != nil ? UIColor.lightGray : UIColor.white
        lblLetter.text = letter ?? ""
    }
    
}
