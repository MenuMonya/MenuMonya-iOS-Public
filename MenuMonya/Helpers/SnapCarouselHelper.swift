//
//  SnapCarouselHelper.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/25.
//

import SwiftUI
import UIKit

/// SwiftUI ScrollView에서 임베딩된 UIScrollView 가져오기
struct SnapCarouselHelper: UIViewRepresentable {
    @ObservedObject var viewModel: MainViewModel
   
    /// @Binding을 통해 ScrollView에서 필요한 프로퍼티들 가져오기
    var pageWidth: CGFloat
    @Binding var scrolledPageIndex: CGFloat
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            // uiView : 백그라운드, superview : 백그라운드 뷰, superview : 스크롤뷰 content 뷰, superview: UIScrollView
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.decelerationRate = .fast
                scrollView.delegate = context.coordinator
            }
        }
        
        if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: viewModel.selectedRestaurantIndex * pageWidth, y: 0), animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: SnapCarouselHelper
        init(parent: SnapCarouselHelper) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // print(scrollView.contentOffset.x)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            /// 완벽한 스크롤 애니메이션을 만들기 위해 velocity 추가
            let targetEnd = scrollView.contentOffset.x + (velocity.x * 60)
            let targetIndex = (targetEnd / parent.pageWidth).rounded()
            
            parent.viewModel.moveCameraToMarker(at: Int(targetIndex))
            targetContentOffset.pointee.x = targetIndex * parent.pageWidth
        }
    }
}

struct SnapCarouselHelper_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
