//
//  MenuAlertCard.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/28.
//

import SwiftUI

struct MenuAlertCard: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomDivider(color: Color("grey_200"))
                .padding(.horizontal, 8)
            HStack(spacing: 6) {
                Text("메인 메뉴")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 80, alignment: .leading)
                Text((viewModel.cards[Int(viewModel.selectedRestaurantIndex)].menu.date[viewModel.currentDateString]?["main"] ?? Menu.dummy.date[viewModel.currentDateString]!["main"])!)
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(2)
                    .lineSpacing(15)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            CustomDivider(color: Color("grey_200"))
                .padding(.horizontal, 10)
            HStack(spacing: 6) {
                Text("사이드 메뉴")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 80, alignment: .leading)
                Text((viewModel.cards[Int(viewModel.selectedRestaurantIndex)].menu.date[viewModel.currentDateString]?["side"] ?? Menu.dummy.date[viewModel.currentDateString]!["side"])!)
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(2)
                    .lineSpacing(15)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            CustomDivider(color: Color("grey_200"))
                .padding(.horizontal, 10)
            HStack(spacing: 6) {
                Text("후식")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 80, alignment: .leading)
                Text((viewModel.cards[Int(viewModel.selectedRestaurantIndex)].menu.date[viewModel.currentDateString]?["dessert"] ?? Menu.dummy.date[viewModel.currentDateString]!["dessert"])!)
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(2)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            CustomDivider(color: Color("grey_200"))
                .padding(.horizontal, 10)
            HStack(spacing: 6) {
                Text("특이사항")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("secondary.sky"))
                    .frame(width: 80, alignment: .leading)
                Text("아직 디비에 특이사항이 없어요!")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(1)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            CustomDivider(color: Color("grey_200"))
                .padding(.horizontal, 10)
        }
        .padding(.vertical, 10)
        .background(Color("background.cardview"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct MenuAlertCard_Previews: PreviewProvider {
    static var previews: some View {
        MenuAlertCard(viewModel: MainViewModel())
    }
}
