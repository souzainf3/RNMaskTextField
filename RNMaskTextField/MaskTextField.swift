//
//  MaskTextField.swift
//  RNMaskTextField
//
//  Created by Romilson Nunes on 25/01/18.
//  Copyright © 2018 Romilson Nunes. All rights reserved.
//

import UIKit

extension String {
    
    func character(atIndex index: Int) -> String {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        let char = self[charIndex]
        return String(char)
    }
}

@IBDesignable
@objc open class MaskTextField: UITextField {

    @IBInspectable public var textMask: String = ""
    @IBInspectable public var defaultCharMask = "#"
    
    public var raw: String? {
        set {
            self.text = raw
        }
        get {
            return extractRawValue()
        }
    }

    public func shouldChangeCharacters(in range: NSRange, replacementString string: String) -> Bool {
        
        if self.textMask.count == 0 {
            return true
        }
        
        guard var currentTextDigited = (self.text as NSString?)?.replacingCharacters(in: range, with: string)  else {
            return true
        }
        
        // Character deleted
        if string.count == 0 {

            while currentTextDigited.count > 0, textMask.character(atIndex: currentTextDigited.count - 1) != self.defaultCharMask {
                currentTextDigited = String(currentTextDigited.prefix(currentTextDigited.count - 1))
            }
            text = currentTextDigited
            return false
        }
        
        if currentTextDigited.count > self.textMask.count {
            return false
        }
        
        var returnText = ""

        var last: Int = 0
        var needAppend = false
        
        for (index, currentChar) in currentTextDigited.enumerated() {
            
            let currentCharMask = self.textMask.character(atIndex: index)
            
            let isNumber = textMask.character(atIndex: index) == self.defaultCharMask

            if isNumber && currentCharMask == defaultCharMask {
                returnText.append(currentChar)
            } else {

                if currentCharMask == defaultCharMask {
                    break
                }
                
                if isNumber {
                    needAppend = true
                }
                returnText += currentCharMask
            }
            
            last = index
        }
        
        for index in (last + 1)..<textMask.count {
            let currentCharMask = textMask.character(atIndex: index)
            if currentCharMask != defaultCharMask {
                returnText += currentCharMask
            }
            if currentCharMask == defaultCharMask {
                break
            }
        }
        
        if needAppend {
            returnText += string
        }
        
        self.text = returnText
        
        return false
    }
    
    
    // MARK: - Helpers
    
    fileprivate func extractRawValue() -> String? {
        
        guard let text = self.text else {
            return nil
        }
        
        if (self.textMask.count == 0) {
            return self.text
        }
        
        var returnText = ""
        if (self.textMask.count > self.textMask.count) {
            return self.text
        }
        
        for (index, currentChar) in text.enumerated() {
            
            let currentCharMask = textMask.character(atIndex: index)
            
            if String(currentCharMask) == defaultCharMask {
                returnText.append(currentChar)
            }
        }
        
        return returnText
    }

}


