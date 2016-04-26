//
//  ViewController.swift
//  RestoAround
//
//  Created by Jonathan Durieu on 19/04/16.
//  Copyright © 2016 Jonathan Durieu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    let annotationIdentifier = "annotationIdentifier"
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var webViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapViewConstraint: NSLayoutConstraint!
    
    lazy var mainLocationManager = CLLocationManager()
    lazy var annotations = [RestoAnnotation]()
    
    lazy var restosV = [Resto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentStatus = CLLocationManager.authorizationStatus()
        
        switch currentStatus {
        case .Denied:
            let alertController = UIAlertController(title: "Erreur", message: "Veuillez activer la géolocalisation, s’il vous plaît ?", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (alertAction) in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }))
            
            self.presentViewController(alertController, animated: false, completion: nil)

            
            break
        case .NotDetermined:
            mainLocationManager.requestWhenInUseAuthorization()


            break
        default:
            break
        }
        
        self.mainLocationManager.delegate = self
        self.mainLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.mainLocationManager.startUpdatingLocation()
        
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MKMapView delegate methods

    //MARK: -1- Annomations Methods
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if isUserAnnotation(annotation, mapView: mapView) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier)
        
        if annotationView==nil {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            pinAnnotationView.animatesDrop = true
            annotationView = pinAnnotationView
        }
        annotationView?.canShowCallout = true
    
    
        
        
        
        //Ne fonctionne pas pour l'instant avec le texte ... à voir plus tard... après l'éval en gros
        let rightCalloutButton=UIButton(type: UIButtonType.Custom)
        
        rightCalloutButton.setTitle("Notifier", forState: .Normal)
        rightCalloutButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        rightCalloutButton.frame = CGRectMake(0, 0, 100, 50)
        
        annotationView?.rightCalloutAccessoryView = rightCalloutButton
        
        return annotationView

    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
    
            handleNotification()
        }
        
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        launchWebView()

    }
    
    //MARK: -2- Location Methods

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        
        if let location = userLocation.location {
           
            RestoFinder.findRestoAround(location.coordinate.latitude, longitude: location.coordinate.longitude) { (restos) in
                self.addAnnotations(restos)
            }
        }
    }
 
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = mapView.centerCoordinate
        
        RestoFinder.findRestoAround(location.latitude, longitude: location.longitude) { (restos) in
            self.addAnnotations(restos)
            self.addRestos(restos)
        }
    }
    
    // MARK: - Private methods
    
    func addRestos(restos:[Resto]){
        restosV.removeAll()
        
        for resto in restos {
            restosV.append(resto)
        }
        
    }
    
    func addAnnotations(restos:[Resto]) {
        annotations.removeAll()
        
        for resto in restos {
            let restoAnnotation = RestoAnnotation(resto: resto)
            annotations.append(restoAnnotation)
        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    func isUserAnnotation(annotation:MKAnnotation, mapView:MKMapView) -> Bool {
        let userLocationCoordinate = mapView.userLocation.coordinate
        
        return (annotation.coordinate.latitude==userLocationCoordinate.latitude) && (annotation.coordinate.longitude==userLocationCoordinate.longitude)
    }
    
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        self.mainLocationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - Notification Method
    
    
    func handleNotification(){
       
        //récupération des settings pour les types voulus
        let notificationSettings = UIUserNotificationSettings(forTypes:
            [UIUserNotificationType.Badge, UIUserNotificationType.Sound,
                UIUserNotificationType.Alert], categories: nil)

        //demande des permissions pour les types voulus
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    
        let localNotification = UILocalNotification()
            localNotification.alertTitle="Réservation du restaurant"
            localNotification.alertBody = "Vous devriez réserver ce restaurant"
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        
        let userInfo = ["userId":"42","currentValue":"300"]
        localNotification.userInfo = userInfo

        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    //MARK: - WebView Methods
    
    func launchWebView(){
          /*
        self.mapViewConstraint.constant = view.bounds.height/2
        self.webViewConstraint.constant = view.bounds.height/2
        
        UIView.animateWithDuration(0.9, animations: { self.view.layoutIfNeeded()})
    */
        
        //A changer pour l'url du resto
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https:www.facebook.com")!))
    
    }
}
