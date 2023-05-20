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

class MainViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var markers: [NMFMarker] = []
    
    @Published var locationSelection: LocationSelection = .gangnam
    @Published var selectedMarkerRestaurantID = ""
    @Published var selectedRestaurantIndex: CGFloat = 0
    @Published var currentDateString = ""
    @Published var currentDateKorean = ""
    @Published var surveyLink: URL?
    
    @Published var isFetchCompleted = false
    @Published var isMapViewInitiated = false
    @Published var isMarkersAdded = false
    @Published var isFocusedOnMarker = false
    @Published var isUpdatingCards = false
    @Published var isUpdateAvailableOnAppStore = false
    
    var mapView: NMFMapView?
    
    let firestoreManager = FirestoreManager()
    let locationManager = LocationManager()
    
    let selectedMarkerImage = NMFOverlayImage(name: "marker.restaurant.selected")
    let markerImage = NMFOverlayImage(name: "marker.restaurant")
    
    init() {
        
        setCurrentDateString()
        setCurrentDateKorean()
        
        // 식당 정보 fetch 후 card 모델에 담기
        firestoreManager.fetchRestaurants { restaurants in
            self.restaurants = restaurants.map { $0 }
            
            for i in 0..<self.restaurants.count {
                // 가격 포매팅
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                if let integerPrice = Int(self.restaurants[i].price.cardPrice) {
                    let myNumber = NSNumber(value: integerPrice)
                    let decimalPrice = numberFormatter.string(from: myNumber)
                    if let price = decimalPrice {
                        self.restaurants[i].price.cardPrice = price
                    }
                }
            }
            self.isFetchCompleted = true
        }
        
        firestoreManager.setupValueFromRemoteConfig { formURL in
            if let formURL = formURL {
                DispatchQueue.main.async {
                    self.surveyLink = URL(string: formURL)
                }
            }
        }
        
        // 스토어 업데이트 가능한지 확인
        _ = try? self.isUpdateAvailable { (update, error) in
            if let error = error {
                print(error)
            } else if let update = update {
                DispatchQueue.main.async {
                    self.isUpdateAvailableOnAppStore = update
                }
            }
        }
    }
    
    // MARK: - 업데이트 체크
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        print(currentVersion)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                completion(version > currentVersion, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
    
    func isShowingTodayMenu(of restaurant: Restaurant) -> Bool {
        if self.currentDateString == restaurant.todayMenu?.date ?? "-" && !(restaurant.todayMenu?.main.isEmpty ?? false) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - 날짜 포맷
    // 오늘 날짜로 dateString 변경
    func setCurrentDateString() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.currentDateString = dateFormatter.string(from: Date())
    }
    
    // 오늘 날짜 한글 표시
    func setCurrentDateKorean() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 (E요일)"
        self.currentDateKorean = dateFormatter.string(from: Date())
    }
    
    // MARK: - 메뉴 업데이트
    // 다시 실행할 때 마다 메뉴 업데이트
    func updateCardDatas() {
        isUpdatingCards = true
        setCurrentDateString()
        print("card update executed")
        /* TODO : 업데이트된 식단 명단도 반영 가능! -> card / 레스토랑 리스트 초기화 후 다시 받아오기? */
        // 식당 정보도 다시 불러와야 할까?
        // 일단 있는 식당만 찾아서 넣어주고, 추가된 식당은 생각하지 말자!
        firestoreManager.fetchRestaurants { restaurants in
            for restaurant in restaurants {
                if let index = self.restaurants.firstIndex(where: { $0.documentID == restaurant.documentID }) {
                    self.restaurants[index] = restaurant
                }
            }
            
            for i in 0..<self.restaurants.count {
                // 가격 포매팅
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                if let integerPrice = Int(self.restaurants[i].price.cardPrice) {
                    let myNumber = NSNumber(value: integerPrice)
                    let decimalPrice = numberFormatter.string(from: myNumber)
                    if let price = decimalPrice {
                        self.restaurants[i].price.cardPrice = price
                    }
                }
            }
            
            self.isUpdatingCards = false
        }
        
        firestoreManager.setupValueFromRemoteConfig { formURL in
            if let formURL = formURL {
                DispatchQueue.main.async {
                    self.surveyLink = URL(string: formURL)
                }
            }
        }
    }
    
    // MARK: - 네이버 지도 관련 함수들
    func addMarkers() {
        DispatchQueue.main.async {
            for restaurant in self.restaurants {
                let marker = NMFMarker()
                marker.captionText = restaurant.name
                marker.iconImage = self.markerImage
                marker.position = NMGLatLng(lat: Double(restaurant.location.coordination.latitude)!, lng: Double(restaurant.location.coordination.longitude)!)
                marker.isHideCollidedSymbols = true
                marker.mapView = self.mapView
                // 마커 터치 시 동작
                marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                    self?.selectedMarkerRestaurantID = restaurant.documentID!
                    self?.selectedRestaurantIndex = Double(Int((self?.restaurants.firstIndex(where: { $0.documentID == restaurant.documentID })!)!))
                    self?.setMarkerImagesToDefault()
                    // 나만 selected 이미지로 보이기
                    marker.iconImage = self!.selectedMarkerImage
                    marker.zIndex = 100
                    let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position)
                    cameraUpdate.animation = .easeOut
                    cameraUpdate.pivot = CGPoint(x: 0.5, y: 0.35)
                    marker.mapView!.moveCamera(cameraUpdate)
                    self?.isFocusedOnMarker = true
                    return true // 이벤트 소비, -mapView:didtTapMap:point 이벤트는 발생하지 않음
                }
                self.markers.append(marker)
            }
        }
    }
    
    func setMarkerZIndexesToDefault() {
        for marker in markers {
            marker.zIndex = 0
        }
    }
    
    func setMarkerImagesToDefault() {
        setMarkerZIndexesToDefault()
        for marker in markers {
            marker.iconImage = markerImage
        }
    }
    
    func setMarkerImageToSelected(at index: Int) {
        setMarkerImagesToDefault()
        markers[index].iconImage = selectedMarkerImage
        markers[index].zIndex = 100
    }
    
    func moveCameraToMarker(at selectedIndex: Int) {
        if selectedIndex < markers.count && selectedIndex >= 0{
            let cameraUpdate = NMFCameraUpdate(scrollTo: self.markers[selectedIndex].position)
            cameraUpdate.animation = .easeOut
            cameraUpdate.pivot = CGPoint(x: 0.5, y: 0.35)
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
            let coordination = mapView!.locationOverlay.location
            let cameraupdate = NMFCameraUpdate(scrollTo: coordination, zoomTo: 15)
            cameraupdate.pivot = CGPoint(x: 0.5, y: 0.35)
            cameraupdate.animation = .easeOut
            mapView?.moveCamera(cameraupdate)
        }
    }
    
    func setLocationModeToMyLocation() {
        mapView!.locationOverlay.hidden = false
        mapView!.positionMode = .direction
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
