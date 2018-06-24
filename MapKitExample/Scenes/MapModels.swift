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
    struct Request{
    }
    struct Response{
      var success: Bool
      var error: Error?
    }
    struct ViewModel{
      var success: Bool
      var message: String?
    }
  }
}
