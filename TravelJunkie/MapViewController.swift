//
//  MapViewController.swift
//  TravelJunkie
//
//  Created by Tyler Weppler on 11/8/16.
//  Copyright © 2016 Tyler Weppler. All rights reserved.
//
//Code adapted from the following tutorial:
//www.youtube.com/watch?v=8-TDf_7j59Y&t=16s

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class MapViewController: UIViewController{

    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    
    let locationManager = CLLocationManager()
    @IBOutlet var newWordField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func button3(_ sender: AnyObject) {
        getDirections()
    }
    var pinTitle: String?
    
    func wordEntered(alert: UIAlertAction!){
        // store the new word
        pinTitle = self.newWordField.text
    }
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Title"
        self.newWordField = textField
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        //let locationSearchTable = LocationSearchTable()
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.addAnnotation(gestureRecognizer:)))
        longPress.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(longPress)
    }
    
    func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer)
    {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began
        {
            print("pushed")
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoord = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoord
            let defaults = UserDefaults.standard
            let me = defaults.value(forKey: "user")
            
            let alert = UIAlertController(title: "New Pin", message: "Enter a title for your pin.", preferredStyle: .alert)
            alert.addTextField(configurationHandler: addTextField)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{(UIAlertAction) in
                self.pinTitle = self.newWordField.text
                
                let trimmedString = self.pinTitle?.replacingOccurrences(of: " ", with: "")
                //id, userID, pinLat, pinLong, pinColor, pinTitle
                let thisurl = URL(string: "https://cs.okstate.edu/~weppler/newPin.php/\(me!)/\(annotation.coordinate.latitude)/\(annotation.coordinate.longitude)/green/\(trimmedString!)")
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: thisurl!){(error) in
                    guard error == nil else {
                        print("Error in session call: \(error)")
                        return
                    }
                    
                }
                task.resume()
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion:nil)
            annotation.title = pinTitle
            
            
            
            mapView.addAnnotation(annotation)
        }
    }
}

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension MapViewController: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        let reuseId = "pin"
        guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView else { return nil }
        
        pinView.pinTintColor = UIColor.yellow
        pinView.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        var button: UIButton?
        button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button?.setBackgroundImage(UIImage(named: "car"), for: UIControlState())
        button?.addTarget(self, action: #selector(MapViewController.getDirections), for: .touchUpInside)
        pinView.leftCalloutAccessoryView = button
        
        return pinView
    }
}
