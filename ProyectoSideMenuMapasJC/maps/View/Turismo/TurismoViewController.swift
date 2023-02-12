//
//  TurismoViewController.swift
//  ProyectoSideMenuMapasJC
//
//  Created by Escuela de Tecnologias Aplicadas on 23/1/23.
//

import UIKit
import MapKit

@available(iOS 14.0, *)
final class TurismoViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var menuLeftButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Propieades privadas
    private var locationManagerDelegate: LocationManagerDelegate!
    private var locationManager = CLLocationManager()
    private var locationPermission:LocationPermission!
    private var mapViewConfiguration: MapViewConfiguration!
    private var turismoMapViewDelegate = MapViewDelegate()
    private var deletedAnnotations: [MKAnnotation] = []
    private let catedralAnnotation: MarkerMap = {
        let annotation = MarkerMap(
            coordinate: CLLocation(latitude: 37.990157948329085, longitude: -3.4687586798997745).coordinate,
            title: "Catedral de la Natividad de Nuestra Señora de Baeza",
            locationName: "Plaza de Santa María, 23440 Baeza, Jaén",
            discipline: "Turismo"
            )
        return annotation
    }()

    // MARK: - Ciclo de vida
    override func loadView() {
        super.loadView()
        // Instanciamos el mapView y su delegado
        mapViewConfiguration = MapViewConfiguration()
        mapViewConfiguration.mapView = mapView
        mapViewConfiguration.viewController = self

        mapView.delegate = turismoMapViewDelegate

        locationManagerDelegate = LocationManagerDelegate(locationManager: locationManager)
        mapViewConfiguration.locationManagerDelegate = locationManagerDelegate
        locationManager.delegate = locationManagerDelegate

        locationManagerDelegate.mapViewConfiguration.mapView = mapView

        // Pedimos los persmisos
        locationPermission = LocationPermission(locationManager: locationManager)
        locationPermission.location()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Gestos y menús
        configureMenuGesture()
        disableMenuRight()
        configureMainMenu(menuLeftButton: menuLeftButton)

        // Configuración del mapa
        configureMapView()

        // Añade un reconocedor de gestos de pulsación larga al mapa. Activamos el método handleLongPress y le pasamos el gesto y la instancia de TurismoViewController
        let longPressGesture = UILongPressGestureRecognizer(target: mapViewConfiguration, action: #selector(mapViewConfiguration.handleLongPress(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPressGesture)
    }

    // MARK: - Métodos
    fileprivate func configureMapView(){
        
        mapViewConfiguration.addMarkerToMap(
            coords: CLLocation(latitude: 38.09290518543718, longitude: -3.6349602733445194).coordinate,
            title: "El Pósito",
            locationName: "Calle Iglesia, 5, 23700 Linares, Jaén",
            discipline: "Centro de eventos"
        )

        mapViewConfiguration.addMarkerToMap(
            coords: CLLocation(latitude: 38.09483190834397, longitude: -3.6312538).coordinate,
            title: "Estech, escuela de tecnologías aplicadas",
            locationName: "C. San Joaquín, 12, 23700 Linares, Jaén",
            discipline: "Formación Profesional",
            icon: "estech-logo",
            url: "https://www.escuelaestech.es"
        )
        // Añade la catedral al mapa
        mapViewConfiguration.mapView?.addAnnotation(catedralAnnotation)

        mapViewConfiguration.centreAllAnnotationsOntheMap()
    }

    fileprivate func showLinaresAnnotations(){
        let location = CLLocation(latitude: 38.09290518543718, longitude: -3.6349602733445194)
        let annotationsToDelete = mapView.annotations.filter { annotation in
            let annotationLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            let distance = location.distance(from: annotationLocation)
            return distance > 2000
        }
        deletedAnnotations = annotationsToDelete
        mapView.removeAnnotations(deletedAnnotations)
    }

    fileprivate func showAllAnnotations(){
        mapView.addAnnotations(deletedAnnotations)
    }

    // MARK: - IBAction
    @IBAction func switchToggleViewButton(_ sender: UISwitch) {

        if sender.isOn {
            showLinaresAnnotations()
            mapViewConfiguration.centreAllAnnotationsOntheMap()
        } else {
            showAllAnnotations()
            mapViewConfiguration.centreAllAnnotationsOntheMap()
        }
    }

    @IBAction func addAnnotesionLocationUser(_ sender: Any) {
        mapViewConfiguration.addMarkerToMap(
            coords: locationManagerDelegate.locationManager.location?.coordinate ?? CLLocationCoordinate2D(),
            title: "Mi ubicación",
            locationName: "Mi ubicación",
            discipline: "Mi ubicación"
        )
    }
}
