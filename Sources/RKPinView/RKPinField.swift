//
//  File.swift
//  
//
//  Created by Rakibur Khan on 21/7/22.
//

import Foundation
import UIKit

class RKPinField: UITextField {
    var deleteButtonAction: RKPinViewDeleteButtonAction = .deleteCurrentAndMoveToPrevious
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
            action == #selector(UIResponderStandardEditActions.select(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) ||
            action == #selector(UIResponderStandardEditActions.delete(_:)) {
            
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func deleteBackward() {
        
        let isBackSpace = { () -> Bool in
            let char = self.text!.cString(using: String.Encoding.utf8)!
            return strcmp(char, "\\b") == -92
        }
        
        switch deleteButtonAction {
            case .deleteCurrentAndMoveToPrevious:
                // Move cursor from the beginning (set in shouldChangeCharIn:) to the end for deleting
                selectedTextRange = textRange(from: endOfDocument, to: beginningOfDocument)
                super.deleteBackward()
                
                if isBackSpace(), let nextResponder = self.superview?.superview?.superview?.superview?.viewWithTag(self.tag - 1) as UIResponder? {
                    nextResponder.becomeFirstResponder()
                }
            case .deleteCurrent:
                if !(text?.isEmpty ?? true) {
                    super.deleteBackward()
                } else {
                    // Move cursor from the beginning (set in shouldChangeCharIn:) to the end for deleting
                    selectedTextRange = textRange(from: endOfDocument, to: beginningOfDocument)
                    
                    if isBackSpace(), let nextResponder = self.superview?.superview?.superview?.superview?.viewWithTag(self.tag - 1) as UIResponder? {
                        nextResponder.becomeFirstResponder()
                    }
                }
            case .moveToPreviousAndDelete:
                if let nextResponder = self.superview?.superview?.superview?.superview?.viewWithTag(self.tag - 1) as UIResponder? {
                    nextResponder.becomeFirstResponder()
                }
        }
    }
}
