//
//  ExtensionUIView.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 29/1/23.
//

import Foundation
import UIKit

extension UIView {
    
    var textFieldsInView: [UITextField] {
        // Metemos en un array todos los textField que haya en la vista
        return subviews
            .filter({ $0 is UITextField })
            .reduce((subviews.compactMap({ $0 as? UITextField })), { sum, current in
                return sum + current.textFieldsInView
            })
    }
    // Selecciona el textField que está seleccionado
    var selectedTextField: UITextField? {
        // Si el textField está seleccionado, entonces lo devuelve
        return textFieldsInView.filter({ $0.isFirstResponder }).first
    }
}
