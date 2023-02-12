//
//  MenuRightViewController.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 26/1/23.
//

import UIKit

class BrowserMenuRightViewController: UIViewController {

    // MARK: - Delegates
    weak var delegate: BrowserDelegateProtocol?

    @IBOutlet weak var tableViewMarkers: UITableView!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var addMarkerButton: UIButton!

    var markers: [MarkerWeb] = []

    override func loadView() {
        super.loadView()
        // Desactivar botón de añadir marcador
        addMarkerButton.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewMarkers.delegate = self
        tableViewMarkers.dataSource = self
    }

    @IBAction func googleButtonAction(_ sender: Any) {
        delegate?.sendUrlToWebView(url: URL(string: "https://www.google.es")!)
        closeBrowserMenuRight()
    }

    @IBAction func appleButtonAction(_sender: UIButton){
        delegate?.sendUrlToWebView(url: URL(string: "https://www.apple.com")!)
        closeBrowserMenuRight()
    }

    @IBAction func youtubeButtonAction(_sender: UIButton){
        delegate?.sendUrlToWebView(url: URL(string: "https://www.youtube.es")!)
        closeBrowserMenuRight()
    }

    @IBAction func addMarkerButtonAction(_ sender: UIButton) {
        // Recogemos el título y la url del webView:
        guard let marker = delegate?.receiverTitleUrlWebView() else { return }

        if marker.title.isEmpty {
            alertShowMessage(title: "Página en blanco", message: "Debes cargar una url")
            return
        }

        // Si no existe el marcador lo añadimos a la lista de marcadores
        if (!markers.contains(where: { $0.url == marker.url })) {
            // Preguntamos al usuario si quiere añadir el marcador
            confirmAddMarker(marker: marker)
        } else {
            // Enviamos un alert para avisar al usuario de que ya existe el marcador
            alertShowMessage(title: "El marcador ya existe", message:  "Puedes buscarlo en la lista de marcadores")
        }
    }

    // MARK: - Alerts
    func confirmAddMarker(marker: MarkerWeb){
        let alert = UIAlertController(title: "¿Añadir marcador?", message: "Se añadirá a su lista de marcadores", preferredStyle: .alert)
        // Acciones:
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
            self.markers.append(marker)
            self.tableViewMarkers.reloadData()
        })
        let accionCerrar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(accionAceptar)
        alert.addAction(accionCerrar)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate y UITableViewDataSource
extension BrowserMenuRightViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        markers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMarker", for: indexPath) as! MarkerTableViewCell
        let marker = markers[indexPath.row]

        cell.markerTitle.text = marker.title
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let marker = markers[indexPath.row]
        delegate?.sendUrlToWebView(url: marker.url)
        closeBrowserMenuRight()
    }
}
