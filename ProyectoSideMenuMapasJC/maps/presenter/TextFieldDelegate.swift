//
//  TextFieldDelegate.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 29/1/23.
//

import Foundation
import UIKit

class TextFielDelegate: NSObject, UITextFieldDelegate {
    
    // Pasar al siguiente TextField
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        // Si el tag del textField es 1, pasamos al siguiente textField
        let nextTag = textField.tag + 1
        // Si cumple con los requisitos, se pasa al siguiente textField. En el caso de que exista lo selecciona.
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
            // Si no, se oculta el teclado. Si no deja de ser first responder.
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
