//
//  OpenUrlDelegate.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 27/1/23.
//

import Foundation

protocol BrowserDelegateProtocol: NSObjectProtocol {
    func sendUrlToWebView(url: URL)
    func receiverTitleUrlWebView() -> MarkerWeb
}
