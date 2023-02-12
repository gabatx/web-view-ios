//
//  LinaresViewController.swift
//  ProyectoSideMenuMapasJC
//
//  Created by Escuela de Tecnologias Aplicadas on 23/1/23.
//

import UIKit
import MapKit

@available(iOS 14.0, *)
class LinaresViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var menuLeftButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!

    private var mapViewConfiguration: MapViewConfiguration?
    private var linaresMapViewDelegate: MapViewDelegate?

    // MARK: - Ciclo de vida

    override func loadView() {
        super.loadView()
        // Instanciamos el mapView y su delegado
        mapViewConfiguration = MapViewConfiguration()
        mapViewConfiguration?.mapView = mapView
        mapViewConfiguration?.viewController = self
        
        linaresMapViewDelegate = MapViewDelegate()
        mapView.delegate = linaresMapViewDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Gestos y menús
        configureMenuGesture()
        disableMenuRight()
        configureMainMenu(menuLeftButton: menuLeftButton)

        // Configuración del mapa
        configureMapView()
    }

    // MARK: - Funciones privadas
    fileprivate func configureMapView(){

        mapViewConfiguration?.centreMap(
            coords: CLLocation(latitude: 38.09290518543718, longitude: -3.6349602733445194),
            regionRadiusinMeter: 1000.0
        )

        mapViewConfiguration?.addMarkerToMap(
            coords: CLLocation(latitude: 38.09290518543718, longitude: -3.6349602733445194).coordinate,
            title: "El Pósito",
            locationName: "Calle Iglesia, 5, 23700 Linares, Jaén",
            discipline: "Centro de eventos"
        )

        mapViewConfiguration?.addMarkerToMap(
            coords: CLLocation(latitude: 38.09483190834397, longitude: -3.6312538).coordinate,
            title: "Estech",
            locationName: "Calle de la paz",
            discipline: "Formación Profesional",
            icon: "estech-logo",
            url: "https://www.escuelaestech.es"
        )
    }
}


