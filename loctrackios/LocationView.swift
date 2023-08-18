//
//  ContentView.swift
//  loctrackios
//
// EcoTheoryApps Inc 14.08.23

import SwiftUI


struct LocationView: View {
    
    
    // @AppStorage("name") var uuid: String?
    @AppStorage("euagree") private var euagree = false
    @AppStorage("privagree") private var privagree = false
    @AppStorage("showFirstView") private var showFirstView = true
    @AppStorage("Trackok") private var Trackok = false
    @State var errortext = ""
    
    var body: some View {
        
        ZStack {
            if !euagree {
                EUView(euagree: $euagree);
            } else if !privagree {
                privView(privagree: $privagree);
            } else if !Trackok {
                TrackView(Trackok: $Trackok);
            } else {
                AppTrackView()
   
            }
        }
    }
}
    
    struct EUView: View {
        
        @State private var showingPopover = false
        @Binding var euagree: Bool
        var body: some View {
            VStack{
                ScrollView {
                    
                    VStack{
                        let filepath = Bundle.main.url(forResource: "EULA", withExtension: "md")
                        // Show the markdown.
                        
                        let eu = try! AttributedString(contentsOf: filepath!, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
                        Text("End user agreement")
                            .fontWeight(.bold)
                            .font(.title)
                        Text(eu)
                            .fixedSize(horizontal: false, vertical: true)
                    }.padding()
                }
                    Button {
                        euagree = true
                        
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
                }
            }
       }
    
        
    
    struct privView: View {
        
        @State private var showingPopover = false
        @Binding var privagree: Bool
        var body: some View {
            VStack{
                ScrollView {
                    let filepath = Bundle.main.url(forResource: "privacy", withExtension: "md")
                    // Show the markdown.
                    
                    let priv = try! AttributedString(contentsOf: filepath!, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
                    Text("Privacy agreemnent")
                        .fontWeight(.bold)
                        .font(.title)
                    ScrollView{
                        Text(priv)
                            .fixedSize(horizontal: false, vertical: true)
                    }.padding()
                }
                Button {
                    privagree = true
                    
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
                
            }
            
        }
    }
struct TrackView: View {
    
    @AppStorage("name") var uuid: String?
    @State private var showingPopover = false
    @Binding var Trackok: Bool
    
    var body: some View {
        ZStack{
            VStack{
                Text("PeerLearn")
                    .font(Font.largeTitle.weight(.bold))
                    .padding()
                ScrollView {
                    Text("This app will run in the background to track location automatically for 4-6 weeks in October and November to provide data for a peer learning teaching activity. At the end of this period the app will stop tracking. Your identity will not be recorded and all data will be password protected.\n\nTo participate, please select **'Allow when using the app'** in the popup request for location access. Sometime later you will be prompted again for location access, please select **'Always allow'** in the popup or settings to continue to run the app in the background\n\nThe location data will be used to simulate disease dynamics, which advanced students will analyze and model. They will present their findings and explain the models to the early year undergrads who provide the data. This peer learning exercise is designed to increase your understanding of quantitative methods.\n\nYou may discontinue location tracking at any time in the App settings. If at any time you wish your data to be deleted please contact us directly at the link below.")
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Link (destination: URL(string: "https://multi-plier.ca/PeerLearn.html")!){
                    Text("Visit our site for more details or to permanently delete your data")
                        .font(Font.body.weight(.bold))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                }
                
                
                Link (destination: URL(string: "https://multi-plier.ca/privacy.html")!){
                    Text("Privacy policy")
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
            }
            
        }
        //} else {
        //  Text("Not tracking:\n Need location permissions")
        //    .font(Font.title.weight(.bold))
        //  .foregroundColor(.purple)
        //       .font(.title)
        //     .padding()
        //    .border(Color.purple, width: 5)
        
        //}
        Spacer()
            .frame(height:50)
        
    }
}
    
struct AppTrackView: View {
    @StateObject var locationManager = LocationManager()
    @AppStorage("name") var uuid: String?
    @State private var showingPopover = false
    //    @Binding var locperm: Bool
    @State var errortext = ""
    
    var body: some View {
        

        
        return ZStack {
            
            VStack {
                Text("PeerLearn")
                    .font(Font.largeTitle.weight(.bold))
                    .padding()
                if !locationManager.indates {
                    Text("Outside of date range: Not tracking")
                        .font(Font.title.weight(.bold))
                        .foregroundColor(.purple)
                        .font(.title)
                        .padding()
                        .border(Color.purple, width: 5)
                    
                } else if locationManager.locperm {
                    
                    
                    Text("Tracking")
                    //  .font(Font.title.weight(.bold))
                        .font(.system(size: 53).weight(.bold))
                        .foregroundColor(.purple)
                        .font(.title)
                        .padding()
                        .border(Color.purple, width: 5)
                    Text("location status: \(locationManager.statusString)")
                    
                } else if !locationManager.locperm {
                    Text("location status: \(locationManager.statusString)")
                    Text("Waiting for permissions")
                        .font(Font.title.weight(.bold))
                        .foregroundColor(.purple)
                        .font(.title)
                        .padding()
                        .border(Color.purple, width: 5)
                }
                

                Text("uuid: \(uuid ?? "not set")")
                
                Spacer()
                
                Link (destination: URL(string: "https://multi-plier.ca/PeerLearn.html")!){
                    Text("Visit our site for more details or to permanently delete your data")
                        .font(Font.title2.weight(.bold))
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                }
                
                
                Link (destination: URL(string: "https://multi-plier.ca/privacy.html")!){
                    Text("Privacy policy")
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
                Spacer()
                    .frame(height:50)
            }
            .padding(.top, 30)
        }
    }
}

struct ErrorView: View {
var errortext = ""
    var body: some View {
        
        VStack {
            Text(errortext)
                .font(Font.title2.weight(.bold))
                .padding()
        }
    }
}
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
