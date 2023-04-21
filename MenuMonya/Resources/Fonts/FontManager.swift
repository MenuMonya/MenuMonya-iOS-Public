//
//  FontManager.swift
//  ObjectOneShot
//
//  Created by 권승용 on 2023/04/14.
//

import SwiftUI

extension Font {
    enum Pretendard {
        case regular
        case medium
        case semiBold
        case bold
        case thin
        case custom(String)
        
        var value: String {
            switch self {
            case .regular:
                return "Pretendard-Regular"
            case .medium:
                return "Pretendard-Medium"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .bold:
                return "Pretendard-Bold"
            case .thin:
                return "Pretendard-Thin"
            case .custom(let name):
                return name
            }
        }
    }
    
    static func pretendard(_ type: Pretendard, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
}
