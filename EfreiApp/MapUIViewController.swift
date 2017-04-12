//
//  MapUIViewController.swift
//  EfreiApp
//
//  Created by Paul Bénéteau on 01/04/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import SwiftLocation
import DynamicButton

class MapUIViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var minifyButton: DynamicButton!
    @IBOutlet weak var closeButton: DynamicButton!
        
    var containerViewIsVisible = true
    
    var tasksList = [asksArround]()
    var filteredTasksList = [asksArround]()
    
    var ref = FIRDatabase.database().reference()
    var refHande: UInt!
    
    var userLocation: CLLocation = CLLocation(latitude: 48.77519569, longitude: 2.27794667)
    var countryCode = "FR"
    var state = "Île-de-France"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.mapView.delegate = self
        
        minifyButton.setStyle(.caretDown, animated: false)
        minifyButton.strokeColor = UIColor.white
        closeButton.setStyle(.close, animated: false)
        configureMap()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveData()
    }
    
    func retrieveData() {
        
        for i in 0...(tasksList.count - 1) {
            let task = tasksList[i]
            addAnnotations(coord: task.location)
        }
    }
    
    func configureMap() {
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    
    @IBAction func minifyContainerViewButton(_ sender: Any) {
        
        if containerViewIsVisible == true {
            

            UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
                self.barView.frame.origin.y += self.containerView.frame.height
                self.containerView.frame.origin.y += self.containerView.frame.height
            })
            minifyButton.setStyle(.caretUp, animated: true)
            containerViewIsVisible = false
        } else {
            

            UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
                self.barView.frame.origin.y -= self.containerView.frame.height
                self.containerView.frame.origin.y -= self.containerView.frame.height
            })
            minifyButton.setStyle(.caretDown, animated: true)
            containerViewIsVisible = true
        }
    }
    
    @IBAction func closeViewButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func locationButton(_ sender: Any) {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func addAnnotations(coord: CLLocation) {

        let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude,
                                                  longitude: coord.coordinate.longitude);
        let annotation = MKPointAnnotation();
        annotation.coordinate = CLLCoordType;
        mapView.addAnnotation(annotation);
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.image = UIImage(named:"location")
            anView?.canShowCallout = true
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView?.annotation = annotation
        }
        
        return anView
    }
    
    
}
