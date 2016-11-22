//
//  LoginViewController.swift
//  firependu
//
//  Created by Julien Hennet on 21/11/2016.
//
//

import UIKit
import Firebase

class LoginViewController: GenericViewController {
   
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser != nil {
            performSegue(withIdentifier: "goToGameList_notAnimated", sender: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func validate() -> Bool {
        return tfEmail.text != "" && tfPassword.text != ""
    }

    //MARK: Actions
    @IBAction func actionLogin(_ sender: AnyObject?) {
        if validate() {
            Loader.show()
            AuthentificationManager.shared.logIn(withEmail: tfEmail.text!, andPassword: tfPassword.text!, completionHandler: { (user, error) in
                Loader.hide()
                if user != nil && error == nil {
                    self.performSegue(withIdentifier: "goToGameList", sender: nil)
                } else {
                    self.showAlert(with: nil, message: "Erreur d'authentification. Veuillez réessayer.", actions: nil)
                }
            })
        } else {
            self.showAlert(with: nil, message: "Tous les champs ne sont pas remplis", actions: nil)
        }
    }

    @IBAction func actionLoginWithGoogle(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToGameList", sender: nil)
    }

    @IBAction func actionLoginAnonymous(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToGameList", sender: nil)
    }
    
    @IBAction func actionCreateAccount(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToCreateAccount", sender: nil)
    }

}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var tfResponder: UITextField? = nil
        if textField == tfEmail {
            tfResponder = tfPassword
        } else {
            actionLogin(nil)
        }
        textField.resignFirstResponder()
        tfResponder?.becomeFirstResponder()
        return true
    }

}

