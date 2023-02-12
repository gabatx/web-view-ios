//
//  MarkerMap.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 28/1/23.
//

import Foundation
import MapKit
import Contacts // Información adicional (necesario para CNPostalAddressStreetKey)

class MarkerMap: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let title: String?
    let locationName: String // Nombre de la ubicación
    let discipline: String
    let icon: String?
    let url: String?

    var subtitle: String? {
        return locationName
    }

    init(coordinate: CLLocationCoordinate2D, title: String?, locationName: String, discipline: String, icon: String? = nil, url: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.icon = icon
        self.url = url
        super.init()
    }

    func mapItem() -> MKMapItem {
        // Al tocar el botón del accesorio, abrir la aplicación Mapas
        let addressDictionary = [CNPostalAddressStreetKey: subtitle!] // Una colección de objetos que contiene información de contacto postal.
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary) // Un objeto que representa una ubicación geográfica en el mapa.
        let mapItem = MKMapItem(placemark: placemark) // Un objeto que representa un punto de interés en el mapa.
        mapItem.name = title
        return mapItem
    }
}
