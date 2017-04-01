//
//  AsksArroundTableViewCell.swift
//
//
//  Created by Paul Bénéteau on 22/03/2017.
//
//

import UIKit
import MapKit
import Cosmos

class AsksArroundTableViewCell: FoldingCell, MKMapViewDelegate {
    
    
    @IBOutlet weak var closeNumberLabel: UILabel!
    @IBOutlet weak var openNumberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceLabel2: UILabel!
    @IBOutlet weak var priceLabel3: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryLabel2: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var hourLabel2: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var ratingStarsView: CosmosView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var driveTimeLabel: UILabel!
    @IBOutlet weak var requestDeadlineLabel: UILabel!
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var profileContainerView: RotatedView!
    @IBOutlet weak var dateContainerView: RotatedView!
    @IBOutlet weak var buttonContainerView: RotatedView!
    
    @IBOutlet weak var infosBarView: UIView!
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var moreInfo: UIButton!
    
    var mapHeight: CGFloat!
    var profileContainerY : CGFloat!
        
    
    var userLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    var taskLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    var taskDate: Date!
    
    var mapSubView = UIView(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
    
    var number: Int = 0 {
        didSet {
            closeNumberLabel.text = String(number)
            openNumberLabel.text = String(number)
        }
    }
    
    override func awakeFromNib() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true

        
        configureCells()
        
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    func configureCells() {
        
        // create a view on the mapView to allow user interaction without modifying the mapView.
        mapSubView = UIView(frame: CGRect(x: mapView.frame.origin.x, y: mapView.frame.origin.y, width: mapView.frame.size.width, height: mapView.frame.size.height))
        mapSubView.isUserInteractionEnabled = true
        mapSubView.backgroundColor = UIColor.clear
        addSubview(mapSubView)
        
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func userButtonAction(_ sender: Any) {
        
    }
    
    func configureDirections(location1: CLLocation, location2: CLLocation) {
        
        
        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: location2.coordinate, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Your Location"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Task Location"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        
        self.mapView.showAnnotations([destinationAnnotation], animated: true )
        
        self.zoomToFitMapAnnotations(aMapView: self.mapView)

        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            
            self.driveTimeLabel.text = "\(Int(route.expectedTravelTime/60)) min drive"
            
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
        }
    }
    
    func zoomToFitMapAnnotations(aMapView: MKMapView) {
        guard aMapView.annotations.count > 0 else {
            return
        }
        var topLeftCoord: CLLocationCoordinate2D = CLLocationCoordinate2D()
        topLeftCoord.latitude = -90
        topLeftCoord.longitude = 180
        var bottomRightCoord: CLLocationCoordinate2D = CLLocationCoordinate2D()
        bottomRightCoord.latitude = 90
        bottomRightCoord.longitude = -180
        for annotation: MKAnnotation in mapView.annotations {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }
        
        var region: MKCoordinateRegion = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.4
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.4
        region = aMapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red:0.00, green:0.65, blue:1.00, alpha:1.0)
        renderer.lineWidth = 7.0
        
        return renderer
    }
    
    
    @IBAction func moreInfoButton(_ sender: Any) {
        
        configureDirections(location1: userLocation, location2: taskLocation)
        
        mapHeight = mapView.frame.size.height
        profileContainerY = profileContainerView.frame.origin.y
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
            self.infosBarView.alpha = 0
            self.mapView.frame.size.height = 200
            self.profileContainerView.frame.origin.y = 235
            self.moreInfo.isHidden = true
        })
    }
    
    @IBAction func closeDetailsButton(_ sender: Any) {
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
            self.mapView.frame.size.height = self.mapHeight
            
            self.profileContainerView.frame.origin.y = self.profileContainerY
            self.moreInfo.isHidden = false
        })
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0.4, options: .allowUserInteraction, animations: {
            self.infosBarView.alpha = 1
        })
    }
    

}

extension AsksArroundTableViewCell {

    
}


