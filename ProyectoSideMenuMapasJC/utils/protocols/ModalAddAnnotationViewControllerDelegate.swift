//
//  ModalAddAnnotationViewControllerDelegate.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 29/1/23.
//

import Foundation
import CoreLocation

protocol modalAddAnnotationViewControllerDelegate: NSObjectProtocol{
    func addMarkerToMap(coords: CLLocationCoordinate2D, title: String, locationName: String, discipline: String, icon: String?, url: String?)
}
