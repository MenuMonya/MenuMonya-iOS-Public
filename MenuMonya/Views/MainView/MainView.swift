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
    @State var isShowingLocationAlert = false
    @State private var isPresentingAlert = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                mainViewHeader()
                    .padding(.top, 1)
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
                                        ForEach($viewModel.cards, id: \.self) { card in
                                            CardView(viewModel: viewModel, card: card, isShowingMenuDetail: $isShowingMenuDetail)
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
               
                }
            }
            if isShowingMenuDetail {
                MenuDetailAlert(viewModel: viewModel, isShowingMenuDetail: $isShowingMenuDetail)
            }
            if isShowingLocationAlert {
                LocationPermissionAlert(viewModel: viewModel, isShowingLocationAlert: $isShowingLocationAlert)
            }
        }
        .alert("현재 위치를 찾을 수 없습니다", isPresented: $isPresentingAlert, actions: {
            Button("닫기", role: .cancel, action: {})
            Button("설정", action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
        }, message: {
            Text("설정에서 위치 서비스를 켜 주세요")
        })
        .preferredColorScheme(.light)
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
            .padding(.vertical, 10)
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
            Link(destination: viewModel.surveyLink ?? URL(string: "https://bit.ly/3oDijQp")!) {
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
                    viewModel.isFocusedOnMarker = false
                    // 위치 정보 권한 설정하지 않았다면
                    let isLocationServiceEnabled = viewModel.isLocationServiceEnabled()
                    if !isLocationServiceEnabled {
                        // 팝업 띄우기
                        isShowingLocationAlert = true
                    // 위치 정보 권한 설정했다면
                    } else {
                        let isLocationPermissionAuthorized = viewModel.isLocationPermissionAuthorized()
                        // 위치 정보 권한이 있다면
                        if isLocationPermissionAuthorized {
                            viewModel.locationSelection = .myLocation
                            // 내 주변 식당 보여주기
                            // 1. 내 위치로 카메라 이동 및 내 위치 오버레이 <- 맵뷰에서 구현 완료
                            // 2. 가까운 순으로 레스토랑 정렬 <- ?
                        // 위치 정보 권한이 없다면
                        } else {
                            // 위치 정보 권한 요청 alert 띄우기
                            isPresentingAlert = true
                        }
                    }
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
