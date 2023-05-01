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
        VStack {
            Spacer()
            VStack(spacing: 0) {
                if !(card.menu.date["2023-04-24"]?["main"]?.isEmpty ?? true) {
                    menus()
                }
                details()
            }
            .frame(width: UIScreen.main.bounds.width - 28)
            .background(Color("background.cardview"))
            .cornerRadius(10)
            .shadow(radius: 1)
        }
        .frame(maxHeight: 205)
    }
    
    @ViewBuilder
    func menus() -> some View {
        VStack {
            HStack(spacing: 0) {
                Text("메인 메뉴")
                    .font(.pretendard(.semiBold, size: 12))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 70, alignment: .leading)
                Text((card.menu.date["2023-04-24"]?["main"] ?? Menu.dummy.date["2023-04-24"]!["main"])!)
                    .font(.pretendard(.regular, size: 12))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(2)
                Spacer()
            }
            .padding(.top, 10)
            CustomDivider(color: Color("grey_200"))
            HStack(spacing: 0) {
                Text("사이드 메뉴")
                    .font(.pretendard(.semiBold, size: 12))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 70, alignment: .leading)
                Text((card.menu.date["2023-04-24"]?["side"] ?? Menu.dummy.date["2023-04-24"]!["side"])!)
                    .font(.pretendard(.regular, size: 12))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(1)
                Spacer()
            }
            CustomDivider(color: Color("grey_200"))
            HStack(spacing: 0) {
                Text("후식")
                    .font(.pretendard(.semiBold, size: 12))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 70, alignment: .leading)
                Text((card.menu.date["2023-04-24"]?["dessert"] ?? Menu.dummy.date["2023-04-24"]!["dessert"])!)
                    .font(.pretendard(.regular, size: 12))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(1)
                Spacer()
            }
            CustomDivider(color: Color("grey_200"))
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func details() -> some View {
        HStack(spacing: 8) {
            VStack(spacing: 5) {
                HStack {
                    Text(card.restaurant.name)
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundColor(Color("grey_900"))
                        .padding(.top, 10)
                    Spacer()
                }
                .padding(.bottom, 3)
                HStack {
                    Text("가격")
                        .font(.pretendard(.semiBold, size: 12))
                        .foregroundColor(Color("grey_900"))
                    Spacer()
                    Text(card.restaurant.price.cardPrice)
                        .font(.pretendard(.regular, size: 12))
                        .foregroundColor(Color("grey_900"))
                }
                HStack {
                    Text("점심 운영시간")
                        .font(.pretendard(.semiBold, size: 12))
                        .foregroundColor(Color("grey_900"))
                    Spacer()
                    Text("\(card.restaurant.time.openTime)~\(card.restaurant.time.closeTime)")
                        .font(.pretendard(.regular, size: 12))
                        .foregroundColor(Color("grey_900"))
                }
                HStack {
                    Text("전화번호")
                        .font(.pretendard(.semiBold, size: 12))
                        .foregroundColor(Color("grey_900"))
                    Spacer()
                    Text(card.restaurant.phoneNumber)
                        .font(.pretendard(.regular, size: 12))
                        .foregroundColor(Color("grey_900"))
                }
                HStack {
                    Text("위치")
                        .font(.pretendard(.semiBold, size: 12))
                        .foregroundColor(Color("grey_900"))
                    Spacer()
                    Text(card.restaurant.location.description)
                        .font(.pretendard(.regular, size: 12))
                        .foregroundColor(Color("grey_900"))
                }
            }
            VStack(alignment: .trailing, spacing: 8) {
                HStack {
                    Spacer()
                    if !(card.menu.date["2023-04-24"]?["main"]?.isEmpty ?? true) {
                        Button {
                            /* TODO - 자세히 보기 -> 가게 모달 생성? 또는 카드뷰 자체 탭 시 가게 모달 생성 */
                            isShowingMenuDetail = true
                        } label: {
                            Text("자세히 보기")
                                .font(.pretendard(.semiBold, size: 10))
                                .underline()
                                .foregroundColor(Color("grey_500"))
                        }
                        .padding(.top, 5)
                    }
                }
                AsyncImage(url: URL(string: card.restaurant.imgUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 66, height: 66)
                } placeholder: {
                    ProgressView()
                        .frame(width: 66, height: 66)
                }
            }
            .frame(width: 66)
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(viewModel: MainViewModel(), card: .constant(Card.dummy), isShowingMenuDetail: .constant(false))
    }
}
