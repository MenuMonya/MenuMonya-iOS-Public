//
//  PhotoAlertCard.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/05/30.
//

import SwiftUI

struct PhotoAlertCard: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        AsyncImage(url: viewModel.selectedPhotoURL) { image in
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
                .padding(.horizontal, 14)
        } placeholder: {
            LoadingImage(fileName: "Loading.json")
                .frame(width: 200, height: 200)
        }
    }
}

struct PhotoAlertCard_Previews: PreviewProvider {
    static var previews: some View {
        PhotoAlertCard(viewModel: MainViewModel())
    }
}
