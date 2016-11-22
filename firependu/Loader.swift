//
//  EtamLoader
//  MultiColorLoader
//
//  Created by Pauline on 29/04/2016.
//  Copyright © 2016 Genesis. All rights reserved.
//

import UIKit

class Loader: UIView {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    let loader = MultiColorLoader()
    var loaderSize = CGSize.init(width: 100, height: 100)
    
    var roundTime: Double {
        get {
            return loader.roundTime
        }
        set (newRoundTime) {
            loader.roundTime = newRoundTime
        }
    }
    
    var lineWidth: CGFloat {
        get {
            return loader.lineWidth
        }
        set (newLineWidth) {
            loader.lineWidth = newLineWidth
        }
    }
    
    var colors: [UIColor] {
        get {
            return loader.colors
        }
        set (newColors) {
            loader.colors = newColors
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (subviews as NSArray).contains(loader) == false {
            loader.frame = CGRect.init(x: 0, y: 0, width: loaderSize.width, height: loaderSize.height)
            loader.center = self.center
            
            loader.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(loader)
            
            loader.addConstraint(NSLayoutConstraint(item: loader, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: loaderSize.height))
            loader.addConstraint(NSLayoutConstraint(item: loader, attribute: .width, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: loaderSize.width))
            
            self.addConstraint(NSLayoutConstraint(item: loader, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: loader, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            
        }
        loader.startAnimation()
    }
    
    class func show(_ colors: [UIColor], roundTime: Double, lineWidth: CGFloat, backGroundColor: UIColor?, view:UIView?) {
        
        guard let rv = view else {
            return
        }
        
        let customLoader = Loader(frame: rv.bounds)
        customLoader.alpha = 0
        customLoader.colors = colors
        customLoader.roundTime = roundTime
        customLoader.lineWidth = lineWidth
        if let unwrappedBackgroundColor = backGroundColor {
            customLoader.backgroundColor = unwrappedBackgroundColor
        } else {
            customLoader.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        }
        rv.addSubview(customLoader)
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            customLoader.alpha = 1
        })
    }
    
    
    class func show(inView view:UIView?) {
        show([UIColor.black, UIColor.white], roundTime: 1.0, lineWidth: 2.0, backGroundColor: nil, view: view)
    }
    
    class func hide(fromView view:UIView?) {
        guard let rv = view else {
            return
        }
        var customLoader: Loader?
        for view in rv.subviews {
            if let loader = view as? Loader {
                customLoader = loader
            }
        }
        
        if let loader = customLoader {
            UIView.animate(withDuration: 0.2,
                                       animations: { () -> Void in
                                        loader.alpha = 0
            }, completion: { (_) -> Void in
                loader.removeFromSuperview()
            }) 
        }
    }
    
    class func show() {
        show([UIColor.black, UIColor.white], roundTime: 1.0, lineWidth: 2.0, backGroundColor: nil, view: UIApplication.shared.keyWindow?.subviews.last)
    }
    
    class func hide() {
        guard let rv = UIApplication.shared.keyWindow?.subviews.last else {
            return
        }
        var customLoader: Loader?
        for view in rv.subviews {
            if let loader = view as? Loader {
                customLoader = loader
            }
        }
        
        if let loader = customLoader {
            UIView.animate(withDuration: 0.2,
                                       animations: { () -> Void in
                                        loader.alpha = 0
                }, completion: { (_) -> Void in
                    loader.removeFromSuperview()
                }) 
        }
    }
    
}
