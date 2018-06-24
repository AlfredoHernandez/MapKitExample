//
//  MapPresenter.swift
//  MapKitExample
//
//  Created by Jesús Hernández Alarcón on 6/24/18.
//  Copyright (c) 2018 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit

protocol MapPresentationLogic{
  func presentPermissionsForLocation(response: Map.RequestPermissionForLocation.Response)
  func presentCurrentLocation(response: Map.CurrentLocation.Response)
  func presentCenterMap(response: Map.CenterMapToLocation.Response)
  func presentAnnotation(response: Map.AddAnnotation.Response)
  func presentAddress(response: Map.RequestAddress.Response)
}

class MapPresenter: MapPresentationLogic{
  weak var viewController: MapDisplayLogic?
  
  // MARK: Present Permissions For Location
  func presentPermissionsForLocation(response: Map.RequestPermissionForLocation.Response) {
    let vm = Map.RequestPermissionForLocation.ViewModel(success: response.success,
                                                        message: response.error?.localizedDescription)
    viewController?.displayUsersLocationPermission(viewModel: vm)
  }
  
  // MARK: Present Current Location
  func presentCurrentLocation(response: Map.CurrentLocation.Response) {
    let vm = Map.CurrentLocation.ViewModel(currentLocation: response.currentLocation)
    viewController?.displayUserCurrentLocation(viewModel: vm)
  }
  
  // MARK: Present Center Map
  func presentCenterMap(response: Map.CenterMapToLocation.Response) {
    let vm = Map.CenterMapToLocation.ViewModel(region: response.region)
    viewController?.displayCenterMap(viewModel: vm)
  }
  
  // MARK: Add annotation
  func presentAnnotation(response: Map.AddAnnotation.Response) {
    let annotation = Annotation(title: response.title, brief: response.subtitle, coordinate: response.coordinate2D)
    let vm = Map.AddAnnotation.ViewModel(annotation: annotation)
    viewController?.displayAnnotation(viewModel: vm)
  }
  
  // MARK: Present Address
  func presentAddress(response: Map.RequestAddress.Response) {
    let vm = Map.RequestAddress.ViewModel(error: response.error, placemark: response.placemark)
    viewController?.displayAddress(viewModel: vm)
  }
}
