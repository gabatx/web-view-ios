//
//  NavegarViewController.swift
//  ProyectoSideMenuMapasJC
//
//  Created by Escuela de Tecnologias Aplicadas on 23/1/23.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController, BrowserDelegateProtocol {

    @IBOutlet weak var menuLeftButton: UIBarButtonItem!
    @IBOutlet weak var menuRightButton: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!

    var presenter: BrowserPresenter?
    var browserMenuRightViewController: BrowserMenuRightViewController!

    override func loadView() {
        super.loadView()

        // Métodos que muestran el menú lateral
        configureMenuGesture()

        // Procedimiento:
        // - Creamos una instancia del menú derecho mediante el storyboard.
        // - Seguidamente se la pasamos al método configureBookMarkMenu para que cuando se ejecute el método le pueda
        //    asignar la instancia al revealViewController para que sepa cual es la instancia que tiene que mostrar.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        browserMenuRightViewController = (storyboard.instantiateViewController(withIdentifier: "MenuRightViewController") as! BrowserMenuRightViewController)
    }
    

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureMainMenu(menuLeftButton: menuLeftButton)
        self.configureBookMarkMenu(menuRightButton: menuRightButton, viewController: browserMenuRightViewController)

        // Instanciamos el presenter
        presenter = BrowserPresenter(webView: webView)

        // MARK: - Delegates
        // Asignamos el delegado a esta clase
        presenter?.delegate = self
        // Asignamos el delegate a la clase BrowserMenuRightViewController
        browserMenuRightViewController.delegate = self
        // Indicamos que esta clase controla el webView
        webView.navigationDelegate = self
        // Le asignamos gestos al webView para que pueda ir hacia atrás y hacia adelante.
        webView.allowsBackForwardNavigationGestures = true
        chargeUrlHomeWebView(url: "https://www.escuelaestech.es")

        // Añadimos el observer para el estimatedProgress. Desde aquí llamamos a la función que actualiza el progressView
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)


        // MARK: - Barra inferior
        // Botón de abrir en Safari
        let openInBrowserButton = UIBarButtonItem(image: UIImage(systemName: "safari"), style: .plain, target: presenter, action: #selector(presenter?.openInBrowser))

        // Color del botón
        openInBrowserButton.tintColor = .label
        let searchGoogle = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openModalShowWebByUrl))
        searchGoogle.tintColor = .label
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        refresh.tintColor = .label
        toolbarBottom(items: [openInBrowserButton, spacer, refresh, spacer, searchGoogle])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.additionalSafeAreaInsets.top = 10 // Le mete un poco de padding al navigator bar
    }

    override func viewWillDisappear(_ animated: Bool) {

        disableMenuRight() // AL irnos de la vista desactivo el menú derecho
    }

    // MARK: - Funciones delegadas de nuestros protocolos
    func receiverTitleUrlWebView() -> MarkerWeb {
        return MarkerWeb(title: webView.title ?? "Sin título", url: webView.url!)
    }

    func sendUrlToWebView(url: URL) {
        browserMenuRightViewController.addMarkerButton.isEnabled = false
        let request = URLRequest(url: url)
        webView.load(request)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Config buttons WebView
    @IBAction func backButton(_ sender: Any) {
        presenter?.backbutton()
    }

    @IBAction func forwardButton(_ sender: Any) {
        presenter?.forwardButton()
    }



    @objc fileprivate func openModalShowWebByUrl() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modalUrlViewController = storyboard.instantiateViewController(identifier: "ModalUrlViewController") as! ModalUrlViewController
        modalUrlViewController.delegate = self
        present(modalUrlViewController, animated: true, completion: nil)
    }

    fileprivate func toolbarBottom(items: [UIBarButtonItem]){
        // Añadimos dentro del toolbarItems los botones que hemos creado en la barra inferior del webView
        toolbarItems = items
        // Forzamos a que muestre la barra de navegación inferior
        navigationController?.isToolbarHidden = false
    }

    fileprivate func chargeUrlHomeWebView(url: String) {
        let url = URL(string: url)!
        let request = URLRequest(url: url) // Creamos la petición a la URL
        webView.load(request) // Cargamos la petición en el webView
    }

}
// MARK: - Extensiones
extension BrowserViewController {
    // Observa los campos. Esta función se ejecuta cuando se produce un cambio en el estimatedProgress.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Color del progressView
        progressView.progressTintColor = .systemGray
        // Si el keyPath es igual a la propiedad estimatedProgress
        if keyPath == "estimatedProgress" {
            // Actualizamos el valor de la barra de progreso
            progressView.progress = Float(webView.estimatedProgress)
        }
        // Ternario que oculta cuando el estimatedProgress llegue a 1.0 (true)
        progressView.isHidden = webView.estimatedProgress >= 1.0
    }
}

extension BrowserViewController: WKNavigationDelegate {
    // Se ejecuta en el momento que termine de cargar una web
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Mostramos el título
        title = webView.title
        // Habilitamos el botón de añadir marcador solo cuando se haya cargado el menú derecho
        if browserMenuRightViewController.view.isHidden == false {
            browserMenuRightViewController.addMarkerButton.isEnabled = true
        }
    }
}



extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 201)
    }
}
