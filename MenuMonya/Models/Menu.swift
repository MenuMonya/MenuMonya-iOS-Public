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
    
    var restaurantId: String
    var restaurantLocationCategory: [String]
    var restaurantName: String
    
    static let dummy = Menu(restaurantId: "", restaurantLocationCategory: ["강남"], restaurantName: "더미 식당")
}
