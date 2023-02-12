//
//  ModalAddAnnotationViewController.swift
//  ProyectoSideMenuMapasJC
//
//  Created by gabatx on 29/1/23.
//

import UIKit
import MapKit


@available(iOS 14.0, *)
class ModalAddAnnotationViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outles
    @IBOutlet weak var tittleAnnotationsTextField: UITextField!{
        didSet {
            tittleAnnotationsTextField.tintColor = UIColor.secondarySystemBackground
            tittleAnnotationsTextField.setIcon(UIImage(imageLiteralResourceName: "pin"))
           }
    }

    @IBOutlet weak var directionAnnotationsTextField: UITextField!{
        didSet {
            directionAnnotationsTextField.tintColor = UIColor.secondarySystemBackground
            directionAnnotationsTextField.setIcon(UIImage(imageLiteralResourceName: "directions"))
           }
    }

    @IBOutlet weak var disciplineAnnotationsTextField: UITextField!{
        didSet {
            disciplineAnnotationsTextField.tintColor = UIColor.secondarySystemBackground
            disciplineAnnotationsTextField.setIcon(UIImage(imageLiteralResourceName: "folder"))
           }
    }

    @IBOutlet weak var urlAnnotationsTextField: UITextField!{
        didSet {
            urlAnnotationsTextField.tintColor = UIColor.secondarySystemBackground
            urlAnnotationsTextField.setIcon(UIImage(imageLiteralResourceName: "link"))
           }
    }

    @IBOutlet weak var viewDetails: UIView! {
        didSet {
            viewDetails.layer.cornerRadius = 5
            viewDetails.layer.masksToBounds = true // Recomendable para evitar que se vea distorsionado el contenido dentro de la vista
        }
    }

    @IBOutlet weak var distanceToAnnotationLabel: UILabel!
    @IBOutlet weak var coordinatesDetailLabel: UILabel!
    @IBOutlet weak var nameAnnotationTextField: UITextField!
    @IBOutlet weak var directionAnnotationTextField: UITextField!
    @IBOutlet weak var disciplineAnnotationTextField: UITextField!
    @IBOutlet weak var linkAnnotationTextField: UITextField!

    // MARK: - Propiedades públicas:
    weak var delegate: modalAddAnnotationViewControllerDelegate?
    var textFieldDelegate: TextFielDelegate?
    var mapView: MKMapView!

    var containerDistanceToAnnotationLabel = ""

    // MARK: - Propiedades privadas:
    var annotationInProgress: MKAnnotation!
    var mapViewConfiguration: MapViewConfiguration!

    // MARK: - Ciclo de vida:
    override func loadView() {
        super.loadView()
        // Asigno el delegado
        textFieldDelegate = TextFielDelegate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewConfiguration = MapViewConfiguration()
        mapViewConfiguration.mapView = mapView
        presentModalTurismoBottom()
        hiddenKeyboard()
        assignTagAndDelegateToAllTextFields(view: view, textFieldDelegate: textFieldDelegate!)
        insertInfoInDetail(annotation: annotationInProgress)
    }

    override func viewWillAppear(_ animated: Bool) {
        distanceToAnnotationLabel.text = containerDistanceToAnnotationLabel
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if someEmptyTextField(){
            mapView.removeAnnotation(annotationInProgress)
            mapView.setNeedsDisplay()
            self.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Funciones privadas
    fileprivate func insertInfoInDetail(annotation: MKAnnotation){
        let infoCoordenates = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
        coordinatesDetailLabel.text = infoCoordenates
    }

    fileprivate func someEmptyTextField() -> Bool{
        nameAnnotationTextField.text!.isEmpty ||
        directionAnnotationTextField.text!.isEmpty ||
        disciplineAnnotationTextField.text!.isEmpty
    }

    fileprivate func validateTextFields() {

        if someEmptyTextField() {
            warnDataWillBeDeleted()
        } else {
            mapView.removeAnnotation(annotationInProgress)
            mapViewConfiguration.addMarkerToMap(
                coords: annotationInProgress.coordinate,
                title: nameAnnotationTextField.text!,
                locationName: directionAnnotationTextField.text!,
                discipline: disciplineAnnotationTextField.text!,
                url: urlAnnotationsTextField.text!.isEmpty ? nil : urlAnnotationsTextField.text!
            )
            self.dismiss(animated: true, completion: nil) // Cierra la vista
        }
    }

    func calculateDistanceToAnnotation(location: CLLocation) -> CLLocationDistance {
        let distance = location.distance(from: CLLocation(latitude: annotationInProgress.coordinate.latitude, longitude: annotationInProgress.coordinate.longitude))
        return distance
    }

    // MARK: - Alerts
    func warnDataWillBeDeleted(){
        let alert = UIAlertController(title: "Campos incompletos", message: "Si sale se eliminará la chincheta", preferredStyle: .alert)
        // Acciones:
        let accionAceptar = UIAlertAction(title: "Salir", style: .default, handler: {_ in
            self.mapView.removeAnnotation(self.annotationInProgress)
            self.mapView.setNeedsDisplay()
            self.dismiss(animated: true, completion: nil)
        })
        let accionCerrar = UIAlertAction(title: "Configurar", style: .cancel, handler: nil)

        alert.addAction(accionAceptar)
        alert.addAction(accionCerrar)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - @IBAction
    @IBAction func createAnnotationButton(_ sender: Any) {
        validateTextFields()
    }

}
