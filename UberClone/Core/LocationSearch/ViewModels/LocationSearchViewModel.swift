//
//  LocationSearchViewModel.swift
//  UberClone
//
//  Created by Shubh Jain  on 26/12/24.
//

import Foundation
import MapKit

class LocationSearchViewModel : NSObject,ObservableObject {
    @Published var results = [MKLocalSearchCompletion]()
    
    @Published var selectUberLocation : UberLocation?
    @Published var pickupTime : String?
    @Published var dropOffTime: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment : String = "" {
        didSet{
            searchCompleter.queryFragment = queryFragment
        }
    }
    var userLocation : CLLocationCoordinate2D?
    
    override init(){
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    func selectLocation( _ localSearch: MKLocalSearchCompletion){
        locationSearch(forLocalSearchCompletion: localSearch ){ response , error in
            guard let item = response?.mapItems.first else{return}
            let coordinate = item.placemark.coordinate
            self.selectUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
            print(coordinate)
            print("user :\(self.userLocation)")
        }
    }
    func locationSearch(forLocalSearchCompletion localSearch :MKLocalSearchCompletion , completion: @escaping MKLocalSearch.CompletionHandler ){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computedPrice(for type : RideType)->Double {
        guard let destcordinate = selectUberLocation?.coordinate  else{ return 0.0}
        guard let userCordinate = self.userLocation else {return 0.0}
        
        let userLocation = CLLocation(latitude: userCordinate.latitude, longitude: userCordinate.longitude)
        let destinationLocation = CLLocation(latitude: destcordinate.latitude, longitude: destcordinate.longitude)
                
        let tripDistanceInMeter = userLocation.distance(from: destinationLocation)
        return type.computePrice(for: tripDistanceInMeter)
    }
    
    func getDestinationRoute (from userLocation : CLLocationCoordinate2D , to destinationLocation : CLLocationCoordinate2D , completion: @escaping(MKRoute)-> Void ){
        let userPlaceMark = MKPlacemark(coordinate: userLocation)
        let destPlaceMark = MKPlacemark(coordinate: destinationLocation)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlaceMark)
        request.destination = MKMapItem(placemark: destPlaceMark)
        let direction = MKDirections(request: request)
        direction.calculate { response , error in
            if let error = error {
                print(error)
                return
            }
            guard let route = response?.routes.first else {return}
            self.configurePickUpandDropOff(with: route.expectedTravelTime)
            completion(route)
        }
    }
    func configurePickUpandDropOff(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
        
    }
    
}
extension LocationSearchViewModel : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
