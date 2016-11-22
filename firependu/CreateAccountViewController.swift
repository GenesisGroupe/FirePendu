//
//  CreateAccountViewController.swift
//  firependu
//
//  Created by Julien Hennet on 21/11/2016.
//
//

import UIKit

class CreateAccountViewController: GenericViewController {

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
    
    func validate() -> Bool {
        return tfUsername.text != "" && tfEmail.text != "" && tfPassword.text != "" && tfPasswordConfirm.text != "" && tfPassword.text == tfPasswordConfirm.text
    }
    
    
    
    @IBAction func actionCreateAccount(_ sender: AnyObject?) {
        if validate() {
            Loader.show()
            AuthentificationManager.shared.register(withEmail: tfEmail.text!, tfPassword.text!, andUsername: tfUsername.text!, completionHandler: { (user, error) in
                Loader.hide()
                if user != nil && error == nil {
                    self.pop(true)
                } else {
                    self.showAlert(with: nil, message: "Erreur d'authentification. Veuillez réessayer.", actions: nil)
                }
            })
        } else {
            self.showAlert(with: nil, message: "Il y a des erreurs dans le formulaire. Veuillez remplir tous les champs et vérifier que les mots de passe correspondent.", actions: nil)
        }
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
