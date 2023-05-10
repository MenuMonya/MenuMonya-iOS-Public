//
//  Menu.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Menu: Codable {
    @DocumentID var documentID: String?
    
    var date: [String: [String : String]]
    var restaurantId: String
    var restaurantLocationCategory: [String]
    var restaurantName: String
    
    static let dummy = Menu(date: [ "2023-04-24": ["dessert" : "디저트 메뉴 입니다", "main" : "메인 입니다", "side": "사이드 입니다"]], restaurantId: "", restaurantLocationCategory: ["강남"], restaurantName: "더미 식당")
}
