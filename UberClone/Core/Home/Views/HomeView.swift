//
//  HomeView.swift
//  UberClone
//
//  Created by Shubh Jain  on 23/12/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var mapState = MapViewState.noInput
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    var body: some View {
        ZStack (alignment : .bottom){
            ZStack(alignment:.top) {
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchingForLocation {
                    LocationSearchView(mapState : $mapState)
                }
                else if mapState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top,72)
                        .onTapGesture {
                            withAnimation(.spring()){
                                mapState = .searchingForLocation
                            }
                        }
                }
                MapViewActionButton(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top,4)
                    
            }
            
            if mapState == .locationSelected || mapState == .polyLineSelected {
                rideRequestedView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation){ location in
            if let location = location {
                print(location)
            }
        }
    }
}

#Preview {
    HomeView()
}
