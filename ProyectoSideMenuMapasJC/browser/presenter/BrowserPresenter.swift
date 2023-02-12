//
//  BrowserViewPresenter.swift
//  ProyectoSideMenuMapasJC
//
//  Created by Escuela de Tecnologias Aplicadas on 31/1/23.
//

import Foundation
import WebKit


class BrowserPresenter {
    weak var delegate: BrowserDelegateProtocol?
    var webView: WKWebView

    init(webView: WKWebView) {
        self.webView = webView
    }

    func backbutton(){
        webView.goBack()
    }

    func forwardButton(){
        webView.goForward()
    }

    // MARK: - Funciones privadas
    @objc func openInBrowser() {
        if let url = webView.url {
            UIApplication.shared.open(url)
        }
    }

    

}
