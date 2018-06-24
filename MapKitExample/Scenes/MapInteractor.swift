//
//  MapInteractor.swift
//  MapKitExample
//
//  Created by Jesús Hernández Alarcón on 6/24/18.
//  Copyright (c) 2018 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapBusinessLogic{
  func requestPermissionForLocation(request: Map.RequestPermissionForLocation.Request)
  func getCurrentLocation(request: Map.CurrentLocation.Request)
  func centerMap(request: Map.CenterMapToLocation.Request)
  func addAnnotation(request: Map.AddAnnotation.Request)
  func getAddress(request: Map.RequestAddress.Request)
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
  
  /// Coordinate Region (to center map)
  var coordinateRegion: MKCoordinateRegion!
  
  /// Region Radius to center Map
  var regionRadius: CLLocationDistance = 100.00
  
  /// Annotation Identifier
  let identifier = "annotationIdentifier"
  
  /// Geo Coder
  let geocoder = CLGeocoder()
}


// MARK: Core Location

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
      Log.info("Current location is: \(location)")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    Log.error(error.localizedDescription)
    var response: Map.RequestPermissionForLocation.Response
    response = Map.RequestPermissionForLocation.Response(success: false, error: error)
    presenter?.presentPermissionsForLocation(response: response)
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

// MARK: Map View

extension MapInteractor: MKMapViewDelegate{
  
  // MARK: Current Location
  func getCurrentLocation(request: Map.CurrentLocation.Request){
    // Prepare Map
    setupMap(in: request.mapView)
  }
  
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    Log.info("Location updated to: \(userLocation.coordinate)")
    // Prepare Response
    var response: Map.CurrentLocation.Response
    currentLocation = userLocation.location
    response = Map.CurrentLocation.Response(currentLocation: userLocation.location)
    presenter?.presentCurrentLocation(response: response)
  }
  
  private func setupMap(in view: MKMapView){
    view.delegate = self
    view.isZoomEnabled = true
    view.showsUserLocation = true
    view.userTrackingMode = .follow
  }
  
  // MARK: Center Map To Location
  func centerMap(request: Map.CenterMapToLocation.Request) {
    let region = MKCoordinateRegionMakeWithDistance(request.location.coordinate, regionRadius, regionRadius)
    let response = Map.CenterMapToLocation.Response(region: region)
    presenter?.presentCenterMap(response: response)
  }
  
  // MARK: Add Annotation
  
  func addAnnotation(request: Map.AddAnnotation.Request) {
    let response = Map.AddAnnotation.Response(title: request.title,
                                              subtitle: request.subtitle,
                                              coordinate2D: request.location.coordinate)
    presenter?.presentAnnotation(response: response)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
    if let customAnnotation = annotation as? Annotation {
      view = MKPinAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
      view?.canShowCallout = true
      view?.calloutOffset = CGPoint(x: -5, y: 5)
      view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
    }
    return view
  }
  
  // MARK: Get Address from coordinates
  
  func getAddress(request: Map.RequestAddress.Request){
    geocoder.reverseGeocodeLocation(request.location, preferredLocale: .current) { (placemarks, error) in
      var response: Map.RequestAddress.Response
      if let error = error {
        response = Map.RequestAddress.Response(error: error, placemark: nil)
      }else {
        // Log.info(placemarks)
        response = Map.RequestAddress.Response(error: nil, placemark: placemarks?.first)
      }
      self.presenter?.presentAddress(response: response)
    }
  }
}
