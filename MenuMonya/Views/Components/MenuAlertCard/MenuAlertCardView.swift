//
//  MenuAlertCard.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/28.
//

import SwiftUI

struct MenuAlertCardView: View {
    var body: some View {
        VStack(spacing: 0) {
            CustomDivider(color: Color("grey_200"))
                .padding(.horizontal, 8)
            HStack(spacing: 6) {
                Text("메인 메뉴")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundColor(Color("primary.orange"))
                    .frame(width: 74, alignment: .leading)
                Text("메뉴입니다, 다다다다다다다, 미나얼, ㅁ니ㅏㅇ러 미나얼, 미나ㅓㄹㅇ, ㅁ니ㅏㅇ러, ㅁ니아러")
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
                    .frame(width: 74, alignment: .leading)
                Text("반찬 3종 & 김치, 계란")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(1)
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
                    .frame(width: 74, alignment: .leading)
                Text("매실차")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundColor(Color("dark_1"))
                    .lineLimit(1)
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
                    .frame(width: 74, alignment: .leading)
                Text("후우식이 있어요옹")
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
        MenuAlertCardView()
    }
}
