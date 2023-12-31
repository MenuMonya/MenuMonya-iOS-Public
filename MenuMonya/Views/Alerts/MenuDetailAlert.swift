//
//  MenuDetailView.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/28.
//

import SwiftUI

struct MenuDetailAlert: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var isShowingMenuDetail: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isShowingMenuDetail = false
                }
            MenuAlertCard(viewModel: viewModel)
                .padding(.horizontal, 14)
        }
    }
}

struct MenuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetailAlert(viewModel: MainViewModel(), isShowingMenuDetail: .constant(false))
    }
}
