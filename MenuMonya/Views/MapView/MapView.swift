//
//  MapView.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/21.
//

import SwiftUI
import UIKit
import NMapsMap

struct MapView: View {
    var body: some View {
        UIMapView()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct UIMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17

        return view
    }

    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
}
