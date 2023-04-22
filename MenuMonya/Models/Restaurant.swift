//
//  Restaurants.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Restaurant: Codable {
    @DocumentID var documentID: String?
    
    var imgUrl: String
    var location : Location
    var locationCategory: [String]
    var locationCategoryOrder: [String]
    var name: String
    var price: Price
    var time: OperatingTime
    var type: String
    var updatedTime: String
}

struct Location: Codable {
    var coordination: Coordination
    var description: String
    var name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coordination = try container.decode(Coordination.self, forKey: .coordination)
        self.description = try container.decode(String.self, forKey: .description)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    enum CodingKeys: String, CodingKey {
        case coordination = "coord"
        case description
        case name
    }
}

struct Coordination: Codable {
    var latitude: String
    var longitude: String
}

struct Price: Codable {
    var cardPrice: String
    var cashPrice: String
    var takeoutPrice: String
}

struct OperatingTime: Codable {
    var breakTime: String
    var closeTime: String
    var openTime: String
}
