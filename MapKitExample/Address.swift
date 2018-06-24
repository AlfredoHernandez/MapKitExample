//
//  Address.swift
//  MapKitExample
//
//  Created by Jesús Hernández Alarcón on 6/24/18.
//  Copyright © 2018 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import MapKit
import Foundation

class Address {
  var placemark: CLPlacemark
  
  init(placemark: CLPlacemark) {
    self.placemark = placemark
    showDebugData()
  }
  
  private func showDebugData(){
    Log.info("NAME \(String(describing: placemark.name))")
    Log.info("LOCALITY \(String(describing: placemark.locality))")
    Log.info("SUB LOCALITY \(String(describing: placemark.subLocality))")
    Log.info("ADMINISTRATIVE AREA \(String(describing: placemark.administrativeArea))")
    Log.info("SUB ADMINISTRATIVE AREA \(String(describing: placemark.subAdministrativeArea))")
    Log.info("COUNTRY \(String(describing: placemark.country))")
    Log.info("INLANDWATER \(String(describing: placemark.inlandWater))")
    Log.info("ISOCOUNTRYCODE \(String(describing: placemark.isoCountryCode))")
    Log.info("OCEAN \(String(describing: placemark.ocean))")
    Log.info("POSTAL CODE \(String(describing: placemark.postalCode))")
    Log.info("THOROUGHFARE \(String(describing: placemark.thoroughfare))")
    Log.info("SUBTHOROUGFARE \(String(describing: placemark.subThoroughfare))")
    Log.info("AREAS OF INTEREST \(String(describing: placemark.areasOfInterest ?? nil))")
  }
  
  func formatAddress() -> String {
    return "\(placemark.name ?? "") \(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? "") \(placemark.postalCode ?? "") \(placemark.administrativeArea ?? "") \(placemark.subAdministrativeArea ?? "")"
  }
}
