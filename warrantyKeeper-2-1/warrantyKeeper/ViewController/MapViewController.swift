//
//  MapViewController.swift
//  warrantyKeeper
//
//  Created by anonymous on 22/12/2019.
//  Copyright © 2019 anonymous. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
   
    
    
    
    let locationManager = CLLocationManager()
        let regionInMeters: Double = 10000
        var previousLocation: CLLocation?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            checkLocationServices()
        }
        

 
        
        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        
        func centerViewOnUserLocation() {
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
                mapView.setRegion(region, animated: true)
            }
        }
        
        
        func checkLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                setupLocationManager()
                checkLocationAuthorization()
            } else {
                // Show alert letting the user know they have to turn this on.
            }
        }
        
        
        func checkLocationAuthorization() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                startTackingUserLocation()
            case .denied:
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
             
                break
            case .authorizedAlways:
                break
            @unknown default:
                break
            }
        }
        
        
        func startTackingUserLocation() {
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            previousLocation = getCenterLocation(for: mapView)
        }
        
        
        func getCenterLocation(for mapView: MKMapView) -> CLLocation {
            let latitude = mapView.centerCoordinate.latitude
            let longitude = mapView.centerCoordinate.longitude
            
            return CLLocation(latitude: latitude, longitude: longitude)
        }
    }


    extension MapViewController: CLLocationManagerDelegate {
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
        }
        
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           let destVC = segue.destination as! AddItemViewController
            destVC.locationText.text = addressLabel.text!
           }
        
    }


    extension MapViewController: MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let center = getCenterLocation(for: mapView)
            let geoCoder = CLGeocoder()
            
            guard let previousLocation = self.previousLocation else { return }
            
            guard center.distance(from: previousLocation) > 50 else { return }
            self.previousLocation = center
            
            geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                
                if let _ = error {
                    //TODO: Show alert informing the user
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    //TODO: Show alert informing the user
                    return
                }
                
                let streetNumber = placemark.subThoroughfare ?? ""
                let streetName = placemark.thoroughfare ?? ""
                
                DispatchQueue.main.async {
                    self.addressLabel.text = "\(streetNumber) \(streetName)"
                }
            }
        }
    }
