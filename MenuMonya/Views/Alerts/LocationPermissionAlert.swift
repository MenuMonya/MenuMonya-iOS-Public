//
//  LocationPermissionAlert.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/29.
//

import SwiftUI

struct LocationPermissionAlert: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    
                }
            
            VStack {
                Spacer()
                LocationPermissionAlertCard()
            }
            .padding(.bottom, 19)
        }
    }
}

struct LocationPermissionAlert_Previews: PreviewProvider {
    static var previews: some View {
        LocationPermissionAlert()
    }
}
