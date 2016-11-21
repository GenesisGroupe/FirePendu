//
//  BorderedTextField.swift
//  firependu
//
//  Created by Julien Hennet on 21/11/2016.
//
//

import UIKit

class BorderedTextField: UITextField {


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        rightViewMode = .always
    }


}
