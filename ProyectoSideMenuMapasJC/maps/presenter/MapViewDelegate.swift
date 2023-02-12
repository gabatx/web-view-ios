//
//  LinaresMapViewDelegate.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 28/1/23.
//

import Foundation
import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate {

    // La función sirve para personalizar la vista de una anotación (marcador o chincheta).
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Si la anotación es el usuario, no la modificamos
        guard let annotation = annotation as? MarkerMap else { return nil }
        // Reutilizamos la vista de anotación
        var view: MKMarkerAnnotationView
        let identifier = "marker"
        // Comprobamos si existe la vista, si no existe la creamos.
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier) // MKMarkerAnnotationView: Representa un marcador en el mapa.
            view.canShowCallout = true // canShowCallout: Si es true, muestra un cuadro de información cuando se selecciona la anotación.
            view.calloutOffset = CGPoint(x: -5, y: 5) // calloutOffset: Desplazamiento del cuadro de información.
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) // rightCalloutAccessoryView: Vista de acceso a la derecha del cuadro de información.
            if let icon = annotation.icon {
                view.glyphImage = UIImage(named: icon)
            }
            // Cambiar el aspecto del marcador de "El Pósito": color amarillo.
            if (annotation.title == "El Pósito") {
                view.markerTintColor = .yellow
            }
        }
        return view
    }

    // Se activa cuando el usuario pulsa sobre los UIControls izquierdo y derecho del accesorio callout.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        let location = view.annotation as! MarkerMap // Recuperamos la anotación

        // Si tiene una url se abre la web.
        if let url = location.url {
            UIApplication.shared.open(URL(string: url)!)
        } else {
            // Opciones de lanzamiento.
            let launchOptions = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue,
                MKLaunchOptionsShowsTrafficKey: true,
            ] as [String : Any]
            // LLamamos a la función mapItem() que creamos en el modelo MarkerMap que devolvía información del market
            location.mapItem().openInMaps(launchOptions: launchOptions) // Abrimos el mapa en al app de mapas con las opciones de lanzamiento.
        }
    }
}
