//
//  ServiceDetailAlertCard.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/05/31.
//

import SwiftUI

struct ServiceDetailAlertCard: View {
    var body: some View {
        // Image로 서비스 디테일 문구 들어감
        Image("description.serviceDetail")
            .padding(.vertical, 21)
            .padding(.horizontal, 17)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
            }
    }
}

struct ServiceDetailAlertCard_Previews: PreviewProvider {
    static var previews: some View {
        ServiceDetailAlertCard()
    }
}
