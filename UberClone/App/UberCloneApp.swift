//
//  UberCloneApp.swift
//  UberClone
//
//  Created by Shubh Jain  on 22/12/24.
//

import SwiftUI

@main
struct UberCloneApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    var body: some Scene {
        WindowGroup {
           HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
