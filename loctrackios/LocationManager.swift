//
//  LocationManager.swift
//  loctrackios
//
//  Created by thaqib on 2022-07-30.
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
    @Published var indates: Bool = false
    @Published var locperm:Bool = false
    var allowsBackgroundLocationUpdates = true
    var pausesLocationUpdatesAutomatically = false
    
        
        var locationStatus:CLAuthorizationStatus?{
            didSet{
                
             if locationStatus == .authorizedWhenInUse || locationStatus == .authorizedAlways {
                   self.locperm = true
               }
   
            }
        }
    
 

    let startdate = DateComponents(calendar: Calendar.current, timeZone: TimeZone(abbreviation: "GMT"), year: 2022, month: 11, day: 12, hour: 23, minute: 59, second: 59).date!
   
    
    let enddate = DateComponents(calendar: Calendar.current, timeZone: TimeZone(abbreviation: "GMT"), year: 2022, month: 12, day: 07, hour: 23, minute: 59, second: 59).date!
    
    let timeInterval: TimeInterval = 60 * 5.0 // Update time interval (seconds)
    override init() {
        
        lastUpdateTime = Date.now
        super.init()
        authorizationStatus = locationManager.authorizationStatus
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // Best accuracy
        locationManager.activityType = .other
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        if (startdate...enddate).contains(lastUpdateTime) {
            indates = true
            
            if locperm {
                
                locationManager.startUpdatingLocation()
            }
        }
   //     locationManager.requestWhenInUseAuthorization()
   //    locationManager.requestAlwaysAuthorization() // Always need location
    //    locationManager.allowsBackgroundLocationUpdates = true
   //     locationManager.startUpdatingLocation()

    }
    
    func requestPermission(){
        locationManager.requestAlwaysAuthorization() // Always need location
        locationManager.allowsBackgroundLocationUpdates = true
        if locperm {
            locationManager.startUpdatingLocation()
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

  
    

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            locationStatus = status
            print(#function, statusString)
            switch status {
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
                break
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                break
              case .restricted, .denied:
                locationManager.stopUpdatingLocation()
                break
                
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
                break
            }

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
            if(delta > timeInterval){ // Update every 10 seconds
                lastUpdateTime = sendRequest(long: long, lat: lat, alt: alt, lastUpdateTime: lastUpdateTime)
            }
            print(#function, location)
        }
}
