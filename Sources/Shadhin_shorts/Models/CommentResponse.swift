//
//  CommentResponse.swift
//  Shadhin_shorts_Test
//
//  Created by Shadhin Music on 13/5/25.
//


import Foundation

// MARK: - Comment Response
struct CommentResponse: Codable {
    let message: String
    let success: Bool
    let responseCode: Int
    let title: String
    let data: [ShortsComment]
    let error: String?
}

// MARK: - Comment Model
struct ShortsComment: Codable {
    let commentId: Int
    let description: String
    var reactionCount: Int
    var replyCount: Int
    var isFavorite: Int
    let isMyComment: Bool
    let fullName: String
    let imageUrl: String
    let nextCursor: Int
    let createdAt: String
    let updatedAt: String?
    var isExpanded: Bool? = false
    var replies: [ShortsReply]? = []
}

// MARK: - Reply Response
struct ReplyResponse: Codable {
    let message: String
    let success: Bool
    let responseCode: Int
    let title: String
    let data: [ShortsReply]
    let error: String?
}

// MARK: - Reply Model
struct ShortsReply: Codable {
    var replyId: Int
    let description: String
    var reactionCount: Int
    var isFavorite: Int
    var isMyReply: Bool
    let fullName: String
    let imageUrl: String
    let createdAt: String
}

// MARK: - Like Response
struct LikeActionResponse: Codable {
    let message: String
    let success: Bool
    let responseCode: Int
    let title: String
    let data: LikeActionData
    let error: String?
}

// MARK: - Data Model
struct LikeActionData: Codable {
    let commentId: Int?
    let replyId: Int?
    let isLiked: Bool
    let usercode: String
}

// MARK: - Add ReplyComment Response
struct AddReplyCommentResponse: Codable {
    let message: String
    let success: Bool
    let responseCode: Int
    let title: String
    let data: ShortsReply
    let error: String?
}

// MARK: - Add Reply Data
struct AddReplyCommentData: Codable {
    let commentId: Int
    let description: String
    let usercode: String
    let fullName: String
    let imageUrl: String
}

// MARK: Add Comment Response
struct AddCommentResponse: Codable {
    let message: String
    let success: Bool
    let responseCode: Int
    let title: String
    let data: ShortsComment
    let error: String?
}
