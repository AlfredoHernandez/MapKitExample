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
}

class MapViewController: UIViewController, MapDisplayLogic{
  var interactor: MapBusinessLogic?
  var router: (NSObjectProtocol & MapRoutingLogic & MapDataPassing)?
  
  // MARK: IBOutlets
  @IBOutlet weak var mapView: MKMapView!
  
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
  }
  
  // MARK: Request for user's location permission
  
  func requestForUsersLocationPermission(){
    let request = Map.RequestPermissionForLocation.Request()
    interactor?.requestPermissionForLocation(request: request)
  }
  
  func displayUsersLocationPermission(viewModel: Map.RequestPermissionForLocation.ViewModel) {
    if viewModel.success {
      LOG.info("Permissions for location success")
    }else {
      // Display error for location
      LOG.error(viewModel.message ?? "NO MESSAGE")
    }
  }
}
