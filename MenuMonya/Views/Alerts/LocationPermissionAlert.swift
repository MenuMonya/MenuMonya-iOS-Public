//
//  LocationPermissionAlert.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/29.
//

import SwiftUI

struct LocationPermissionAlert: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var isShowingLocationAlert: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                   isShowingLocationAlert = false
                }
            
            VStack {
                Spacer()
                LocationPermissionAlertCard(viewModel: viewModel, isShowingLocationAlert: $isShowingLocationAlert)
            }
            .padding(.bottom, 19)
        }
    }
}

struct LocationPermissionAlert_Previews: PreviewProvider {
    static var previews: some View {
        LocationPermissionAlert(viewModel: MainViewModel(), isShowingLocationAlert: .constant(false))
    }
}
