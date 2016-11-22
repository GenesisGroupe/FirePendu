//
//  GenericViewController.swift
//  LeeLoo
//
//  Created by Julien Hennet on 05/09/2016.
//  Copyright © 2016 Julien Hennet. All rights reserved.
//

import UIKit

enum NavigationSide {
    case left
    case right
    case center
}

class GenericViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK : Navigation Bar Items
    func addNavBarButtonWith(_ imageName: String, action: Selector, side: NavigationSide?, size: CGSize = CGSize(width: 40, height: 40), enabled: Bool = true) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.frame = CGRect(origin: CGPoint.zero, size: size)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.isUserInteractionEnabled = enabled
        
        if let navSide = side {
            switch navSide {
            case .left:
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
                break
            case .right:
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
                break
            case .center:
                navigationItem.titleView = button
                break
            }
        }
        
        return button
    }
    
    func addNavBarButtonWith(_ title: String, color: UIColor, action: Selector, side: NavigationSide?, size: CGSize = CGSize(width: 25, height: 25), enabled: Bool = true) -> UIButton {
        let button = UIButton(type: .custom)
        button.setAttributedTitle( NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: color] ), for: UIControlState())
        button.setAttributedTitle( NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: color.withAlphaComponent(0.2)] ), for: .disabled)
        button.frame = CGRect(origin: CGPoint.zero, size: size)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.isUserInteractionEnabled = enabled
        
        if let navSide = side {
            switch navSide {
            case .left:
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
                break
            case .right:
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
                break
            case .center:
                navigationItem.titleView = button
                break
            }
        }
        
        return button
    }
    
    func addBackButton() {
        _ = addNavBarButtonWith("back", action: #selector(pop), side: .left)
    }
    
    func addLogo(_ isWhite: Bool = true){
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "logo"), for: UIControlState())
        button.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        button.isUserInteractionEnabled = false
        navigationItem.titleView = button
    }
    
    
    //MARK: Navigation actions
    func add(_ child: UIViewController, in container: UIView) {
        addChildViewController(child)
        container.addSubview(child.view)
        //child.view.addConstraintsToFitContainer(container)
        child.didMove(toParentViewController: self)
    }
    
    func remove(_ child: UIViewController) {
        child.willMove(toParentViewController: nil)
        child.view.removeFromSuperview()
        child.removeFromParentViewController()
    }

    func pop(_ animated: Bool = true) {
        _ = navigationController?.popViewController(animated: animated)
    }
    
    func popRoot(_ animated: Bool = true) {
        _ = navigationController?.popToRootViewController(animated: animated)
    }
    
    
    //MARK: Alerts
    func showAlert(with title: String?, message: String?, actions: [UIAlertAction]?, and defaultTitle: String? = "Ok") {
        let defaultAction = UIAlertAction(title: defaultTitle, style: .default, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(defaultAction)
        actions?.forEach({ alertController.addAction($0) })
        present(alertController, animated: true, completion: nil)
    }
    

    
    
}

