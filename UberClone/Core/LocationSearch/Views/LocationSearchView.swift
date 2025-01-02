//
//  LocationSearchView.swift
//  UberClone
//
//  Created by Shubh Jain  on 26/12/24.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @State private var destinationLocationText = ""
    @EnvironmentObject var viewModel : LocationSearchViewModel
    @Binding var mapState : MapViewState
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.systemGray))
                        .frame(width: 6,height: 6)
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(width: 1,height: 24)
                    Rectangle()
                        .fill(Color(.black))
                        .frame(width: 6,height: 6)
                    
                }
                VStack{
                    TextField("Current Location", text: $startLocationText )
                        .background(Color(.systemGroupedBackground))
                        .frame(height:32)
                        .padding(.trailing)
                    
                    TextField("Where To?", text: $viewModel.queryFragment)
                        .background(Color(.systemGray4))
                        .frame(height:32)
                        .padding(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.top,64)
            
            Divider()
                .padding(.vertical)
            
            ScrollView{
                VStack(alignment:.trailing){
                    ForEach (viewModel.results,  id: \.self) {
                        result in
                        LocationSearchResultCell(title: result.title , subTitle: result.subtitle)
                             
                            .onTapGesture {
                                withAnimation(.spring()){
                                    viewModel.selectLocation(result)
                                    mapState = .locationSelected
                                }
                                
                            }
                    }
                }
            }
        }
        .background(Color.theme.backgroundColor)
        .background(.white)
    }
}

#Preview {
    LocationSearchView( mapState: .constant(.noInput))
}
