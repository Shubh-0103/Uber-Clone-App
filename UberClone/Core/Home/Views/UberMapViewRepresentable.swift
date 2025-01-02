//
//  UberMapViewRepresentable.swift
//  UberClone
//
//  Created by Shubh Jain  on 23/12/24.
//

import SwiftUI
import MapKit

struct UberMapViewRepresentable : UIViewRepresentable {

    
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    
    @Binding var mapState : MapViewState
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    

    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print(mapState)
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            break;
        case .searchingForLocation:
            break;
        case .locationSelected:
            if let coordinate = locationViewModel.selectUberLocation?.coordinate {
                print(coordinate)
                context.coordinator.addSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withCoordinate: coordinate)
            }
            break;
        case .polyLineSelected:
            break
        }
    }
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}
extension UberMapViewRepresentable {
    class MapCoordinator : NSObject , MKMapViewDelegate{
        var userLocationCoordinate : CLLocationCoordinate2D?
        @Published var userLocation : CLLocationCoordinate2D?
        var currentRegion : MKCoordinateRegion?
        let parent : UberMapViewRepresentable
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
//            locationViewModel.userLocation = userLocationCoordinate
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
            self.parent.locationViewModel.userLocation = self.userLocationCoordinate
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
            let over = MKPolylineRenderer(overlay: overlay)
            over.strokeColor = .systemBlue
            over.lineWidth = 6
            return over
        }
        
        
        func addSelectAnnotation(withCoordinate coordinate : CLLocationCoordinate2D){
            self.parent.mapView.removeAnnotations(parent.mapView.annotations)
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
            
           // self.parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func configurePolyline (withCoordinate coordinate : CLLocationCoordinate2D){
            self.parent.mapView.removeOverlays(parent.mapView.overlays)
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate){ route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polyLineSelected
               // self.parent.mapView.userTrackingMode = .none
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
      
        
        func clearMapViewAndRecenterOnUserLocation(){
            self.parent.mapView.removeAnnotations(parent.mapView.annotations)
            self.parent.mapView.removeOverlays(parent.mapView.overlays)
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}
