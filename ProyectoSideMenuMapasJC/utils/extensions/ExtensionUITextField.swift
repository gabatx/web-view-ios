//
//  ExtensionUITextField.swift
//  ProyectoSideMenuMapasJC
//
//  Created by Escuela de Tecnologias Aplicadas on 25/1/23.
//

import Foundation
import UIKit

extension UITextField {

    // Esta función nos permite añadir una imagen a la izquierda del campo de texto
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20)) // Tamaño de la imagen
        iconView.image = image // Introducimos la imagen en la instancia creada de UIImageView
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30)) // Creamos un contenedor para la imagen (una vista)
        iconContainerView.addSubview(iconView) // Introducimos la imagen en el contenedor
        leftView = iconContainerView // La vista superpuesta que se muestra en el lado izquierdo (o inicial) del campo de texto es el contenedor
        leftViewMode = .always // Indicamos que siempre se muestre la vista superpuesta
    }
}
