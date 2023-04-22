//
//  MainViewModel.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var menus: [Menu] = []
    
    let firestoreManager = FirestoreManager()
    
    init() {
        firestoreManager.fetchRestaurants { restaurants in
            self.restaurants = restaurants.map { $0 }
        }
        
        firestoreManager.fetchMenus { menus in
            self.menus = menus.map { $0 }
        }
    }
}
