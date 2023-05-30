//
//  FirstLoginAlert.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/05/23.
//

import SwiftUI

struct FirstLaunchAlert: View {
    @Binding var isFirstLaunch: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            FirstLaunchCard(isFirstLaunch: $isFirstLaunch)
                .padding(.horizontal, 14)
        }
    }
}

struct FirstLaunchAlert_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchAlert(isFirstLaunch: .constant(true))
    }
}
