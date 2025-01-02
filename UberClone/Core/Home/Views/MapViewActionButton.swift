//
//  MapViewActionButton.swift
//  UberClone
//
//  Created by Shubh Jain  on 26/12/24.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState : MapViewState
    @EnvironmentObject var viewModel : LocationSearchViewModel
    var body: some View {
        Button(action: {
            withAnimation(.spring()){
                actionForState(mapState)
            }
         
        }, label: {
            Image(systemName: imageForMapState(mapState) )
                .foregroundColor(.black)
                .font(.title2)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 6)
        })
        .frame(maxWidth:.infinity , alignment: .leading)
    }
    func actionForState( _ state : MapViewState ){
        switch state {
        case .noInput:
            print("No input")
        case .searchingForLocation :
            mapState = .noInput
        case .locationSelected , .polyLineSelected:
            mapState = .noInput
            viewModel.selectUberLocation = nil
        }
    }
    func imageForMapState( _ state : MapViewState ) -> String{
        switch state {
        case .noInput:
              return "line.3.horizontal"
        case .searchingForLocation ,.locationSelected :
              return "arrow.left"
        default:
            return "line.3.horizontal"
        }
    }
}

#Preview {
    MapViewActionButton(mapState: .constant(.noInput))
}
