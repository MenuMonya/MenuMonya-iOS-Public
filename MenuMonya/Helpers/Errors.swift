//
//  Errors.swift
//  MenuMonya
//
//  Created by 권승용 on 2023/05/10.
//

import Foundation

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

enum Errors: Error {
    case noMenuMatchingID
}
