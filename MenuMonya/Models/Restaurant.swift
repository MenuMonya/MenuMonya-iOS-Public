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
    var phoneNumber: String
    var price: Price
    var time: OperatingTime
    var type: String
    var updatedTime: String
    
    static let dummy = Restaurant(imgUrl: "", location: Location.dummy, locationCategory: ["강남"], locationCategoryOrder: ["강남?"], name: "더미 식당", phoneNumber: "02-123-4567", price: Price.dummy, time: OperatingTime.dummy, type: "더미 식당 유형", updatedTime: "더미 식당 업데이트 시간")
}

struct Location: Codable {
    var coordination: Coordination
    var description: String
    var name: String
    
    init(coordination: Coordination, description: String, name: String) {
        self.coordination = coordination
        self.description = description
        self.name = name
    }
    
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
    
    static let dummy = Location(coordination: Coordination.dummy, description: "더미 로케이션 설명", name: "더미 로케이션 이름")
}

struct Coordination: Codable {
    var latitude: String
    var longitude: String
    
    static let dummy = Coordination(latitude: "37.498095", longitude: "127.027610")
}

struct Price: Codable {
    var cardPrice: String
    var cashPrice: String
    var takeoutPrice: String
    
    static let dummy = Price(cardPrice: "더미 카드가격", cashPrice: "더미 현금가격", takeoutPrice: "더미 포장가격")
}

struct OperatingTime: Codable {
    var breakTime: String
    var closeTime: String
    var openTime: String
    
    static let dummy = OperatingTime(breakTime: "더미 브레이크타임", closeTime: "더미 닫는시간", openTime: "더미 오픈시간")
}
