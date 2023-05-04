//
//  FireStoreViewModel.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/04/22.
//

import Combine
import Firebase
import FirebaseRemoteConfig

class FirestoreManager  {
    
    let db = Firestore.firestore()
   
    // 식당 리스트 가져오기
    func fetchRestaurants(completion: @escaping([Restaurant]) -> Void) {
        var restaurants = [Restaurant]()
        
        let restaruatnsCollection = db.collection("restaurants")
        restaruatnsCollection
            .order(by: "locationCategoryOrder")
            .getDocuments { snapshot, error in
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
    
    func setupValueFromRemoteConfig(completion: @escaping(String?) -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        /* TODO : 여기 강제 언래핑 말구 nil일때 예외처리 확실하게 하기! */
        remoteConfig.fetch() { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate() { (changed, error) in
                    print(changed, error as Any)
                    let resultValue = remoteConfig["FEEDBACK_URL_PROD"].stringValue
                    completion(resultValue)
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "No error available")")
            }
        }
    }
}
