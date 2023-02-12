//
//  ExtensionUIViewController.swift
//  ProyectoSideMenuMapasJC
//
//  Created by Escuela de Tecnologias Aplicadas on 23/1/23.
//

import Foundation
import SWRevealViewController

extension UIViewController {
    func configureMenuGesture(){
        if revealViewController() != nil {
            // Habilitamos el gesto para abrir el menú
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
            view.addGestureRecognizer((self.revealViewController().tapGestureRecognizer()))
        }
    }

    func configureMainMenu(menuLeftButton: UIBarButtonItem){
        // Configuramos menú izquierdo
        if revealViewController() != nil {
            // Configuramos menú principal
            menuLeftButton.target = revealViewController()
            menuLeftButton.action = #selector(SWRevealViewController.revealToggle(_:))
            // Ejecuta el método
            revealViewController()?.rearViewRevealWidth = view.bounds.width / 2
        }
    }

    func configureBookMarkMenu(menuRightButton: UIBarButtonItem, viewController: UIViewController) {
        // Asignamos la instancia al revealViewController para que sepa cual es la instancia que tiene que mostrar.
        revealViewController()?.rightViewController = viewController
        // Configuramos menú de favoritos
        revealViewController()?.rightViewRevealOverdraw = 0 // Permite que la vista del menú lateral derecho se ajuste a la vista
        revealViewController()?.rightViewRevealWidth = 260
        menuRightButton.target = revealViewController()
        menuRightButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
    }

    func closeBrowserMenuRight() {
        revealViewController().rightRevealToggle(nil)
    }

    func disableMenuRight() {
        revealViewController().rightViewController = nil
    }

    func presentModalBottom() {
        if #available(iOS 16.0, *) {
            self.sheetPresentationController?.detents = [.custom(resolver: { [weak self] context in
                guard let self else {
                    return nil
                }
                return self.view.bounds.height / 8 - self.view.safeAreaInsets.bottom
            })]
        }
        else if #available(iOS 15.0, *) {
            // Presentamos la actividad a mitad de pantalla
            if let presentation = presentationController as? UISheetPresentationController {
                presentation.detents = [
                    .medium(),
                    .large(),
                ]
                presentation.prefersGrabberVisible = true
            }
        }
    }

    func presentModalTurismoBottom() {
        if #available(iOS 15.0, *) {
            // Presentamos la actividad a mitad de pantalla
            if let presentation = presentationController as? UISheetPresentationController {
                presentation.detents = [
                    .medium(),
                    .large(),
                ]
                presentation.prefersGrabberVisible = true
            }
        }
    }

    func hiddenKeyboard(){
        // Creamos una gesto con un método de sistema (UIView.endEditing) que oculta el teclado
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        // Añade el gesto a la vista. Cuando se toque la vista, se ejecutará el método (oculta teclado)
        view.addGestureRecognizer(tapGesture)
    }

    func assignTagAndDelegateToAllTextFields(view: UIView, textFieldDelegate: TextFielDelegate){
        view.textFieldsInView.enumerated().forEach{ index, textField in
            textField.tag = index
            textField.delegate = textFieldDelegate
        }
    }

    // MARK: - Alert
    func alertShowMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let accion = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alert.addAction(accion)
        present(alert, animated: true, completion: nil)
    }
}

