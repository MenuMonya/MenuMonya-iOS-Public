//
//  LocationPermissionAlertCard.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/29.
//

import SwiftUI

struct LocationPermissionAlertCard: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var isShowingLocationAlert: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Image("description.locationPermission")
                .frame(height: 48)
            HStack(spacing: 16) {
                Button {
                   isShowingLocationAlert = false 
                } label: {
                    Text("취소")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color("grey_600"))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                }
                .background(Color("grey_50"))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color("grey_300"), lineWidth: 1)
                )
                
                Button {
                    viewModel.requestLocationPermission()
                    isShowingLocationAlert = false
                } label: {
                    Text("동의")
                        .font(.pretendard(.regular, size: 14))
                        .foregroundColor(Color("background.cardview"))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 24)
                }
                .background(Color("primary.orange"))
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 30)
        .background(Color("background.cardview"))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct LocationPermissionAlertCard_Previews: PreviewProvider {
    static var previews: some View {
        LocationPermissionAlertCard(viewModel: MainViewModel(), isShowingLocationAlert: .constant(false))
    }
}
