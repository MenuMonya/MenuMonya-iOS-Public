//
//  CardView.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var card: Card
    @Binding var isShowingMenuDetail: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if !(card.menu.date[viewModel.currentDateString]?["main"]?.isEmpty ?? true) {
                menus()
            } else {
                menuReportLink()
                    .padding(.top, 10)
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
            HStack(alignment: .top, spacing: 0) {
                Text("메인 메뉴")
                    .font(.pretendard(.semiBold, size: 12))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 70, alignment: .leading)
                    .padding(.bottom, 24)
                    .padding(.top, 10)
                Text((card.menu.date[viewModel.currentDateString]?["main"] ?? Menu.dummy.date[viewModel.currentDateString]!["main"])!)
                    .font(.pretendard(.regular, size: 12))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(2)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 10)
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
                Text((card.menu.date[viewModel.currentDateString]?["side"] ?? Menu.dummy.date[viewModel.currentDateString]!["side"])!)
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
                Text((card.menu.date[viewModel.currentDateString]?["dessert"] ?? Menu.dummy.date[viewModel.currentDateString]!["dessert"])!)
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
            Link(destination: URL(string: "https://open.kakao.com/o/gKPs3pif")!) {
                Image("button.reportMenu")
            }
            .padding(.vertical, 25)
            CustomDivider(color: Color("grey_200"))
            Text("메뉴는 매일 11시에 업데이트됩니다.")
                .font(.pretendard(.regular, size: 12))
                .padding(.vertical, 6)
            CustomDivider(color: Color("grey_200"))
        }
    }
    
    @ViewBuilder
    func details() -> some View {
        VStack(spacing: 5) {
            HStack(alignment: .top, spacing: 0) {
                Text(card.restaurant.name)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundColor(Color("grey_900"))
                Spacer()
                if !(card.menu.date[viewModel.currentDateString]?["main"]?.isEmpty ?? true) {
                    Button {
                        /* TODO - 자세히 보기 -> 가게 모달 생성? 또는 카드뷰 자체 탭 시 가게 모달 생성 */
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
                        Text("\(card.restaurant.price.cardPrice)원")
                            .font(.pretendard(.regular, size: 10))
                            .foregroundColor(Color("grey_900"))
                    }
                    HStack {
                        Text("점심 운영시간")
                            .font(.pretendard(.semiBold, size: 12))
                            .foregroundColor(Color("grey_900"))
                        Spacer()
                        Text("\(card.restaurant.time.openTime)~\(card.restaurant.time.closeTime)")
                            .font(.pretendard(.regular, size: 10))
                            .foregroundColor(Color("grey_900"))
                    }
                    HStack {
                        Text("전화번호")
                            .font(.pretendard(.semiBold, size: 12))
                            .foregroundColor(Color("grey_900"))
                        Spacer()
                        Text(card.restaurant.phoneNumber)
                            .font(.pretendard(.regular, size: 10))
                            .foregroundColor(Color("grey_900"))
                    }
                    HStack {
                        Text("위치")
                            .font(.pretendard(.semiBold, size: 12))
                            .foregroundColor(Color("grey_900"))
                        Spacer()
                        Text(card.restaurant.location.description)
                            .font(.pretendard(.regular, size: 10))
                            .foregroundColor(Color("grey_900"))
                    }
                }
                AsyncImage(url: URL(string: card.restaurant.imgUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 66, height: 66)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    ProgressView()
                        .frame(width: 66, height: 66)
                }
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(viewModel: MainViewModel(), card: .constant(Card.dummy), isShowingMenuDetail: .constant(false))
    }
}
