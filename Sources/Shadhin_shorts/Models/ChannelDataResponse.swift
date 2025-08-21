//
//  ChannelDataResponse.swift
//  Shadhin_shorts_Test
//
//  Created by Shadhin Music on 28/4/25.
//


import Foundation

// MARK: - ChannelDataResponse
struct ChannelDataResponse: Codable {
    let message: String
    let success: Bool
    let responseCode: Int
    let title: String
    let data: ChannelHeaderData?
    let error: String?
}

// MARK: - ChannelData
struct ChannelHeaderData: Codable {
    let id: Int
    let contentId: Int
    let contentType: String
    let imageUrl: String
    let streamingUrl: String
    let title: String
    let userCode: String
    let contentDuration: Int
    let reelsDuration: Int
    let startCursor: Int
    let endCursor: Int
    let routingContentId: Int
    let routingContentType: String
    let routingContentSubtype: String
    let analytics: ShortsAnalytics
    let isVerified: Bool
    let artists: [ShortsArtist]
    let socialMediaLinks: [SocialMediaLink]

    enum CodingKeys: String, CodingKey {
        case id, contentId, contentType, imageUrl, streamingUrl, title, userCode,
             contentDuration, reelsDuration, startCursor, endCursor,
             routingContentId, routingContentType, routingContentSubtype,
             analytics, isVerified, artists, socialMediaLinks
    }
}


// MARK: - Music Content Detials Data
struct MusicContentDetailsResponse: Codable {
    let message: String
    let success: Bool
    let responseCode: Int
    let title: String
    let data: MusicContentDetials
    let error: String?
}

struct MusicContentDetials: Codable {
    let id: Int
    let contentId: Int
    let contentType: String
    let contentTitle: String
    let routingContentId: Int
    let routingContentType: String
    let routingContentSubType: String
    let reelsCount: Int
    let contentImageUrl: String
    let contentDuration: Int
    let reelsDuration: Int
    let startCursor: Int
    let endCursor: Int
    let socialMediaLinks: [SocialMediaLink]
    let artists: [ShortsArtist]
    let contents: [ReelsContent]
    let nextCursor: Int
}
