//
//  LocationManagerDelegate.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 29/1/23.
//

import Foundation
import CoreLocation
import MapKit


@available(iOS 14.0, *)
class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {

    var locationManager: CLLocationManager
    var myLocation: CLLocation?
    var defaultLocation: CLLocation = CLLocation(latitude: 40.416775, longitude: -3.703790)
    var secureLocation: CLLocation {
        myLocation ?? defaultLocation
    }
    var mapViewConfiguration = MapViewConfiguration()

    // Booleano para saber si tenemos permisos o no
    var locationEnabled: Bool = false

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }

    // Actualizamos la localización una vez
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Si tenemos permisos de localización, actualizamos la localización
        if locationEnabled {
            myLocation = locations.last // La última la guardamos en la propiedad miLocation
            print("Current location: \(self.myLocation?.coordinate.latitude ?? 0), \(self.myLocation?.coordinate.longitude ?? 0)")
            // Desactivamos el seguimiento de la localización
            //locationManager.stopUpdatingLocation()
        }
    }

    // Función que me devuelve la localización con un @escaping
    func getLocation(completion: @escaping (CLLocation) -> Void) {
        // Si tenemos permisos de localización, actualizamos la localización
        if locationEnabled {
            completion(secureLocation)
        }
    }
   

    // Función de error que se activa cuando no se puede acceder a la localización
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }

    // Función que se activa cuando cambia el estado
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            locationEnabled = true
        default:
            print("El usuario ha rechazado los permisos de localización")
            self.locationEnabled = false
        }
    }
}
