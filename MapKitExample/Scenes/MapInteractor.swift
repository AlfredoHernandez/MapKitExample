//
//  MapInteractor.swift
//  MapKitExample
//
//  Created by Jesús Hernández Alarcón on 6/24/18.
//  Copyright (c) 2018 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit
import MapKit

protocol MapBusinessLogic{
  func requestPermissionForLocation(request: Map.RequestPermissionForLocation.Request)
}

protocol MapDataStore{
}

class MapInteractor: NSObject, MapBusinessLogic, MapDataStore {
  var presenter: MapPresentationLogic?
  var worker: MapWorker?
  
  // MARK: Local Variables
  
  /// CL Location Manager
  var manager = CLLocationManager()
  
  /// Current user's location
  var currentLocation: CLLocation?
}

extension MapInteractor: CLLocationManagerDelegate {
  
  /// Request Permission For Location
  ///
  /// - Parameter request: A `Map.RequestPermissionForLocation.Request`
  func requestPermissionForLocation(request: Map.RequestPermissionForLocation.Request) {
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      currentLocation = location
      LOG.info("Current location \(currentLocation)")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    LOG.error(error.localizedDescription)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    var response: Map.RequestPermissionForLocation.Response
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      response = Map.RequestPermissionForLocation.Response(success: true, error: nil)
    case .denied, .notDetermined, .restricted:
      let e = MapPermission.LocationPermissionDenied(reason: "Permission for location denied/restricted/notDetermined")
      response = Map.RequestPermissionForLocation.Response(success: false, error: e)
    }
    presenter?.presentPermissionsForLocation(response: response)
  }
  
}
