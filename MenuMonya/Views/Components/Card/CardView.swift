//
//  CardView.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import SwiftUI

struct CardView: View {
    @Binding var restaurant: Restaurant
    @Binding var isShowingMenuDetail: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            menus()
            details()
        }
        .frame(width: UIScreen.main.bounds.width - 28)
        .background(Color("background.cardview"))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
    
    @ViewBuilder
    func menus() -> some View {
        VStack {
            HStack(spacing: 0) {
                Text("메인 메뉴")
                    .font(.pretendard(.semiBold, size: 10))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 70, alignment: .leading)
                Text("메뉴입니다")
                    .font(.pretendard(.regular, size: 10))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(2)
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
            CustomDivider(color: Color("grey_200"))
                .padding(.horizontal, 8)
            HStack(spacing: 0) {
                Text("사이드 메뉴")
                    .font(.pretendard(.semiBold, size: 10))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 70, alignment: .leading)
                Text("반찬 3종 & 김치, 계란")
                    .font(.pretendard(.regular, size: 10))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(1)
                Spacer()
            }
            .padding(.horizontal, 8)
            CustomDivider(color: Color("grey_200"))
                .padding(.horizontal, 8)
            HStack(spacing: 0) {
                Text("후식")
                    .font(.pretendard(.semiBold, size: 10))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 70, alignment: .leading)
                Text("매실차")
                    .font(.pretendard(.regular, size: 10))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(1)
                Spacer()
            }
            .padding(.horizontal, 8)
            CustomDivider(color: Color("grey_200"))
                .padding(.horizontal, 8)
        }
    }
    
    @ViewBuilder
    func details() -> some View {
        HStack(spacing: 8) {
            VStack(spacing: 5) {
                HStack {
                    Text(restaurant.name)
                        .font(.pretendard(.semiBold, size: 12))
                        .foregroundColor(Color("grey_900"))
                        .padding(.top, 10)
                    Spacer()
                }
                .padding(.bottom, 3)
                HStack {
                    Text("가격")
                        .font(.pretendard(.semiBold, size: 8))
                        .foregroundColor(Color("grey_900"))
                    Spacer()
                    Text(restaurant.price.cardPrice)
                        .font(.pretendard(.regular, size: 8))
                        .foregroundColor(Color("grey_900"))
                }
                HStack {
                    Text("점심 운영시간")
                        .font(.pretendard(.semiBold, size: 8))
                        .foregroundColor(Color("grey_900"))
                    Spacer()
                    Text("\(restaurant.time.openTime)~\(restaurant.time.closeTime)")
                        .font(.pretendard(.regular, size: 8))
                        .foregroundColor(Color("grey_900"))
                }
                HStack {
                    Text("전화번호")
                        .font(.pretendard(.semiBold, size: 8))
                        .foregroundColor(Color("grey_900"))
                    Spacer()
                    Text("아직 디비에 전번이 없어용~")
                        .font(.pretendard(.regular, size: 8))
                        .foregroundColor(Color("grey_900"))
                }
                HStack {
                    Text("위치")
                        .font(.pretendard(.semiBold, size: 8))
                        .foregroundColor(Color("grey_900"))
                    Spacer()
                    Text(restaurant.location.description)
                        .font(.pretendard(.regular, size: 8))
                        .foregroundColor(Color("grey_900"))
                }
            }
            VStack(alignment: .trailing, spacing: 5) {
                HStack {
                    Spacer()
                    Button {
                        /* TODO - 자세히 보기 -> 가게 모달 생성? 또는 카드뷰 자체 탭 시 가게 모달 생성 */
                        isShowingMenuDetail = true
                    } label: {
                        Text("자세히 보기")
                            .font(.pretendard(.semiBold, size: 7))
                            .underline()
                            .foregroundColor(Color("grey_500"))
                    }
                    .padding(.top, 5)
                }
                Image(systemName: "square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 66, height: 66)
            }
            .frame(width: 66)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(restaurant: .constant(Restaurant.dummy), isShowingMenuDetail: .constant(false))
    }
}
