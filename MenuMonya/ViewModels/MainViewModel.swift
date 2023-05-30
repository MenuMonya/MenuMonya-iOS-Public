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
    case selectedLocation
    case myLocation
}

class MainViewModel: ObservableObject {
    @Published var regions: [Region] = []
    @Published var restaurants: [Restaurant] = []
    @Published var restaurantsInSelectedRegion: [Restaurant] = []
    @Published var markers: [NMFMarker] = []
    @Published var markersInSelectedRegion: [NMFMarker] = []
    @Published var menuReportTexts: [MenuReportText] = []
    @Published var menuReportText: String = "오늘 메뉴 제보하기"
    
    @Published var locationSelection: LocationSelection = .selectedLocation
    @Published var selectedRegionIndex = 0
    @Published var selectedMarkerRestaurantID = ""
    @Published var selectedRestaurantIndex: CGFloat = 0
    @Published var currentDateString = ""
    @Published var currentDateKorean = ""
    @Published var surveyLink: URL?
    @Published var menuReportLink: URL?
    
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
    let selectedMarkerImageWhenNoMenu = NMFOverlayImage(name: "marker.restaurant.selected.nomenu")
    let markerImage = NMFOverlayImage(name: "marker.restaurant")
    let markerImageWhenNoMenu = NMFOverlayImage(name: "marker.restaurant.nomenu")
    
    init() {
        setCurrentDateString()
        setCurrentDateKorean()
        
        firestoreManager.fetchRegions { regions in
            self.regions = regions.map { $0 }
            
            // 식당 정보 fetch 후 card 모델에 담기
            self.firestoreManager.fetchRestaurants { restaurants in
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
        }
        
        firestoreManager.fetchMenuReportTexts { menuReportTexts in
            self.menuReportTexts = menuReportTexts.map { $0 }
            print(self.menuReportTexts)
        }
        
        firestoreManager.setupValueFromRemoteConfig { regionReportURL, menuReportURL in
            if let regionReportURL = regionReportURL {
                DispatchQueue.main.async {
                    self.surveyLink = URL(string: regionReportURL)
                }
            }
            
            if let menuReportURL = menuReportURL {
                DispatchQueue.main.async {
                    self.menuReportLink = URL(string: menuReportURL)
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
        
        // remote config 가져오기
        firestoreManager.setupValueFromRemoteConfig { regionReportURL, menuReportURL in
            if let regionReportURL = regionReportURL {
                DispatchQueue.main.async {
                    self.surveyLink = URL(string: regionReportURL)
                }
            }
            
            if let menuReportURL = menuReportURL {
                DispatchQueue.main.async {
                    self.menuReportLink = URL(string: menuReportURL)
                }
            }
        }
    }
    
    // MARK: - 지역 선택에 따라 마커, 식당 추가하기
    
    func setRestaurantsAnMarkersInSelectedRegion() {
        let regionName = self.regions[selectedRegionIndex].name
        
        restaurantsInSelectedRegion = []
        markersInSelectedRegion = []
        
        for marker in markers {
            marker.hidden = true
        }
        
        for index in restaurants.indices {
            if restaurants[index].locationCategory.contains(regionName) {
                restaurantsInSelectedRegion.append(restaurants[index])
                markersInSelectedRegion.append(markers[index])
            }
        }
        
        for marker in markersInSelectedRegion {
            marker.hidden = false
        }
    }
    
    // MARK: - 네이버 지도 관련 함수들
    
    func addMarkers() {
        DispatchQueue.main.async {
            for restaurant in self.restaurants {
                let marker = NMFMarker()
                marker.captionText = restaurant.name
                marker.iconImage = self.isShowingTodayMenu(of: restaurant) ? self.markerImage : self.markerImageWhenNoMenu
                marker.position = NMGLatLng(lat: Double(restaurant.location.coordination.latitude)!, lng: Double(restaurant.location.coordination.longitude)!)
                marker.isHideCollidedSymbols = true
                marker.mapView = self.mapView
                // 마커 터치 시 동작
                marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                    self?.selectedMarkerRestaurantID = restaurant.documentID!
                    self?.selectedRestaurantIndex = Double(Int((self?.restaurantsInSelectedRegion.firstIndex(where: { $0.documentID == restaurant.documentID })!)!))
                    self?.setMarkerImagesToDefault()
                    // 나만 selected 이미지로 보이기
                    marker.iconImage = self!.isShowingTodayMenu(of: restaurant) ? self!.selectedMarkerImage : self!.selectedMarkerImageWhenNoMenu
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
        
        for index in restaurants.indices {
            self.markers[index].iconImage = self.isShowingTodayMenu(of: restaurants[index]) ? markerImage : markerImageWhenNoMenu
        }
    }
    
    func setMarkerImageToSelected(at index: Int) {
        setMarkerImagesToDefault()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(60)) { [weak self] in
            if !self!.menuReportTexts.isEmpty {
                self!.menuReportText = self!.menuReportTexts.randomElement()?.description ?? "오늘 메뉴 제보하기"
            }
        }
        markersInSelectedRegion[index].iconImage = self.isShowingTodayMenu(of: restaurantsInSelectedRegion[index]) ? selectedMarkerImage : selectedMarkerImageWhenNoMenu
        markersInSelectedRegion[index].zIndex = 100
    }
    
    func moveCameraToMarker(at selectedIndex: Int) {
        if selectedIndex < markersInSelectedRegion.count && selectedIndex >= 0{
            let cameraUpdate = NMFCameraUpdate(scrollTo: self.markersInSelectedRegion[selectedIndex].position)
            cameraUpdate.animation = .easeOut
            cameraUpdate.pivot = CGPoint(x: 0.5, y: 0.35)
            self.markers[selectedIndex].mapView?.moveCamera(cameraUpdate)
        }
    }
    
    func moveCameraToLocation(at location: LocationSelection) {
        switch location {
        case .selectedLocation:
            let coordination = NMGLatLng(from: CLLocationCoordinate2D(latitude: regions[selectedRegionIndex].latitude, longitude: regions[selectedRegionIndex].longitude))
            let cameraupdate = NMFCameraUpdate(scrollTo: coordination, zoomTo: 14)
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
    
    // MARK: - Location Mode 변경 관련 함수들
    
    func setLocationModeToMyLocation() {
        mapView!.locationOverlay.hidden = false
        mapView!.positionMode = .direction
    }
    
    func setLocationModeToSelectedLocation() {
        mapView!.locationOverlay.hidden = true
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
    
    // MARK: - 내 위치 선택 시 나와 가까운 식당들만 선정
    func setRestaurantsNearMyLocation() {
        restaurantsInSelectedRegion = []
        markersInSelectedRegion = []
        
        for marker in markers {
            marker.hidden = true
        }
        
        print(locationManager.currentLocation)
        
        for index in restaurants.indices {
            // 내 위치에서 1000미터 이내 가게들 등록
            if restaurants[index].location.coordination.distance(from: locationManager.currentLocation) < 1000 {
                restaurantsInSelectedRegion.append(restaurants[index])
                markersInSelectedRegion.append(markers[index])
            }
        }
        
        for marker in markersInSelectedRegion {
            marker.hidden = false
        }
        
    }
}
