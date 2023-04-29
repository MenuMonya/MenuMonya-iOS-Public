//
//  Card.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/29.
//

import Foundation

struct Card : Hashable, Identifiable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        if lhs.restaurant.documentID == rhs.restaurant.documentID && lhs.menu.documentID == rhs.menu.documentID {
            return true
        } else {
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    var id = UUID().uuidString
    var restaurant: Restaurant
    var menu: Menu
    
    static let dummy = Card(restaurant: Restaurant.dummy, menu: Menu.dummy)
}
