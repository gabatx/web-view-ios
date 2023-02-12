//
//  MapConfiguration.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 28/1/23.
//

import Foundation
import MapKit

@available(iOS 14.0, *)
class MapViewConfiguration: NSObject, modalAddAnnotationViewControllerDelegate {

    var mapView: MKMapView?
    var viewController: UIViewController?
    var locationManagerDelegate: LocationManagerDelegate?

    func centreMap(coords: CLLocation, regionRadiusinMeter: CLLocationDistance){
        let coordinateRegion = MKCoordinateRegion(center: coords.coordinate, latitudinalMeters: regionRadiusinMeter, longitudinalMeters: regionRadiusinMeter)
        mapView?.setRegion(coordinateRegion, animated: true)
    }

    func addMarkerToMap(coords: CLLocationCoordinate2D, title: String, locationName: String, discipline: String, icon: String? = nil, url: String? = nil){
        let marker = MarkerMap(coordinate: coords, title: title, locationName: locationName, discipline: discipline, icon: icon, url: url)
        mapView?.addAnnotation(marker)
    }

    func centreAllAnnotationsOntheMap() {
        let annotations = mapView?.annotations
        mapView?.showAnnotations(annotations!, animated: true)
    }

    func refreshMap(){
        mapView?.setNeedsDisplay()
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state != .began {
            return
        }
        // Obtiene las coordenadas del punto donde se realizó la pulsación larga
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView?.convert(touchPoint, toCoordinateFrom: mapView)

        // Crea una nueva anotación en esas coordenadas
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        annotation.title = "Nueva chincheta"
        // Añade la anotación al mapa
        mapView?.addAnnotation(annotation)

        // Abrimos el modal modalAddAnnotationViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modalAddAnnotationViewController = storyboard.instantiateViewController(withIdentifier: "ModalAddAnnotationViewController") as! ModalAddAnnotationViewController
        modalAddAnnotationViewController.delegate = self
        modalAddAnnotationViewController.annotationInProgress = annotation
        modalAddAnnotationViewController.mapView = mapView

        let distance = modalAddAnnotationViewController.calculateDistanceToAnnotation(location: (locationManagerDelegate?.locationManager.location)!)
        modalAddAnnotationViewController.containerDistanceToAnnotationLabel = "\(String(format: "%.2f", distance/1000))"

        viewController?.present(modalAddAnnotationViewController, animated: true, completion: nil)
    }
}
