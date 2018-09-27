//
//  ActivitySpinner.swift
//
//  A delightful progress spinner that I created out of dislike
//  for the Apple old style and out of date UIActivityIndicator
//
//  https://github.com/markawil/ActivitySpinner

import UIKit

@IBDesignable

class ActivitySpinnerView : UIView {
    
    let circleLayer = CAShapeLayer()
    let circlePathLayer = CAShapeLayer()
    
    @IBInspectable var lineWidth: CGFloat = 8 {
        didSet {
            circleLayer.lineWidth = lineWidth
            setNeedsLayout()
        }
    }
    
    @IBInspectable var animating: Bool = true {
        didSet {
            updateAnimation()
        }
    }
    
    let rotationAnimation : CAAnimation = {
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = 1
        rotation.repeatCount = MAXFLOAT
        
        return rotation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        
        self.layer.masksToBounds = false
        circleLayer.lineWidth = self.lineWidth
        circlePathLayer.lineWidth = self.lineWidth
        circleLayer.fillColor = nil
        circlePathLayer.fillColor = nil
        circleLayer.strokeColor = UIColor.red.cgColor
        circlePathLayer.strokeColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor // silver
        layer.addSublayer(circlePathLayer)
        layer.addSublayer(circleLayer)
        self.layer.cornerRadius = 10.0
        updateAnimation()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupCirclePathLayer()
        setupCircleLayer()
    }
    
    func setupCircleLayer() {
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) / 2 - circleLayer.lineWidth) - 20
        
        let startAngle = CGFloat(-Double.pi/4)
        let endAngle = CGFloat(Double.pi/2)
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        circleLayer.position = center
        circleLayer.path = path.cgPath
    }
    
    func setupCirclePathLayer() {
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) / 2 - circleLayer.lineWidth) - 20
        
        let startAngle = CGFloat(-Double.pi*2)
        let endAngle = startAngle + CGFloat(Double.pi*2)
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        circlePathLayer.position = center
        circlePathLayer.path = path.cgPath
    }
    
    func updateAnimation() {
        if animating {
            circleLayer.add(rotationAnimation, forKey: "rotation")
        }
        else {
            circleLayer.removeAnimation(forKey: "rotation")
        }
    }
    
}
