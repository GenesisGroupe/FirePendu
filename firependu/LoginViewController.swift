//
//  LoginViewController.swift
//  firependu
//
//  Created by Julien Hennet on 21/11/2016.
//
//

import UIKit

class LoginViewController: UIViewController {
   
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
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
    

    //MARK: Actions
    @IBAction func actionLogin(_ sender: AnyObject) {
        performSegue(withIdentifier: "goToGameList", sender: nil)
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

}

