//
//  LocationManager.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/25.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func isLocationServiceEnabled() -> Bool {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .restricted, .denied:
            return true
        case .notDetermined:
            return false
        @unknown default:
            print("ERROR: unknown default in locationManager.authorizationStatus : \(locationManager.authorizationStatus)")
            return false
        }
    }
    
    func isLocationPermissionAuthorized() -> Bool {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .restricted, .denied, .notDetermined:
            return false
        @unknown default:
            print("ERROR: unknown default in locationManager.authorizationStatus : \(locationManager.authorizationStatus)")
            return false
        }
    }
  
    func requestUserAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted, .denied:
            break
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
}
