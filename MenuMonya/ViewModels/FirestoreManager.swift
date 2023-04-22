//
//  FireStoreViewModel.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import Combine
import Firebase

class FirestoreManager  {
    
    let db = Firestore.firestore()
   
    // 식당 리스트 가져오기
    func fetchRestaurants(completion: @escaping([Restaurant]) -> Void) {
        var restaurants = [Restaurant]()
        
        let restaruatnsCollection = db.collection("restaurants")
        restaruatnsCollection.getDocuments { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            guard let docs = snapshot?.documents else { return }
            for doc in docs {
                do {
                    let restaurant = try doc.data(as: Restaurant.self)
                    restaurants.append(restaurant)
                }
                catch {
                    print(error)
                }
            }
            completion(restaurants)
        }
    }
    
    // 메뉴 리스트 가져오기
    func fetchMenus(completion: @escaping([Menu]) -> Void) {
        var menus = [Menu]()
        
        let menusCollection = db.collection("menus")
        menusCollection.getDocuments { snapshot, error in
            if let error = error {
                print(error)
                return
            }
            guard let docs = snapshot?.documents else { return }
            for doc in docs {
                do {
                    let menu = try doc.data(as: Menu.self)
                    menus.append(menu)
                }
                catch {
                    print(error)
                }
            }
            completion(menus)
        }
    }
}
