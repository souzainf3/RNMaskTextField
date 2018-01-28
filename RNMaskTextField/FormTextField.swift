//
//  FormTextField.swift
//  GloboPlayTV
//
//  Created by Romilson Nunes on 26/01/18.
//  Copyright © 2018 GLOBO COM. E PART. S/A. All rights reserved.
//

import UIKit


class FormTextField: MaskTextField {

    var textEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    enum FieldState {
        case editing
        case success
        case error(message: String)
    }
    
    var fieldState: FieldState = .editing {
        didSet {
            self.configureState()
        }
    }
    
    
    fileprivate let accessoryLabel: UILabel = UILabel(frame: CGRect.zero)
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        self.addSubview(self.accessoryLabel)
        self.configureAccessoryLabelConstraints()
        
        self.accessoryLabel.textAlignment = .right
        self.accessoryLabel.textColor = .red
        self.accessoryLabel.attributedText = IconManager.string(from: .checkMark, size: 31 , color: .green)
    }
    
    
    // MARK: - Configurations
    
    func configureState() {
        self.accessoryLabel.attributedText = nil
        self.accessoryLabel.text = nil

        switch self.fieldState {
        case .editing:
            break
        case .success:
            self.accessoryLabel.attributedText = IconManager.string(from: .checkMark, size: 31 , color: .green)
        case .error(let message):
            self.accessoryLabel.text = message
        }
    }
    
    private func configureAccessoryLabelConstraints() {
        self.accessoryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=10)-[subview(>=0)]-(==20)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": self.accessoryLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[subview]-|", options: NSLayoutFormatOptions(), metrics:nil, views:["subview": self.accessoryLabel]))
    }
    
    
    // MARK: - Overrides
    
    // Placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, self.textEdgeInsets))
    }
    
    // Text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: UIEdgeInsetsInsetRect(bounds, self.textEdgeInsets))
    }

}
