//
//  MainViewModel.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import Foundation
import NMapsMap

enum LocationSelection {
    case gangnam
    case yeoksam
    case myLocation
}

class MainViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var menus: [Menu] = []
    @Published var markers: [NMFMarker] = []
    
    @Published var locationSelection: LocationSelection = .gangnam
    @Published var selectedMarkerRestaurantID = ""
    @Published var selectedRestaurantIndex: CGFloat = 0
    
    @Published var isFetchCompleted = false
    @Published var isMapViewInitiated = false
    @Published var isMarkersAdded = false
    
    var mapView: NMFMapView?
    
    let firestoreManager = FirestoreManager()
    
    init() {
        firestoreManager.fetchRestaurants { restaurants in
            self.restaurants = Array(restaurants.map { $0 }.prefix(8))
            self.isFetchCompleted = true
        }
        
        firestoreManager.fetchMenus { menus in
            self.menus = menus.map { $0 }
        }
    }
    
    func addMarkers() {
        DispatchQueue.main.async {
            for restaurant in self.restaurants {
                let marker = NMFMarker()
                marker.captionText = restaurant.name
                marker.iconImage = NMFOverlayImage(name: "marker.restaurant")
                marker.position = NMGLatLng(lat: Double(restaurant.location.coordination.latitude)!, lng: Double(restaurant.location.coordination.longitude)!)
                marker.mapView = self.mapView
                // 마커 터치 시 동작
                marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                    self?.selectedMarkerRestaurantID = restaurant.documentID!
                    self?.selectedRestaurantIndex = Double(Int((self?.restaurants.firstIndex(where: { $0.documentID == restaurant.documentID })!)!))
                    let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position)
                    cameraUpdate.animation = .easeOut
                    marker.mapView!.moveCamera(cameraUpdate)
                    return true // 이벤트 소비, -mapView:didtTapMap:point 이벤트는 발생하지 않음
                }
                self.markers.append(marker)
            }
        }
    }
    
    func moveCameraToMarker(at selectedIndex: Int) {
        if selectedIndex < markers.count && selectedIndex >= 0{
            let cameraUpdate = NMFCameraUpdate(scrollTo: self.markers[selectedIndex].position)
            cameraUpdate.animation = .easeOut
            self.markers[selectedIndex].mapView?.moveCamera(cameraUpdate)
        }
    }
    
    func moveCameraToLocation(at location: LocationSelection) {
        switch location {
        case .gangnam:
            let coordination = NMGLatLng(from: Constants.gangnamCoordinations)
            let cameraupdate = NMFCameraUpdate(scrollTo: coordination, zoomTo: 15)
            cameraupdate.animation = .easeOut
            mapView?.moveCamera(cameraupdate)
        case .yeoksam:
            let coordination = NMGLatLng(from: Constants.yeoksamCoordinations)
            let cameraupdate = NMFCameraUpdate(scrollTo: coordination, zoomTo: 15)
            cameraupdate.animation = .easeOut
            mapView?.moveCamera(cameraupdate)
        case .myLocation:
            let coordination = NMGLatLng(from: Constants.gangnamCoordinations)
            let cameraupdate = NMFCameraUpdate(scrollTo: coordination, zoomTo: 15)
            cameraupdate.animation = .easeOut
            mapView?.moveCamera(cameraupdate)
        }
    }
}
