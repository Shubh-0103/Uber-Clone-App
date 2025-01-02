//
//  LocationSearchResultCell.swift
//  UberClone
//
//  Created by Shubh Jain  on 26/12/24.
//

import SwiftUI

struct LocationSearchResultCell: View {
    let title : String
    let subTitle : String
    var body: some View {
        HStack{
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(.blue)
                .frame(width: 40,height: 40)
                .accentColor(.white)
            VStack(alignment:.leading,spacing: 4){
                Text(title)
                    .font(.body)
                Text(subTitle)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
             Divider()
                
            }
            .padding(.leading,8)
            .padding(.vertical,8)
        }
        .padding(.leading)
    }
}

#Preview {
    LocationSearchResultCell(title: "Starbucks", subTitle: "123 Main St")
}
