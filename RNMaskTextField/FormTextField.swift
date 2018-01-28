//
//  FormTextField.swift
//  RNMaskTextField
//
//  Created by Romilson Nunes on 26/01/18.
//  Copyright © 2018 Romilson Nunes. All rights reserved.
//

import UIKit


@objc open class FormTextField: MaskTextField {
    
    private let accessoryLabel: UILabel = UILabel(frame: CGRect.zero)

    /// Draw Text with edge insets. Default is .zero.
    public var textEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            self.configureAccessoryLabelConstraints()
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable open var accessoryFont: UIFont? {
        set {
            self.accessoryLabel.font = newValue
        }
        get {
            return self.accessoryLabel.font
        }
    }
    
    /// Default is .red.
    @IBInspectable open var accessoryTextColor: UIColor {
        set {
            self.accessoryLabel.textColor = newValue
        }
        get {
            return self.accessoryLabel.textColor
        }
    }
    
    /// Shake AccessoryLabel when Showing text
    @IBInspectable open var shakeAccessoryLabel : Bool = true
 
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        self.addSubview(self.accessoryLabel)
        self.configureAccessoryLabelConstraints()
        
        self.accessoryLabel.textAlignment = .right
        self.accessoryLabel.font = self.font
        self.accessoryLabel.textColor = .red
        
        self.addTarget(self, action: #selector(self.textfieldEditingChanged), for: .editingChanged)
    }
    
    @objc func textfieldEditingChanged(){
       self.hideAccessoryLabel()
    }
    
    // MARK: - Configurations
    
    private func configureAccessoryLabelConstraints() {
        
        let defaultRect = super.textRect(forBounds: bounds)
        let paddingLeft = defaultRect.origin.x + self.textEdgeInsets.left
        let paddingRight = (bounds.width - (defaultRect.origin.x + defaultRect.size.width)) + self.textEdgeInsets.right
        
        self.accessoryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=\(paddingLeft))-[subview(>=0)]-(==\(paddingRight))-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": self.accessoryLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[subview]-|", options: NSLayoutFormatOptions(), metrics:nil, views:["subview": self.accessoryLabel]))
    }
    
    private func renderAccessoryLabel(animated: Bool) {
        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: { finished in
            if self.shakeAccessoryLabel {
                self.accessoryLabel.shake()
            }
        })
    }
    
    
    // MARK:- Show Accessory Label
    
    public func showAccessoryLabel(withText text: String, animated: Bool = false) {
        self.accessoryLabel.text = text
        self.renderAccessoryLabel(animated: animated)
    }
    
    public func showAccessoryLabel(withText attributedText: NSAttributedString, animated: Bool = false) {
        self.accessoryLabel.attributedText = attributedText
        self.renderAccessoryLabel(animated: animated)
    }
    
    public func hideAccessoryLabel(animated: Bool = true) {
        self.accessoryLabel.text = nil
        self.accessoryLabel.attributedText = nil

        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }

    
    // MARK: - Overrides
    
    // Placeholder position
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let defaultRect = super.textRect(forBounds: bounds)
        var insets = self.textEdgeInsets
        insets.right += self.accessoryLabel.frame.width + defaultRect.origin.x
        return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, insets))
    }
    
    // Text position
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let defaultRect = super.editingRect(forBounds: bounds)
        var insets = self.textEdgeInsets
        insets.right += self.accessoryLabel.frame.width + defaultRect.origin.x
        return super.editingRect(forBounds: UIEdgeInsetsInsetRect(bounds, insets))
    }

}



// MARK:- Shake
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -10.0, 10.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}


