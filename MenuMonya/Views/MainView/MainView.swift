//
//  MainView.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/21.
//

import SwiftUI
import FirebaseFirestore

struct MainView: View {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @StateObject var viewModel = MainViewModel()
    @State private var restaurantIndexWhenScrollEnded: CGFloat = 0
    @State var isShowingMenuDetail = false
    @State var isShowingLocationAlert = false
    @State private var isPresentingLocationAlert = false
    @State private var currentIndex = 0
    @Environment(\.scenePhase) var scenePhase
    @GestureState var dragOffset: CGFloat = 0
    
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
                    restaurantCardScrollView()
                }
            }
            if isShowingMenuDetail {
                MenuDetailAlert(viewModel: viewModel, isShowingMenuDetail: $isShowingMenuDetail)
            }
            if isShowingLocationAlert {
                LocationPermissionAlert(viewModel: viewModel, isShowingLocationAlert: $isShowingLocationAlert)
            }
            if isFirstLaunch {
                FirstLaunchAlert(isFirstLaunch: $isFirstLaunch)
            }
            if viewModel.isUpdatingCards {
                LoadingView()
            }
        }
        .alert("새로운 버전으로 업데이트가 가능합니다", isPresented: $viewModel.isUpdateAvailableOnAppStore, actions: {
            Button("닫기", role: .cancel, action: {})
            Button("스토어로 이동", action: {
                if let url = URL(string: "https://apple.co/3nOuASc") {
                    UIApplication.shared.open(url)
                }
            })
        })
        .alert("현재 위치를 찾을 수 없습니다", isPresented: $isPresentingLocationAlert, actions: {
            Button("닫기", role: .cancel, action: {})
            Button("설정", action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
        }, message: {
            Text("설정에서 위치 서비스를 켜 주세요")
        })
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                break
            case .active:
                if viewModel.isMarkersAdded {
                    viewModel.updateCardDatas()
                }
                break
            case .inactive:
                break
            @unknown default:
                break
            }
        }
        .preferredColorScheme(.light)
    }
    
    @ViewBuilder
    func mainViewHeader() -> some View {
        HStack(spacing: 8) {
            Button {
                viewModel.locationSelection = .gangnam
                viewModel.moveCameraToLocation(at: .gangnam)
                viewModel.isFocusedOnMarker = false
                viewModel.setMarkerImagesToDefault()
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
                viewModel.setMarkerImagesToDefault()
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
                    viewModel.setMarkerImagesToDefault()
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
                            viewModel.setLocationModeToMyLocation()
                            viewModel.moveCameraToLocation(at: .myLocation)
                            // 내 주변 식당 보여주기
                            // 1. 내 위치로 카메라 이동 및 내 위치 오버레이 <- 맵뷰에서 구현 완료
                            // 2. 가까운 순으로 레스토랑 정렬 <- ?
                            // 위치 정보 권한이 없다면
                        } else {
                            // 위치 정보 권한 요청 alert 띄우기
                            isPresentingLocationAlert = true
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
    
    @ViewBuilder
    func restaurantCardScrollView() -> some View {
        let spacing: CGFloat = 6
        let visibleEdgeSpace: CGFloat = 8
        GeometryReader { proxy in
            let baseOffset: CGFloat = spacing + visibleEdgeSpace
            let pageWidth: CGFloat = UIScreen.main.bounds.width - (visibleEdgeSpace + spacing) * 2
            let offsetX: CGFloat = baseOffset + CGFloat(currentIndex) * -pageWidth + CGFloat(currentIndex) * -spacing + dragOffset
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 6) {
                    ForEach($viewModel.restaurants, id: \.self) { restaurant in
                        CardView(viewModel: viewModel, restaurant: restaurant, isShowingMenuDetail: $isShowingMenuDetail)
                            .frame(width: pageWidth)
                            .padding(.bottom, 14)
                    }
                }
                .offset(x: offsetX)
                .highPriorityGesture(
                    DragGesture()
                        .updating($dragOffset, body: { value, out, _ in
                            out = value.translation.width
                        })
                        .onEnded { value in
                            let offsetX = value.translation.width
                            let progress = -offsetX / pageWidth
                            let increment = Int(progress.rounded())
                            
                            // 드래그 velocity 계산
                            if value.predictedEndLocation.x - value.location.x > 50 {
                                // 왼쪽 스냅
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                }
                            } else if value.predictedEndLocation.x - value.location.x < -50 {
                                // 오른쪽 스냅
                                if currentIndex < (viewModel.restaurants.count-1) {
                                    currentIndex += 1
                                }
                            } else {
                                currentIndex = max(min(currentIndex + increment, viewModel.restaurants.count - 1), 0)
                            }
                            viewModel.moveCameraToMarker(at: currentIndex)
                            viewModel.selectedRestaurantIndex = CGFloat(currentIndex)
                            viewModel.setMarkerImageToSelected(at: currentIndex)
                        }
                )
                .animation(.easeOut, value: currentIndex)
                .animation(.easeOut, value: dragOffset)
                .onChange(of: viewModel.selectedRestaurantIndex) { newValue in
                    currentIndex = Int(newValue)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
