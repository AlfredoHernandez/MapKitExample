//
//  MapModels.swift
//  MapKitExample
//
//  Created by Jesús Hernández Alarcón on 6/24/18.
//  Copyright (c) 2018 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit
import MapKit

enum MapPermission : Error {
  case LocationPermissionDenied(reason: String)
}

enum Map{
  // MARK: Use cases
  
  enum RequestPermissionForLocation{
    struct Request{ }
    struct Response{
      var success: Bool
      var error: Error?
    }
    struct ViewModel{
      var success: Bool
      var message: String?
    }
  }
  
  enum CurrentLocation {
    struct Request {
      var mapView: MKMapView
    }
    struct Response {
      var currentLocation: CLLocation?
    }
    struct ViewModel {
      var currentLocation: CLLocation?
    }
  }
  
  enum CenterMapToLocation {
    struct Request {
      var location: CLLocation
    }
    struct Response {
      var region: MKCoordinateRegion
    }
    struct ViewModel {
      var region: MKCoordinateRegion
    }
  }
  
  enum AddAnnotation {
    struct Request {
      var title: String
      var subtitle: String
      var location: CLLocation
    }
    struct Response {
      var title: String
      var subtitle: String
      var coordinate2D: CLLocationCoordinate2D
    }
    struct ViewModel {
      var annotation: Annotation
    }
  }
  
  enum RequestAddress {
    struct Request {
      var location: CLLocation
    }
    struct Response {
      var error: Error?
      var placemark: CLPlacemark?
    }
    struct ViewModel {
      var error: Error?
      var placemark: CLPlacemark?
    }
  }
}
