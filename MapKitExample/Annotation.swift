//
//  Annotation.swift
//  MapKitExample
//
//  Created by Jesús Hernández Alarcón on 6/24/18.
//  Copyright © 2018 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var brief: String
  
  init(title: String, brief: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.brief = brief
    self.coordinate = coordinate
    super.init()
  }
  
  var subtitle: String? {
    return self.brief
  }
}
