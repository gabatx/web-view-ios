//
//  HomeViewController.swift
//  ProyectoSideMenuMapasJC
//
//  Created by Escuela de Tecnologias Aplicadas on 23/1/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var menuLeftButton: UIBarButtonItem!

    override func loadView() {
        super.loadView()
        disableMenuRight()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenuGesture()
        self.configureMainMenu(menuLeftButton: menuLeftButton)

        

    }
}
