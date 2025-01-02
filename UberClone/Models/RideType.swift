//
//  RideType.swift
//  UberClone
//
//  Created by Shubh Jain  on 29/12/24.
//

import Foundation
enum RideType : Int,CaseIterable,Identifiable {
    case uberX
    case black
    case uberXL
    
    var id: Int {return rawValue}
    
    
    var description : String {
        switch self {
        case .uberX : return "UberX"
        case .black : return "UberBlack"
        case .uberXL : return "UberXL"
            
        }
    }
    
    var imageName : String {
        switch self{
        case .uberX: return "uber-x"
        case .black: return "uber-black"
        case .uberXL: return "uber-x"
        }
    }
     
    var baseFare : Double {
        switch self {
        case .uberX: return 5
        case .black: return 20
        case .uberXL: return 10
        }
    }
    func computePrice(for distanceInMeters : Double) -> Double{
        let distanceInMiles = distanceInMeters / 1600
        
        switch self {
        case .uberX: return 1.5*distanceInMiles + baseFare
        case .black: return 2.0*distanceInMiles + baseFare
        case .uberXL: return 1.75*distanceInMiles + baseFare
        }
    }
    
}
