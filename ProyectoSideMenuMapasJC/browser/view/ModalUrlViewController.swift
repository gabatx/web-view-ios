//
//  ModalUrlViewController.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 24/1/23.
//

import UIKit


class ModalUrlViewController: UIViewController, UITextFieldDelegate {

    weak var delegate: BrowserDelegateProtocol?

    // MARK: - IBOutlets
    @IBOutlet weak var textFieldGoUrl: UITextField! {
        didSet {
            textFieldGoUrl.tintColor = UIColor.lightGray // Le indicamos el color del cursor y al icono de la izquierda
            textFieldGoUrl.setIcon(UIImage(imageLiteralResourceName: "icons8-search")) // Le pasamos la imagen que queremos que aparezca a la izquierda del campo de texto
           }
    }

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()

        presentModalBottom()
        textFieldGoUrl.delegate = self
    }
}

extension ModalUrlViewController {

    // Imprimir valor textField en consola cuando se pulsa el botón enter del teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        controllerActionWithTextInserted(textField: textField)
        self.dismiss(animated: true, completion: nil)
        return true
    }

    private func controllerActionWithTextInserted(textField: UITextField) {

        let textInserted = textField.text!
        // Expresión regular que comprueba si la url es correcta
        let matchProtocol = validateProtocol(textInserted: textInserted)
        // Expresión regular que comprueba si ha escrito el dominio (.com, .es, etc)
        let matchDomain = validateDomain(textInserted: textInserted)

        // Switch valida:
        switch (textInserted.isEmpty, matchProtocol, matchDomain) {
        case (true, _, _):
            print("No has escrito nada")
        case (false, nil, nil): // No ha escrito el protocolo (https://) y ni el dominio (.com, .es, etc). Buscamos en Google
            let clearText = deleteProtocol(textInserted: textInserted)
            sendQueryGoogle(query: clearText)
        case (false, nil, _): // No ha escrito el protocolo (https://). Se lo añadimos
            let clearText = deleteProtocol(textInserted: textInserted)
            delegate?.sendUrlToWebView(url: URL(string: "https://\(clearText)")!)
        case (false, _, nil): // No ha escrito el dominio (.com, .es, etc)
            let clearText = deleteProtocol(textInserted: textInserted)
            sendQueryGoogle(query: clearText)
        case (false, _, _): // Ha escrito bien el protocolo y el dominio
            delegate?.sendUrlToWebView(url: URL(string: textInserted)!)
        }
    }

    private func validateDomain(textInserted: String) -> NSTextCheckingResult? {
        let regexDomain = try! NSRegularExpression(pattern: "\\.[a-z]{2,5}(:[0-9]{1,5})?(\\/.*)?$", options: .caseInsensitive)
        let rangeDomain = NSRange(location: 0, length: textInserted.utf16.count)
        let matchDomain = regexDomain.firstMatch(in: textInserted, options: [], range: rangeDomain)
        return matchDomain
    }

    private func validateProtocol(textInserted: String) -> NSTextCheckingResult? {
        let regexProtocol = try! NSRegularExpression(pattern: "^(https)://", options: .caseInsensitive)
        let rangeProtocol = NSRange(location: 0, length: textInserted.utf16.count)
        let matchProtocol = regexProtocol.firstMatch(in: textInserted, options: [], range: rangeProtocol)
        return matchProtocol
    }

    private func deleteProtocol(textInserted: String) -> String {

        let regexProtocol = try! NSRegularExpression(pattern: "^(https|http|ftp)://", options: .caseInsensitive)
        let rangeProtocol = NSRange(location: 0, length: textInserted.utf16.count)
        let matchProtocol = regexProtocol.firstMatch(in: textInserted, options: [], range: rangeProtocol)

        if let matchProtocol = matchProtocol {
            let range = matchProtocol.range
            let clearText = textInserted.replacingCharacters(in: Range(range, in: textInserted)!, with: "")
            return clearText
        }
        return textInserted
    }

    func sendQueryGoogle(query: String) {

        if query.contains(" ") {
            let queryGoogle = query.replacingOccurrences(of: " ", with: "+")
            let queryGoogleWithDomain = "https://www.google.com/search?q=\(queryGoogle)"
            delegate?.sendUrlToWebView(url: URL(string: queryGoogleWithDomain)!)
        } else {
            let queryGoogle = "https://www.google.com/search?q=\(query)"
            delegate?.sendUrlToWebView(url: URL(string: queryGoogle)!)
        }
    }
}


extension ModalUrlViewController {

    // Al pulsar dentro del textField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldGoUrl.selectAll(nil)

        if #available(iOS 16.0, *) {
            self.sheetPresentationController?.detents = [.custom(resolver: { [weak self] context in
                guard let self else { return nil }
                // Abre el modal hasta casi la mitad
                return self.view.bounds.height / 1.2 - self.view.safeAreaInsets.bottom
            })]
        }
    }
}


