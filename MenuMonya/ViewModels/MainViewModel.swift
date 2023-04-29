//
//  MainViewModel.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import Foundation
import NMapsMap
import CoreLocation

enum LocationSelection {
    case gangnam
    case yeoksam
    case myLocation
}

enum Errors: Error {
    case noMenuMatchingID
}

class MainViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var markers: [NMFMarker] = []
    var restaurants: [Restaurant] = []
    
    @Published var locationSelection: LocationSelection = .gangnam
    @Published var selectedMarkerRestaurantID = ""
    @Published var selectedRestaurantIndex: CGFloat = 0
    
    @Published var isFetchCompleted = false
    @Published var isMapViewInitiated = false
    @Published var isMarkersAdded = false
    @Published var isFocusedOnMarker = false
    
    var mapView: NMFMapView?
    
    let firestoreManager = FirestoreManager()
    let locationManager = LocationManager()
    
    init() {
        // 식당 정보 fetch 후 card 모델에 담기
        firestoreManager.fetchRestaurants { restaurants in
            self.restaurants = restaurants.map { $0 }
            for restaurant in restaurants {
                self.cards.append(Card(restaurant: restaurant, menu: Menu.dummy))
            }
            self.isFetchCompleted = true
            
            // 메뉴 정보 fetch 후 card 모델에 담기
            self.firestoreManager.fetchMenus { menus in
                for i in 0..<self.cards.count {
                    self.cards[i].menu = menus.first(where: { $0.restaurantId == self.cards[i].restaurant.documentID })!
                }
            }
            
            // 이제 card 모델에는 서로 같은 인덱스에 식당과 메뉴정보가 함께 있음
        }
    }
    
    // MARK: - 네이버 지도 관련 함수들
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
                    self?.isFocusedOnMarker = true
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
   
    // MARK: - 위치 서비스 관련 함수들
    func isLocationServiceEnabled() -> Bool {
        return locationManager.isLocationServiceEnabled()
    }
    
    func isLocationPermissionAuthorized() -> Bool {
        return locationManager.isLocationPermissionAuthorized()
    }
    
    func requestLocationPermission() {
        locationManager.requestUserAuthorization()
    }
    
}
