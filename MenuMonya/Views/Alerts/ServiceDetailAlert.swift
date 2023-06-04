//
//  ServiceDetailAlert.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/05/31.
//

import SwiftUI

struct ServiceDetailAlert: View {
    @Binding var isShowingServiceDetail: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isShowingServiceDetail = false
                }
            ServiceDetailAlertCard()
                .padding(.horizontal, 14)
        }
    }
}

struct ServiceDetailAlert_Previews: PreviewProvider {
    static var previews: some View {
        ServiceDetailAlert(isShowingServiceDetail: .constant(true))
    }
}
