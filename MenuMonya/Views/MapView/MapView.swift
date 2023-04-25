//
//  MapView.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/21.
//

import SwiftUI
import UIKit
import NMapsMap
import CoreLocation

enum LocationSelection {
    case gangnam
    case yeoksam
    case myLocation
}

struct MapView: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var locationSelection: LocationSelection
    @Binding  var selectedID: String
    
    var body: some View {
        UIMapView(locations: locationSelection, restaurants: viewModel.restaurants, selectedID: $selectedID)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct UIMapView: UIViewRepresentable {
    var locations: LocationSelection
    var restaurants: [Restaurant]
    var markers: [NMFMarker] = []
    
    @Binding var selectedID: String
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 15
        
        view.mapView.touchDelegate = context.coordinator
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        view.mapView.addOptionDelegate(delegate: context.coordinator)
        
        return view
    }

    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let coordination: NMGLatLng
        if locations == .gangnam {
            coordination = NMGLatLng(from: Constants.gangnamCoordinations)
        } else if locations == .yeoksam {
            coordination = NMGLatLng(from: Constants.yeoksamCoordinations)
        } else {
            // mylocation
            coordination = NMGLatLng(from: Constants.gangnamCoordinations)
        }
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordination, zoomTo: 15)
        
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)

        for restaurant in restaurants {
            addMarker(uiView, restaurant: restaurant)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
       
    }
    
    func addMarker(_ mapView: NMFNaverMapView, restaurant: Restaurant) {
        let marker = NMFMarker()
        marker.captionText = restaurant.name
        marker.iconImage = NMFOverlayImage(name: "marker.restaurant")
        marker.position = NMGLatLng(lat: Double(restaurant.location.coordination.latitude)!, lng: Double(restaurant.location.coordination.longitude)!)
        marker.mapView = mapView.mapView
        marker.userInfo = ["tag": restaurant.documentID as Any]
        
        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
            print("마커 터치")
            self.selectedID = restaurant.documentID!
            return true // 이벤트 소비, -mapView:didtTapMap:point 이벤트는 발생하지 않음
        }
    }
}
