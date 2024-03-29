//
//  LocationManager.swift
//  loctrackios
//
//  EcoTheoryApps Inc 08-08-23
//

import Foundation
import CoreLocation
import Combine
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    var lastUpdateTime: Date
    @Published var indates:Bool = false
    @Published var locperm:Bool = false
    var allowsBackgroundLocationUpdates = true
    var pausesLocationUpdatesAutomatically = false
    var showsBackgroundLocationIndicator = true
    var distanceFilter = 15
    var firstlocate: Bool = true
    
    var locationStatus:CLAuthorizationStatus?{
        didSet{
            if locationStatus == .authorizedWhenInUse || locationStatus == .authorizedAlways {
                self.locperm = true
                
            }
            
        }
    }
    
    
    
    let startdate = DateComponents(calendar: Calendar.current, timeZone: TimeZone(abbreviation: "UTC"), year: 2023, month: 08, day: 08, hour: 23, minute: 59, second: 59).date!
    let enddate = DateComponents(calendar: Calendar.current, timeZone: TimeZone(abbreviation: "UTC"), year: 2023, month: 11, day: 30, hour: 24, minute: 59, second: 59).date!
    let timeInterval: TimeInterval = 60 * 15.0 // Update time interval (seconds)
    
  
    override init() {
        lastUpdateTime = Date.now
        super.init()
        authorizationStatus = locationManager.authorizationStatus
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // Best accuracy
        locationManager.activityType = .other
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = 15
        locationManager.showsBackgroundLocationIndicator = true
        
        if (startdate...enddate).contains(lastUpdateTime) {
            self.indates = true
        } else {
            self.indates = false
            }
        
           
        if locperm && indates {
            locationManager.startUpdatingLocation()
            
        } else {
            locationManager.stopUpdatingLocation()
            }
        
    }
    
    
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        switch status {
        case .notDetermined:
            return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
        
    }
    
   
    func requestPermission(){
        locationManager.requestAlwaysAuthorization() // Always need location
    }
    
    // Delegate method to check authorization status and request "When In Use" authorization
       func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           let status = locationManager.authorizationStatus
           locationStatus = status
           print(#function, statusString)
           switch status {
           case .authorizedAlways:
               if indates {
                   locationManager.startUpdatingLocation()
               }
               break
           case .authorizedWhenInUse:
               locationManager.requestAlwaysAuthorization()
               if indates {
                   locationManager.startUpdatingLocation()
               }
            
               break
           case .restricted, .denied:
               locperm = false
               locationManager.stopUpdatingLocation()
               break
           case .notDetermined:
               locationManager.requestAlwaysAuthorization()
               break
           @unknown default:
               break
           }
           
       }
       

     
   // func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
     //   locationStatus = status
       // print(#function, statusString)
       // switch status {
       // case .authorizedAlways:
         //   if indates {
           //     locationManager.startUpdatingLocation()
      //      }
        //    break
       // case .authorizedWhenInUse:
         //   locationManager.requestAlwaysAuthorization()
         //   if indates {
    //            locationManager.startUpdatingLocation()
      //      }
         
        //    break
       // case .restricted, .denied:
         //   locperm = false
         //   locationManager.stopUpdatingLocation()
           // break
     //   case .notDetermined:
       //     locationManager.requestAlwaysAuthorization()
         //   break
       // @unknown default:
         //   break
       // }
     
  //  }
    
    func sendRequest(long: Double, lat: Double, alt: Double, lastUpdateTime: Date) -> Date{
        let time = Date.now
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateStr = dateFmt.string(from: time)
        @AppStorage("uuid") var uuid: String?
        
        if let uuid = uuid {
            let str = "?capturedate=\(dateStr)&id=\(uuid)&lat=\(lat)&long=\(long)&alt=\(alt)"
            guard let url = URL(string: "https://multi-plier.ca/\(str)") else { return lastUpdateTime }
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
                print(String(data: data, encoding: .utf8)!)
            }
            task.resume()
            return time
        }
        return lastUpdateTime
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        let lat = lastLocation?.coordinate.latitude ?? -1
        let long = lastLocation?.coordinate.longitude ?? -1
        let alt = lastLocation?.altitude ?? -1
        //sendRequest(long: long, lat: lat, alt: alt)
        let delta = Date.now.timeIntervalSince1970 - lastUpdateTime.timeIntervalSince1970
        print(#function, "Time Since last update: \(delta)s")
        if (firstlocate) { lastUpdateTime = sendRequest(long: long, lat: lat, alt: alt, lastUpdateTime: lastUpdateTime)
            print(#function, lastUpdateTime)
            firstlocate = false
            
        }
        
        else if(delta > timeInterval){ // Update every interval seconds
            lastUpdateTime = sendRequest(long: long, lat: lat, alt: alt, lastUpdateTime: lastUpdateTime)
            print(#function, lastUpdateTime)
        }
        print(#function, location)
    }
    
    
    
    func locationManager(_ manager: CLLocationManager,
                        didFailWithError error: Error) {
        let err = CLError.Code(rawValue: (error as NSError).code)!
        switch err {
        case .locationUnknown:
            if locperm && indates {
                locationManager.startUpdatingLocation()
            }
     default:
            print(err)
        }
   }
}
