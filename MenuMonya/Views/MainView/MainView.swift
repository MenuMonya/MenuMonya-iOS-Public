//
//  MainView.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/21.
//

import SwiftUI

enum LocationSelection {
    case gangnam
    case yeoksam
    case myLocation
}

struct MainView: View {
    @State private var locationState: LocationSelection = .gangnam
    
    var body: some View {
        VStack(spacing: 0) {
            mainViewHeader()
            ZStack {
                /* TODO : 네이버 맵 뷰 구현 */
                Color.black
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            locationState = .myLocation
                        } label: {
                            if self.locationState == .myLocation {
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
    }
    
    @ViewBuilder
    func mainViewHeader() -> some View {
        HStack(spacing: 8) {
            Button {
                locationState = .gangnam
            } label: {
                if self.locationState == .gangnam {
                    Image("gangnam.enabled")
                } else {
                    Image("gangnam.disabled")
                }
            }
            .padding(.vertical, 8)
            .padding(.leading, 14)
            Button {
                locationState = .yeoksam
            } label: {
                if self.locationState == .yeoksam {
                    Image("yeoksam.enabled")
                } else {
                    Image("yeoksam.disabled")
                }
            }
            Spacer()
            Button {
                /* TODO : 피드백 버튼 터치 시 피드백 전송 화면 또는 모달로 이동 */
            } label: {
                Image("icon.feedback")
            }
            .padding(.trailing, 18)
        }
        .background(Color("background.header"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
