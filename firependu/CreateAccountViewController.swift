//
//  CreateAccountViewController.swift
//  firependu
//
//  Created by Julien Hennet on 21/11/2016.
//
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPasswordConfirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionCreateAccount(_ sender: AnyObject?) {

    }

}

extension CreateAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var tfResponder: UITextField? = nil
        if textField == tfUsername {
            tfResponder = tfEmail
        } else if textField == tfEmail {
            tfResponder = tfPassword
        } else if textField == tfPassword {
            tfResponder = tfPasswordConfirm
        } else {
            actionCreateAccount(nil)
        }
        textField.resignFirstResponder()
        tfResponder?.becomeFirstResponder()
        return true
    }
    
}
