//
//  rideRequestedView.swift
//  UberClone
//
//  Created by Shubh Jain  on 27/12/24.
//

import SwiftUI

struct rideRequestedView: View {
    @State private var selectedRide : RideType = .uberX
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(Color(.systemGray))
                .frame(width: 48,height: 6)
                .padding(.top)
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.systemGray))
                        .frame(width: 8,height: 8)
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(width: 1,height: 32)
                    Rectangle()
                        .fill(Color(.black))
                        .frame(width: 8,height: 8)
                    
                }
                VStack(alignment: .leading ,spacing: 24){
                    HStack{
                        Text("Current Location")
                            .foregroundStyle(Color(.systemGray))
                            .font(.system(size: 16,weight: .semibold))
                        
                        Spacer()
                        
                        Text(locationViewModel.pickupTime ?? "")
                            .font(.system(size: 14,weight: .semibold))
                            .foregroundColor(.gray)
                    }.padding(.bottom,10)
                    HStack{
                        if let location = locationViewModel.selectUberLocation {
                            Text(location.title)
                                .font(.system(size: 16,weight: .semibold))
                        }
                        
                        Spacer()
                        
                        Text(locationViewModel.dropOffTime ?? "")
                            .font(.system(size: 14,weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading,8)
            }
            .padding()
            
            Divider()
            
            Text("Suggested Rides")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(RideType.allCases) { rideType in
                        VStack(alignment: .leading){
                            Image(rideType.imageName)
                                .resizable()
                                .scaledToFit()
                            
                            VStack(alignment : .leading, spacing : 4){
                                Text(rideType.description)
                                    .font(.system(size: 14,weight: .semibold))
                    
                
                                Text((locationViewModel.computedPrice(for: rideType)).toCurrency())
                                    .font(.system(size: 14,weight: .semibold))
                            }
                            .padding()
                        }
                        .frame(width: 112,height: 140)
                        .background(Color(rideType == selectedRide ? .blue : .systemGroupedBackground))
                        .scaleEffect( rideType == selectedRide ? 1.2 : 1)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()){
                                selectedRide = rideType
                            }
                        }
                    
                    }
                }
                
            }
            .padding(.horizontal)
            Divider()
                .padding(.vertical,8)
            
            HStack{
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Text("**** 1234")
                    .fontWeight(.semibold)
                
                Spacer()
                  
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
                 
            }
            .frame(height: 50)
            .background(Color(.systemGroupedBackground))
            .cornerRadius(10)
            .padding(.horizontal)
            
            
            Button(action: {
                
            }, label: {
                Text("Confirm Ride")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32,height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            })
        }
        .padding(.bottom,24)
        .background(Color.theme.backgroundColor)
        .background(.white)
        .cornerRadius(10)
    }
}

#Preview {
    rideRequestedView()
}
