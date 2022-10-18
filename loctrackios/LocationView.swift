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
    @AppStorage("showFirstView") private var showFirstView = true

  
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
            
            Text("PeerLearn")
                .font(Font.largeTitle.weight(.bold))
                .padding()
            
            Text("This app will run in the background to track location, but your identity will not be shared. To protect your privacy, the phone will assign itself a random identity code. In addition, the data will be stored in a password protected location \n\n Please select 'Always allow' when prompted about running the app in the background ")
                .padding()
                .fixedSize(horizontal: false, vertical: true)
           
            Link (destination: URL(string: "https://multi-plier.ca/PeerLearn.html")!){
                 Text("Visit our site for more details about this project")
                    .font(Font.body.weight(.bold))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                     .background(Color.yellow)
                     .foregroundColor(.black)
                     .cornerRadius(5)
               }
          
         
         Link (destination: URL(string: "https://multi-plier.ca/privacy.html")!){
              Text("More details about how we protect your privacy")
                 .font(Font.body.weight(.bold))
                 .fixedSize(horizontal: false, vertical: true)
                  .padding()
                  .background(Color.yellow)
                  .foregroundColor(.black)
                  .cornerRadius(5)
            }
         Link (destination: URL(string: "https://multi-plier.ca/EULA.html")!){
              Text("User agreement")
                 .font(Font.body.weight(.bold))
                 .fixedSize(horizontal: false, vertical: true)
                  .padding()
                  .background(Color.yellow)
                  .foregroundColor(.black)
                  .cornerRadius(5)
            }
            Spacer()
        
            Button(action: { Trackok = true
                let str = "\(Date.now.formatted().hashValue)"
                UserDefaults.standard.set(str, forKey: "uuid")
                uuid = str
                   
                
            }, label: {
                Text("I agree to participate, start tracking")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Font.title2.weight(.bold))
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
                    .font(Font.title.weight(.bold))
                    .foregroundColor(.purple)
                    .font(.title)
                    .padding()
                    .border(Color.purple, width: 5)
            //    Text("location status: \(locationManager.statusString)")
            //    Text("latitude: \(userLatitude)")
            //    Text("longitude: \(userLongitude)")
            //    Text("altitude: \(userAltitude)")
                
                    .disabled(uuid != nil)
            //        Text("uuid: \(uuid ?? "not set")")
                
                
                Link (destination: URL(string: "https://multi-plier.ca/PeerLearn.html")!){
                     Text("Visit our site for more details about this project")
                        .font(Font.title2.weight(.bold))
                         .padding()
                         .background(Color.yellow)
                         .foregroundColor(.black)
                         .cornerRadius(5)
                   }
              
             
             Link (destination: URL(string: "https://multi-plier.ca/privacy.html")!){
                  Text("More details about how we protect your privacy")
                     .font(Font.title2.weight(.bold))
                      .padding()
                      .background(Color.yellow)
                      .foregroundColor(.black)
                      .cornerRadius(5)
                }
             Link (destination: URL(string: "https://multi-plier.ca/EULA.html")!){
                  Text("User agreement")
                     .font(Font.title2.weight(.bold))
                      .padding()
                      .background(Color.yellow)
                      .foregroundColor(.black)
                      .cornerRadius(5)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
