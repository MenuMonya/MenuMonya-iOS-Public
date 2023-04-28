//
//  MainView.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/21.
//

import SwiftUI
import FirebaseFirestore

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @State private var restaurantIndexWhenScrollEnded: CGFloat = 0
    @State var isShowingMenuDetail = false
    
    var body: some View {
        VStack(spacing: 0) {
            mainViewHeader()
            ZStack {
                NaverMapView(viewModel: viewModel, restaurantIndexWhenScrollEnded: $restaurantIndexWhenScrollEnded)
                    .ignoresSafeArea()
                    .zIndex((viewModel.isFocusedOnMarker ? 0 : 1))
                myLocationButton()
                    .zIndex((viewModel.isFocusedOnMarker ? 0 : 2))
                VStack {
                    Spacer()
                    GeometryReader {
                        let size = $0.size
                        let pageWidth: CGFloat = size.width
                        VStack {
                            Spacer()
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 0) {
                                    ForEach($viewModel.restaurants, id: \.documentID) { restaurant in
                                        CardView(restaurant: restaurant, isShowingMenuDetail: $isShowingMenuDetail)
                                    }
                                    .frame(width: pageWidth)
                                }
                                .padding(.horizontal, (size.width - pageWidth) / 2)
                                .background {
                                    SnapCarouselHelper(viewModel: viewModel, pageWidth: pageWidth, scrolledPageIndex: $restaurantIndexWhenScrollEnded)
                                }
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
                
                if isShowingMenuDetail {
                    MenuDetailView(isShowingMenuDetail: $isShowingMenuDetail)
                }
            }
        }
    }
    
    @ViewBuilder
    func mainViewHeader() -> some View {
        HStack(spacing: 8) {
            Button {
                viewModel.locationSelection = .gangnam
                viewModel.moveCameraToLocation(at: .gangnam)
                viewModel.isFocusedOnMarker = false
            } label: {
                if viewModel.locationSelection == .gangnam {
                    Image("gangnam.enabled")
                } else {
                    Image("gangnam.disabled")
                }
            }
            .padding(.vertical, 8)
            .padding(.leading, 14)
            Button {
                viewModel.locationSelection = .yeoksam
                viewModel.moveCameraToLocation(at: .yeoksam)
                viewModel.isFocusedOnMarker = false
            } label: {
                if viewModel.locationSelection == .yeoksam {
                    Image("yeoksam.enabled")
                } else {
                    Image("yeoksam.disabled")
                }
            }
            Spacer()
            Link(destination: URL(string: "https://forms.gle/Emcodxf3ngNqLCHs7")!) {
                Image("icon.feedback")
            }
            .padding(.trailing, 18)
        }
        .background(Color("background.header"))
    }
    
    // 내 주변 버튼
    @ViewBuilder
    func myLocationButton() -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    // 위치 정보가 켜져있다면
                    viewModel.isFocusedOnMarker = false
                } label: {
                    if viewModel.locationSelection == .myLocation {
                        Image("nearMe.enabled")
                    } else {
                        Image("nearMe.disabled")
                    }
                }
            }
            .padding(.trailing, 14)
            .padding(.top, 10)
            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
