//
//  ContentView.swift
//  loctrackios
//
//  Created by thaqib on 2022-07-30.
//

import SwiftUI


struct LocationView: View {
    @StateObject var locationManager = LocationManager()
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        }
    var userLongitude: String {
           return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
       }
    
    var userAltitude: String {
        return "\(locationManager.lastLocation?.altitude ?? 0)"
    }
    
    @AppStorage("name") var uuid: String?
    
    @State private var showFirstView = true
    @State private var Trackok = false
    @State private var showingPopover = false
    var body: some View {
        if showFirstView {
            Text("EULA")
                .fontWeight(.bold)
                    .font(.title)
            Text("Body of agreement")
            
            Button {
                showFirstView = false
            } label: {
                Text("I agree")
            }
            
            Button {
                showingPopover = true
            } label: {
                Text("I do not agree")
            }
            .popover(isPresented: self.$showingPopover, arrowEdge: .bottom) {
                            Text("You may not use this app without agreeing")
                                .font(.headline)
                                .padding()
                
                Button {
                    showingPopover = false
                } label: {
                    Text("I understand")
                }
                        }
                    
                    
            
            
        } else if Trackok==false {
            
            
            
            
            
            
            Button(action: { Trackok = true
                let str = "\(Date.now.formatted().hashValue)"
                UserDefaults.standard.set(str, forKey: "uuid")
                uuid = str
                   
                
            }, label: {
                Text("I agree to participate, start tracking")
                    .foregroundColor(.purple)
                    .font(.title)
                    .padding()
                    .border(Color.purple, width: 5)
                    .foregroundColor(Trackok==true ? .green : .red)
                Image(systemName: "location")
            })
        } else if Trackok==true {
            
            VStack {
               
                Text("Tracking")
                    .foregroundColor(.purple)
                    .font(.title)
                    .padding()
                    .border(Color.purple, width: 5)
                Text("location status: \(locationManager.statusString)")
                Text("latitude: \(userLatitude)")
                Text("longitude: \(userLongitude)")
                Text("altitude: \(userAltitude)")
                
                    .disabled(uuid != nil)
                    Text("uuid: \(uuid ?? "not set")")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
