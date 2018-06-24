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
}

class MapPresenter: MapPresentationLogic{
  weak var viewController: MapDisplayLogic?
  
  // MARK: Present Permissions For Location
  
  func presentPermissionsForLocation(response: Map.RequestPermissionForLocation.Response) {
    let vm = Map.RequestPermissionForLocation.ViewModel(success: response.success,
                                                        message: response.error?.localizedDescription)
    viewController?.displayUsersLocationPermission(viewModel: vm)
  }
}
