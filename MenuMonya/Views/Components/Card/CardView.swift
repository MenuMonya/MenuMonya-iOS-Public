//
//  CardView.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var restaurant: Restaurant
    @Binding var isShowingMenuDetail: Bool
    @Binding var isShowingRestaurantPhoto: Bool
    @Binding var isShowingServiceDetails: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isShowingTodayMenu(of: restaurant) {
                menus()
            } else {
                menuReportLink()
            }
            details()
                .padding(.vertical, 10)
        }
        .padding(.horizontal, 10)
        .frame(width: UIScreen.main.bounds.width - 28)
        .background(Color("background.cardview"))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
    
    @ViewBuilder
    func menus() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(viewModel.currentDateKorean)
                    .font(.pretendard(.semiBold, size: 10))
                    .foregroundColor(Color("primary.date"))
                    .padding(.top, 10)
                Spacer()
                Text("제공해주신 분 : \(restaurant.todayMenu?.provider ?? "-")")
                    .font(.pretendard(.semiBold, size: 10))
                    .foregroundColor(Color("grey_500"))
                    .padding(.top, 10)
            }
            CustomDivider(color: Color("grey_200"))
                .padding(.bottom, 7)
                .padding(.top, 6)
            HStack(alignment: .top, spacing: 0) {
                Text("메인 메뉴")
                    .font(.pretendard(.semiBold, size: 12))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 70, alignment: .leading)
                    .padding(.bottom, 24)
                Text(restaurant.todayMenu?.main ?? "-")
                    .font(.pretendard(.regular, size: 12))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(2)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            CustomDivider(color: Color("grey_200"))
            HStack(alignment: .top, spacing: 0) {
                Text("사이드 메뉴")
                    .font(.pretendard(.semiBold, size: 12))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 70, alignment: .leading)
                    .padding(.bottom, 24)
                    .padding(.top, 6)
                Text(restaurant.todayMenu?.side ?? "-")
                    .font(.pretendard(.regular, size: 12))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(2)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 6)
                Spacer()
            }
            CustomDivider(color: Color("grey_200"))
            HStack(spacing: 0) {
                Text("후식")
                    .font(.pretendard(.semiBold, size: 12))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 70, alignment: .leading)
                    .padding(.vertical, 6)
                Text(restaurant.todayMenu?.dessert ?? "-")
                    .font(.pretendard(.regular, size: 12))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(1)
                Spacer()
            }
            CustomDivider(color: Color("grey_200"))
        }
    }
    
    @ViewBuilder
    func menuReportLink() -> some View {
        VStack(spacing: 0) {
            CustomDivider(color: Color("grey_200"))
                .padding(.top, 10)
            Link(destination: viewModel.menuReportLink ?? URL(string: "https://pf.kakao.com/_WFAyxj")!) {
                Text(viewModel.menuReportText)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(Color("button.title.enabled"))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 24)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color("primary.orange"))
                            .shadow(radius: 2)
                    }
            }
            .padding(.vertical, 29)
            CustomDivider(color: Color("grey_200"))
            HStack(spacing: 0) {
                if restaurant.menuAvailableOnline {
                    Text("메뉴는 평일 오전 11시에 업데이트됩니다")
                        .font(.pretendard(.regular, size: 12))
                        .padding(.vertical, 6)
                } else {
                    Text("해당 식당의 메뉴는 여러분의 제보로 업데이트됩니다")
                        .font(.pretendard(.regular, size: 12))
                        .padding(.vertical, 6)
                }
                Button {
                    isShowingServiceDetails = true
                    print("button tapped")
                } label: {
                    Image("icon.questionmark")
                }
            }
            CustomDivider(color: Color("grey_200"))
        }
    }
    
    @ViewBuilder
    func details() -> some View {
        VStack(spacing: 5) {
            HStack(alignment: .top, spacing: 0) {
                Text(restaurant.name)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundColor(Color("grey_900"))
                Spacer()
                if viewModel.isShowingTodayMenu(of: restaurant) {
                    Button {
                        isShowingMenuDetail = true
                    } label: {
                        Text("자세히 보기")
                            .font(.pretendard(.semiBold, size: 10))
                            .underline()
                            .foregroundColor(Color("grey_500"))
                    }
                }
            }
            HStack(spacing: 8) {
                VStack(spacing: 4) {
                    HStack(spacing: 0) {
                        Text("가격")
                            .font(.pretendard(.semiBold, size: 12))
                            .foregroundColor(Color("grey_900"))
                        Spacer()
                        Text("\(restaurant.price.cardPrice)원")
                            .font(.pretendard(.regular, size: 10))
                            .foregroundColor(Color("grey_900"))
                    }
                    HStack {
                        Text("점심 운영시간")
                            .font(.pretendard(.semiBold, size: 12))
                            .foregroundColor(Color("grey_900"))
                        Spacer()
                        Text("\(restaurant.time.openTime)~\(restaurant.time.closeTime)")
                            .font(.pretendard(.regular, size: 10))
                            .foregroundColor(Color("grey_900"))
                    }
                    HStack {
                        Text("전화번호")
                            .font(.pretendard(.semiBold, size: 12))
                            .foregroundColor(Color("grey_900"))
                        Spacer()
                        Text(restaurant.phoneNumber)
                            .font(.pretendard(.regular, size: 10))
                            .foregroundColor(Color("grey_900"))
                    }
                    HStack {
                        Text("위치")
                            .font(.pretendard(.semiBold, size: 12))
                            .foregroundColor(Color("grey_900"))
                        Spacer()
                        Text(restaurant.location.description)
                            .font(.pretendard(.regular, size: 10))
                            .foregroundColor(Color("grey_900"))
                    }
                }
                AsyncImage(url: URL(string: restaurant.imgUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .cornerRadius(8)
                        .onTapGesture {
                            viewModel.selectedPhotoURL = URL(string: restaurant.imgUrl)
                            isShowingRestaurantPhoto = true
                        }
                } placeholder: {
                    Image("default.restaurant")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(viewModel: MainViewModel(), restaurant: .constant(Restaurant.dummy), isShowingMenuDetail: .constant(false), isShowingRestaurantPhoto: .constant(false), isShowingServiceDetails: .constant(false))
    }
}
