//
//  CodingKeys.swift
//  Shadhin_shorts_Test
//
//  Created by Shadhin Music on 9/4/25.
//

import Foundation
import UIKit

// MARK: - ReelsContentModels
struct ForYouReelsResponse: Codable {
    let message: String?
    let success: Bool?
    let responseCode: Int?
    let title: String?
    let data: [ReelsContent]?
    let error: String?
}


// MARK: - PlayURLResponse

struct PlayURLResponse: Codable {
    let success: Bool
    let responseCode: Int
    let title: String
    let data: String?
    let error: String?
}


