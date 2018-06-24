//
//  MapViewController.swift
//  MapKitExample
//
//  Created by Jesús Hernández Alarcón on 6/24/18.
//  Copyright (c) 2018 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit
import MapKit

protocol MapDisplayLogic: class{
  func displayUsersLocationPermission(viewModel: Map.RequestPermissionForLocation.ViewModel)
  func displayUserCurrentLocation(viewModel: Map.CurrentLocation.ViewModel)
  func displayCenterMap(viewModel: Map.CenterMapToLocation.ViewModel)
  func displayAnnotation(viewModel: Map.AddAnnotation.ViewModel)
  func displayAddress(viewModel: Map.RequestAddress.ViewModel)
}

class MapViewController: UIViewController, MapDisplayLogic{
  // MARK: Local Variables
  var interactor: MapBusinessLogic?
  var router: (NSObjectProtocol & MapRoutingLogic & MapDataPassing)?
  var currentLocation: CLLocation?
  
  // MARK: IBOutlets
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
  @IBOutlet weak var labelAddress: UILabel!
  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder){
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup(){
    let viewController = self
    let interactor = MapInteractor()
    let presenter = MapPresenter()
    let router = MapRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad(){
    super.viewDidLoad()
    // Request for location
    requestForUsersLocationPermission()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      if let location = self.currentLocation {
        self.requestAddress(for: location)
      }
    }
  }
  
  @IBAction func goToCurrentLocationAction(_ sender: Any) {
    guard let location = currentLocation else { return }
    centerMap(to: location)
  }
  
  @IBAction func addAnnotationToMap(_ sender: Any) {
    let point = longPressGestureRecognizer.location(in: mapView)
    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    addAnnotation(in: location,
                  withTitle: "Selected Location",
                  andDescription: "User Selected Location")
    requestAddress(for: location)
  }
  
  @IBAction func useMyLocationAction(_ sender: Any) {
    if let location = currentLocation {
      requestAddress(for: location)
      addAnnotation(in: location,
                    withTitle: "My Location",
                    andDescription: "Current Location")
    }
  }
  
}

// MARK: - Use Cases

extension MapViewController {
  // MARK: Request for user's location permission
  
  func requestForUsersLocationPermission(){
    let request = Map.RequestPermissionForLocation.Request()
    interactor?.requestPermissionForLocation(request: request)
  }
  
  func displayUsersLocationPermission(viewModel: Map.RequestPermissionForLocation.ViewModel) {
    if viewModel.success {
      Log.info("Permissions for location success")
      // After success, request for current location
      requestForCurrentLocation()
    }else {
      // Display error for location
      Log.error(viewModel.message ?? "NO MESSAGE")
    }
  }
  
  // MARK: Display user location
  
  func requestForCurrentLocation(){
    let request = Map.CurrentLocation.Request(mapView: self.mapView)
    interactor?.getCurrentLocation(request: request)
  }
  
  func displayUserCurrentLocation(viewModel: Map.CurrentLocation.ViewModel) {
    if let location = viewModel.currentLocation{
      Log.info("Current location updated to: \(location)")
      currentLocation = location
    }else {
      Log.info("Try again: Request for current location")
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        self.requestForCurrentLocation()
      }
    }
  }
  
  // MARK: Display Center Map
  
  func centerMap(to location: CLLocation){
    let request = Map.CenterMapToLocation.Request(location: location)
    interactor?.centerMap(request: request)
  }
  
  func displayCenterMap(viewModel: Map.CenterMapToLocation.ViewModel) {
    mapView.setRegion(viewModel.region, animated: true)
  }
  
  // MARK: Add Annotation
  
  func addAnnotation(in location: CLLocation, withTitle title: String, andDescription brief: String){
    let request = Map.AddAnnotation.Request(title: title, subtitle: brief, location: location)
    interactor?.addAnnotation(request: request)
  }
  
  func displayAnnotation(viewModel: Map.AddAnnotation.ViewModel) {
    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotation(viewModel.annotation)
  }
  
  // MARK: Request Address for location
  
  func requestAddress(for location: CLLocation){
    let request = Map.RequestAddress.Request(location: location)
    interactor?.getAddress(request: request)
  }
  
  func displayAddress(viewModel: Map.RequestAddress.ViewModel) {
    if let e = viewModel.error {
      Log.error(e)
    }else {
      let address = Address(placemark: viewModel.placemark!)
      labelAddress.text = address.formatAddress()
    }
  }

}
