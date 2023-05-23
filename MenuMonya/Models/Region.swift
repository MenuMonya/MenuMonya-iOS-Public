//
//  Region.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/05/23.
//

import Foundation

/// 지역 모델
struct Region: Codable, Identifiable {
    var id = UUID().uuidString
    var isSelected = false
    
    var name: String
    var latitude: Double
    var longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
    }
}
