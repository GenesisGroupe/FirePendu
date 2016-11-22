//
//  MultiColorLoader.swift
//  MultiColorLoader
//
//  Created by Pauline on 28/04/2016.
//  Copyright © 2016 Genesis. All rights reserved.
//

import UIKit
final public class MultiColorLoader: UIView {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    
    public var defaultColors = [UIColor.red, UIColor.green, UIColor.blue]
    
    public var colors: [UIColor] {
        get {
            return defaultColors
        }
        set (newColors) {
            if newColors.count > 0 {
                defaultColors = newColors
                updateAnimations()
            } else {
                print("MultiColorLoader : Please provide at least one color")
            }
        }
    }
    
    public var defaultLineWidth: CGFloat = 2.0
    public var lineWidth: CGFloat {
        get {
            return defaultLineWidth
        }
        set (newWidth) {
            defaultLineWidth = newWidth
            circleLayer.lineWidth = defaultLineWidth
        }
    }
    
    public var defaultRoundTime = 3.0
    public var roundTime: Double {
        get {
            return defaultRoundTime
        }
        set (newRoundTime) {
            defaultRoundTime = newRoundTime
            updateAnimations()
        }
    }
    
    public var circleLayer: CAShapeLayer = CAShapeLayer()
    public var strokeLineAnimation: CAAnimationGroup?
    public var rotationAnimation: CAAnimation?
    public var strokeColorAnimation: CAAnimation?
    public var headAnimation: CABasicAnimation?
    public var tailAnimation: CABasicAnimation?
    
    private(set) var animating: Bool = false
    
    public init(colors: [UIColor], roundTime: Double, lineWidth: Double, backgroundColor: UIColor? = UIColor.clear) {
        super.init(frame: CGRect.zero)
        initialSetup()
        self.colors = colors
        self.roundTime = roundTime
        self.lineWidth = CGFloat(lineWidth)
        self.backgroundColor = backgroundColor
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    //MARK: initial setup
    
    private func initialSetup() {
        layer.addSublayer(circleLayer)
        backgroundColor = UIColor.clear
        circleLayer.fillColor = nil
        circleLayer.lineWidth = lineWidth
        circleLayer.lineCap = kCALineCapRound
        updateAnimations()
    }
    
    //MARK: layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint.init(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        let radius = min(bounds.size.width, bounds.size.height / 2.0 - circleLayer.lineWidth / 2.0)
        let startAngle: CGFloat = 0.0
        let endAngle: CGFloat = 2 * CGFloat(M_PI)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        circleLayer.path = path.cgPath
        circleLayer.frame = bounds
    }
    
    //MARK: Animations
    
    public func startAnimation () {
        animating = true
        if let animation = strokeLineAnimation {
            circleLayer.add(animation, forKey: "strokeLineAnimation")
        }
        if let animation = rotationAnimation {
            circleLayer.add(animation, forKey: "rotationAnimation")
        }
        if let animation = strokeColorAnimation {
            circleLayer.add(animation, forKey: "strokeColorAnimation")
        }
    }
    
    public func stopAnimation () {
        animating = false
        circleLayer.removeAnimation(forKey: "strokeLineAnimation")
        circleLayer.removeAnimation(forKey: "rotationAnimation")
        circleLayer.removeAnimation(forKey: "strokeColorAnimation")
    }
    
    private func stopAnimationAfter (timeInterval: TimeInterval) {
        perform(#selector(stopAnimation), with: nil, afterDelay: timeInterval)
    }
    
    private func updateAnimations () {
        // STROKE HEAD
        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.beginTime = roundTime/3.0
        headAnimation.fromValue = 0
        headAnimation.toValue = 1
        headAnimation.duration = 2*roundTime/3.0
        headAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.headAnimation = headAnimation
        
        // STROKE TAIL
        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        tailAnimation.duration = 2*roundTime/3.0
        tailAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.tailAnimation = tailAnimation
        
        // STROKE LINE GROUP
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = roundTime
        animationGroup.repeatCount = Float.infinity
        if let headAnim = self.headAnimation, let tailAnim = self.tailAnimation {
            animationGroup.animations = [headAnim, tailAnim]
        }
        self.strokeLineAnimation = animationGroup
        
        // ROTATION
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2*M_PI
        rotationAnimation.duration = roundTime
        rotationAnimation.repeatCount = Float.infinity
        self.rotationAnimation = rotationAnimation
        
        //COLOR
        
        let strokeColorAnimation = CAKeyframeAnimation(keyPath: "strokeColor")
        strokeColorAnimation.values = prepareColorValues()
        strokeColorAnimation.keyTimes = prepareKeyTimes()
        strokeColorAnimation.calculationMode = kCAAnimationDiscrete
        strokeColorAnimation.duration = Double(colors.count) * roundTime
        strokeColorAnimation.repeatCount = Float.infinity
        self.strokeColorAnimation = strokeColorAnimation
    }
    
    private func prepareColorValues () -> [CGColor] {
        var cgColors = [CGColor]()
        for aColor in colors {
            cgColors.append(aColor.cgColor)
        }
        return cgColors
    }
    
    private func prepareKeyTimes () -> [NSNumber] {
        var keyTimes = [NSNumber]()
        for index in 0...colors.count + 1 {
            keyTimes.append(NSNumber(value: Float(index) * 1.0 / Float(colors.count)))
        }
        return keyTimes
    }
    
}
