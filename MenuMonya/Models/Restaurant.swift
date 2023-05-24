//
//  Restaurants.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

/// 식당 모델
struct Restaurant: Codable, Hashable {
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        if lhs.documentID == rhs.documentID {
            return true
        } else {
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(documentID)
    }
    
    @DocumentID var documentID: String?
    
    var imgUrl: String
    var location : Location
    var locationCategory: [String]
    var locationCategoryOrder: [String]
    var name: String
    var phoneNumber: String
    var price: Price
    var time: OperatingTime
    var todayMenu: Menu?
    var type: String
    var updatedTime: String
    
    static let dummy = Restaurant(imgUrl: "", location: Location.dummy, locationCategory: ["강남"], locationCategoryOrder: ["강남?"], name: "더미 식당", phoneNumber: "02-123-4567", price: Price.dummy, time: OperatingTime.dummy, todayMenu: Menu.dummy, type: "더미 식당 유형", updatedTime: "더미 식당 업데이트 시간")
}

struct Menu: Codable {
    var date: String
    var main: String
    var side: String
    var dessert: String
    var provider: String
    var updatedTime: String
    
    static let dummy = Menu(date: "2023-05-19", main: "메인 메뉴 입니다", side: "사이드 메뉴 입니다", dessert: "후식 메뉴 입니다", provider: "엄지척 프로도", updatedTime: "2023-05-19 02:11:11")
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
    
    func distance(from location: CLLocation) -> CLLocationDistance {
        return CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!).distance(from: location)
    }
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
