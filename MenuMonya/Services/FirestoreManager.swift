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
    
    /// 식당 리스트 가져오기
    /// - Parameter completion: 컴플리션 핸들러
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
    
    /// 지역 리스트 가져오기
    /// - Parameter completion: 컴플리션 핸들러
    func fetchRegions(completion: @escaping([Region]) -> Void) {
        var regions = [Region]()
        
        let regionsCollection = db.collection("regions")
        regionsCollection
            .order(by: "regionId")
            .getDocuments { snapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let docs = snapshot?.documents else { return }
                for doc in docs {
                    do {
                        let region = try doc.data(as: Region.self)
                        regions.append(region)
                    }
                    catch {
                        print(error)
                    }
                }
                completion(regions)
            }
    }
    
    /// 제보 텍스트들 가져오기
    /// - Parameter completion: 컴플리션 핸들러
    func fetchMenuReportTexts(completion: @escaping([MenuReportText]) -> Void) {
        var menuReportTexts = [MenuReportText]()
        
        let menuReportTextsCollection = db.collection("menu-report-text")
        menuReportTextsCollection
            .getDocuments { snapshot, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let docs = snapshot?.documents else { return }
                for doc in docs {
                    do {
                        let menuReportText = try doc.data(as: MenuReportText.self)
                        menuReportTexts.append(menuReportText)
                    }
                    catch {
                        print(error)
                    }
                }
                completion(menuReportTexts)
            }
    }
    
    /// Remote Config에서 값 가져와 설정
    /// - Parameter completion: 컴플리션 핸들러
    func setupValueFromRemoteConfig(completion: @escaping(String?, String?) -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        /* TODO : 여기 강제 언래핑 말구 nil일때 예외처리 확실하게 하기! */
        remoteConfig.fetch() { (status, error) -> Void in
            if status == .success {
                remoteConfig.activate() { (changed, error) in
                    print(changed, error as Any)
                    let regionReportURL = remoteConfig["REGION_REPORT_URL"].stringValue
                    let menuReportURL = remoteConfig["REPORT_MENU_URL"].stringValue
                    completion(regionReportURL, menuReportURL)
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "No error available")")
            }
        }
    }
}
