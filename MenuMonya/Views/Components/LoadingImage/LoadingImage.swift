//
//  LoadingImageLottie.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/05/03.
//

import Foundation
import SwiftUI
import Lottie
import UIKit

struct LoadingImage: UIViewRepresentable {
    var fileName: String
    
    func makeUIView(context: UIViewRepresentableContext<LoadingImage>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(fileName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LoadingImage>) {
    }
    
    typealias UIViewType = UIView
}
