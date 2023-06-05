//
//  FirstLaunchCard.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/05/23.
//

import SwiftUI

struct FirstLaunchCard: View {
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Image("description.firstLaunch")
                .padding(.top, 18)
            Button {
                isFirstLaunch = false
            } label: {
                Image("button.complete")
            }
            .padding(.horizontal, 105)
            .padding(.bottom, 18)
        }
        .padding(.horizontal, 30)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("background.cardview"))
                .shadow(radius: 10)
                .aspectRatio(CGSize(width: 300, height: 124), contentMode: .fit)
        }
    }
}

struct FirstLaunchCard_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchCard(isFirstLaunch: .constant(true))
    }
}
