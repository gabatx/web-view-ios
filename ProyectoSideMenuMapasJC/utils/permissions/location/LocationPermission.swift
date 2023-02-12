//
//  Location.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 29/1/23.
//

import Foundation
import CoreLocation
import UIKit

class LocationPermission {

    var locationManager: CLLocationManager
    // Booleano para saber si tenemos permisos o no
    var locationEnabled: Bool = false

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }

    @available(iOS 14.0, *)
    func location() {
        // Definimos la preción a 10 metros
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // Constante para pedir permisos de localización
        let status = CLLocationManager()
        // Estamos mirando el estado de los permisos
        switch status.authorizationStatus {
        case .notDetermined:
            status.requestAlwaysAuthorization() // Para pedirle algún estado concreto. Siempre que esté la aplicación instalada.
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation() // Tenemos permiso de ubicación, actualizar la localización
            locationEnabled = true // Si está autorizado, se puede acceder a la localización
        case .restricted, .denied:
            locationEnabled = false // Si está restringido o denegado, no se puede acceder a la localización
        @unknown default:
            print("No tenemos permisos de ubicación")
            locationManager.requestAlwaysAuthorization()
        }

    }
}
