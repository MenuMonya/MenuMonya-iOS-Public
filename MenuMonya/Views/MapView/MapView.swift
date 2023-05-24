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

struct NaverMapView: UIViewRepresentable {
    @ObservedObject var viewModel: MainViewModel
    
    @Binding var restaurantIndexWhenScrollEnded: CGFloat
    @State private var isFirstCameraUpdate = true
    @State var isMapViewInitiated = false
    @State var isMarkersAdded = false
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 15
        view.showCompass = true
        view.mapView.logoAlign = .leftTop
        view.showScaleBar = false
        
        view.mapView.touchDelegate = context.coordinator
        view.mapView.addCameraDelegate(delegate: context.coordinator)
        view.mapView.addOptionDelegate(delegate: context.coordinator)
        
        viewModel.mapView = view.mapView
        DispatchQueue.main.async {
            viewModel.isMapViewInitiated = true
        }
        
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        if viewModel.isFetchCompleted && viewModel.isMapViewInitiated && !viewModel.isMarkersAdded {
            viewModel.addMarkers()
            DispatchQueue.main.async {
                viewModel.isMarkersAdded = true
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
        var parent: NaverMapView
        
        init(_ parent: NaverMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            parent.viewModel.isFocusedOnMarker = false
            parent.viewModel.setMarkerImagesToDefault()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

