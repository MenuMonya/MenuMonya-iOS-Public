//
//  MenuDetailView.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/28.
//

import SwiftUI

struct MenuDetailView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.75)
                .edgesIgnoringSafeArea(.all)
            MenuAlertCardView()
                .padding(.horizontal, 14)
        }
    }
}

struct MenuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetailView()
    }
}
