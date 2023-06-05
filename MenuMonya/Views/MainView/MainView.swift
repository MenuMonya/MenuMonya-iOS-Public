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
    @AppStorage("lastRegionName") var lastRegionName: String = ""
    
    @StateObject var viewModel = MainViewModel()
    @State private var restaurantIndexWhenScrollEnded: CGFloat = 0
    @State var isShowingMenuDetail = false
    @State var isShowingLocationAlert = false
    @State var isShowingRestaurantPhoto = false
    @State var isShowingServiceDetail = false
    @State private var isPresentingLocationAlert = false
    @State private var currentIndex = 0
    @Environment(\.scenePhase) var scenePhase
    @GestureState var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Group {
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
                    .onChange(of: viewModel.isMarkersAdded) { isCompleted in
                        if isCompleted {
                            if let lastRegionIndex = viewModel.regions.firstIndex(where: { $0.name == lastRegionName }) {
                                viewModel.locationSelection = .selectedLocation
                                viewModel.regions[viewModel.selectedRegionIndex].isSelected = false
                                viewModel.regions[lastRegionIndex].isSelected = true
                                viewModel.selectedRegionIndex = lastRegionIndex
                                viewModel.setRestaurantsAndMarkersInSelectedRegion()
                                viewModel.moveCameraToLocation(at: .selectedLocation)
                            } else {
                                viewModel.locationSelection = .selectedLocation
                                viewModel.regions[viewModel.selectedRegionIndex].isSelected = true
                                viewModel.setRestaurantsAndMarkersInSelectedRegion()
                                viewModel.moveCameraToLocation(at: .selectedLocation)
                            }
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
            if isShowingRestaurantPhoto {
                PhotoAlert(viewModel: viewModel, isShowingRestaurantPhoto: $isShowingRestaurantPhoto)
            }
            if isShowingServiceDetail {
                ServiceDetailAlert(isShowingServiceDetail: $isShowingServiceDetail)
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.regions.indices, id: \.self) { index in
                    Button {
                        viewModel.locationSelection = .selectedLocation
                        viewModel.regions[viewModel.selectedRegionIndex].isSelected = false
                        viewModel.regions[index].isSelected = true
                        viewModel.selectedRegionIndex = index
                        viewModel.setRestaurantsAndMarkersInSelectedRegion()
                        viewModel.moveCameraToLocation(at: .selectedLocation)
                        viewModel.setMarkerImagesToDefault()
                        viewModel.isFocusedOnMarker = false
                        viewModel.setLocationModeToSelectedLocation()
                        lastRegionName = viewModel.regions[index].name
                    } label: {
                        if viewModel.regions[index].isSelected {
                            Text(viewModel.regions[index].name)
                                .font(.pretendard(.semiBold, size: 14))
                                .foregroundColor(Color("button.title.enabled"))
                                .padding(.vertical, 7)
                                .padding(.horizontal, 16)
                                .background {
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(Color("primary.orange"))
                                }
                        } else {
                            Text(viewModel.regions[index].name)
                                .font(.pretendard(.semiBold, size: 14))
                                .foregroundColor(Color("button.title.disabled"))
                                .padding(.vertical, 7)
                                .padding(.horizontal, 16)
                                .background {
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color("grey_300"), lineWidth: 1)
                                }
                        }
                    }
                }
                .padding(.vertical, 10)
                
                Link(destination: viewModel.surveyLink ?? URL(string: "https://bit.ly/3oDijQp")!) {
                    Text("지역건의")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundColor(Color("button.title.enabled"))
                        .padding(.vertical, 7)
                        .padding(.horizontal, 16)
                        .background {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(Color("secondary.sky"))
                        }
                }
            }
            .padding(.horizontal, 14)
        }
    }
    
    // 내 주변 버튼
    @ViewBuilder
    func myLocationButton() -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    viewModel.isFocusedOnMarker = false
                    viewModel.regions[viewModel.selectedRegionIndex].isSelected = false
                    viewModel.setMarkerImagesToDefault()
                    let isLocationServiceEnabled = viewModel.isLocationServiceEnabled()
                    if !isLocationServiceEnabled {
                        isShowingLocationAlert = true
                    } else {
                        let isLocationPermissionAuthorized = viewModel.isLocationPermissionAuthorized()
                        if isLocationPermissionAuthorized {
                            viewModel.locationSelection = .myLocation
                            viewModel.moveCameraToLocation(at: .myLocation)
                            viewModel.setLocationModeToMyLocation()
                            viewModel.setRestaurantsNearMyLocation()
                        } else {
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
                    ForEach($viewModel.restaurantsInSelectedRegion, id: \.self) { restaurant in
                        CardView(viewModel: viewModel, restaurant: restaurant, isShowingMenuDetail: $isShowingMenuDetail, isShowingRestaurantPhoto: $isShowingRestaurantPhoto, isShowingServiceDetails: $isShowingServiceDetail)
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
                                if currentIndex < (viewModel.restaurantsInSelectedRegion.count-1) {
                                    currentIndex += 1
                                }
                            } else {
                                let nextIndex = max(min(currentIndex + increment, viewModel.restaurantsInSelectedRegion.count - 1), 0)
                                currentIndex = nextIndex
                            }
                            viewModel.moveCameraToMarker(at: currentIndex)
                            viewModel.selectedRestaurantIndex = CGFloat(currentIndex)
                            viewModel.setRandomMenuReportText()
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
