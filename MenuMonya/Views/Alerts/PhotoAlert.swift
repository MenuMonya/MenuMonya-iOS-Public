//
//  PhotoAlert.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/05/30.
//

import SwiftUI

struct PhotoAlert: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var isShowingRestaurantPhoto: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isShowingRestaurantPhoto = false
                }
            PhotoAlertCard(viewModel: viewModel)
                .padding(.horizontal, 14)
        }
    }
}

struct PhotoAlert_Previews: PreviewProvider {
    static var previews: some View {
        PhotoAlert(viewModel: MainViewModel(), isShowingRestaurantPhoto: .constant(true))
    }
}
