//
//  APIService.swift
//  Shadhin_shorts
//
//  Created by Maruf on 7/4/25.
//

import Foundation

public class ShadhinShortsApi {
    
    // MARK: - Properties
    static let shared = ShadhinShortsApi()
    static let BASE_URL = "https://connect.shadhinmusic.com/api/v1"
    static let REELS_BASE_URL = "https://connect.shadhinmusic.com/api/v1/reels"
    let GET_AUDIO_PATCH_DETAILS = "\(REELS_BASE_URL)/contents-by-patch?id=0"
    let GET_AUDIO_FOR_YOUR_REELS = "\(REELS_BASE_URL)/for-you"
    let ANALYTICS_GET_URL = "\(REELS_BASE_URL)/misc/analytics-count"
    let FAVORITES_COMMON_URL = "\(REELS_BASE_URL)/favorites"
    let SURVEY_URL = "\(REELS_BASE_URL)/user-activities/surveys"
    let GET_ALL_COMMENTS_URL = "\(REELS_BASE_URL)/comments"
    let GET_ALL_REPLIES_URL = "\(REELS_BASE_URL)/comment/replies"
    let ADD_COMMENT_URL = "\(REELS_BASE_URL)/comment"
    let ADD_REPLIES_URL = "\(REELS_BASE_URL)/comment/reply"
    let ADD_FAV_COMMENT_URL = "\(REELS_BASE_URL)/comment/reaction"
    
    // MARK: - Methods
    func getAudioReelsContents(
        completion : @escaping (ReelsResponseObject?, Error?) -> Void)
    {
        AF.request(
            GET_AUDIO_PATCH_DETAILS,
            method: .get,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .responseDecodable(of: ReelsResponseObject.self){ response in
            switch response.result{
            case let .success(data):
                completion(data,nil)
            case .failure(_):
                let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "experiencing technical problems now which will be fixed soon.Thanks for your patience."])
                completion(nil,error)
                print(response.error?.localizedDescription as Any)
                
            }
        }
    }
    
    func getChannelHeaderData(contentType: String,
                              id: Int,
                              completion :
                              @escaping (ChannelDataResponse?, Error?) -> Void) {
        AF.request(
            "\(ShadhinShortsApi.REELS_BASE_URL)/content-by-type?type=\(contentType)&id=\(id)",
            method: .get,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .responseDecodable(of: ChannelDataResponse.self) { response in
            switch response.result{
            case let .success(data):
                completion(data, nil)
            case .failure(_):
                let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "experiencing technical problems now which will be fixed soon.Thanks for your patience."])
                completion(nil,error)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    func getMusicContentDetailsData(contentId: Int,
                                    contentType: String,
                                    nextCursor: Int,
                                    pageSize: Int,
                                    completion:
                                    @escaping (MusicContentDetailsResponse?, Error?) -> Void) {
        AF.request(
            "\(ShadhinShortsApi.REELS_BASE_URL)/contents?contentId=\(contentId)&contentType=\(contentType)&nextCursor=\(nextCursor)&pageSize=\(pageSize)",
            method: .get,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .responseDecodable(of: MusicContentDetailsResponse.self) { response in
            switch response.result{
            case let .success(data):
                completion(data, nil)
            case .failure(_):
                let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "experiencing technical problems now which will be fixed soon.Thanks for your patience."])
                completion(nil,error)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    func getAnalyticsCount(id: Int,
                           contentType: String,
                           completion:
                           @escaping (AnalyticsResponse?, Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "contents": [
                [
                    "id": id,
                    "contentType": contentType
                ]
            ]
        ]
        
        AF.request(
            ANALYTICS_GET_URL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .responseDecodable(of: AnalyticsResponse.self) { response in
            switch response.result{
            case let .success(data):
                completion(data, nil)
            case .failure(_):
                let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "experiencing technical problems now which will be fixed soon.Thanks for your patience."])
                completion(nil,error)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    func getForYouAudioRellsContents(
        completion : @escaping (ForYouReelsResponse?, Error?) -> Void)
    {
        AF.request(
            GET_AUDIO_FOR_YOUR_REELS,
            method: .get,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .responseDecodable(of: ForYouReelsResponse.self){ response in
            switch response.result{
            case let .success(data):
                completion(data, nil)
            case .failure(_):
                let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "experiencing technical problems now which will be fixed soon.Thanks for your patience."])
                completion(nil,error)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    func getAllFavoriteData(completion:
                            @escaping (FavoriteResponse?, Error?) -> Void) {

        AF.request(
            FAVORITES_COMMON_URL,
            method: .get,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .responseDecodable(of: FavoriteResponse.self){ response in
            switch response.result{
            case let .success(data):
                completion(data, nil)
            case .failure(_):
                let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "experiencing technical problems now which will be fixed soon.Thanks for your patience."])
                completion(nil,error)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    func favoriteAddData(id: Int,
                         contentType: String,
                         completion: @escaping ([String: Any]?, Error?) -> Void) {

        let parameters: [String: Any] = [
            "contentId": id,
            "contentType": contentType
        ]

        AF.request(
            FAVORITES_COMMON_URL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        completion(json, nil)
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    let error = NSError(domain: "", code: 500, userInfo: [
                        NSLocalizedDescriptionKey: "Empty response data."
                    ])
                    completion(nil, error)
                }
            case .failure(let afError):
                completion(nil, afError)
            }
        }
    }

    func favoriteDeleteData(id: Int,
                            contentType: String,
                            completion: @escaping ([String: Any]?, Error?) -> Void) {

        let parameters: [String: Any] = [
            "contentId": id,
            "contentType": contentType
        ]

        AF.request(
            FAVORITES_COMMON_URL,
            method: .delete,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        completion(json, nil)
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    let error = NSError(domain: "", code: 500, userInfo: [
                        NSLocalizedDescriptionKey: "Empty response data."
                    ])
                    completion(nil, error)
                }
            case .failure(let afError):
                completion(nil, afError)
            }
        }
    }

    func getPlayUrl(contentType: String, streamingUrlPath: String, complete: @escaping (String?, String?) -> Void) {
        guard let playUrl = URL(string: "https://connect.shadhinmusic.com/api/v1/streamings/url?&contentType=\(contentType)&path=\(streamingUrlPath)") else {
            fatalError("Url make failed")
        }
        
        var request = URLRequest(url: playUrl)
        request.method = .get
        request.headers = ShadhinShortsApiContants().API_HEADER
        AF.request(request)
            .responseDecodable(of: PlayURLResponse.self) { response in
                switch response.response?.statusCode {
                case 200:
                    if let value = response.value {
                        if let data = value.data {
                            complete(data, nil)
                        } else if let msg = value.error {
                            complete(nil, msg)
                        }
                    }
                case 409:
                    if let data = response.value {
                        complete(nil, data.error)
                    } else {
                        complete(nil, response.error?.localizedDescription)
                    }
                case 402:
                    complete(nil, response.error?.localizedDescription)
                    break
                case 401:
                    complete(nil, response.error?.localizedDescription)
                    break
                default:
                    complete(nil, response.error?.localizedDescription)
                    break
                }
            }
    }
    
    func surveySubmitData(id: Int,
                         contentType: String,
                          interestStatus: String,
                          reportCategory: String,
                         completion: @escaping ([String: Any]?, Error?) -> Void) {

        let parameters: [String: Any] = [
            "id": id,
            "contentType": contentType,
            "interestStatus": interestStatus,
            "reportCategory": reportCategory
        ]

        AF.request(
            SURVEY_URL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .response { response in
            switch response.result {
            case .success(let data):
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        completion(json, nil)
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    let error = NSError(domain: "", code: 500, userInfo: [
                        NSLocalizedDescriptionKey: "Empty response data."
                    ])
                    completion(nil, error)
                }
            case .failure(let afError):
                completion(nil, afError)
            }
        }
    }
    
    func getAllCommentsData(contentId: Int,
                            usercode: Int,
                            pageSize: Int,
                            nextCursor: Int,
                            completion:
                            @escaping (CommentResponse?, Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "ContentId": contentId,
            "Usercode": usercode,
            "PageSize": pageSize,
            "NextCursor": nextCursor
        ]
        
        AF.request(
            GET_ALL_COMMENTS_URL,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .responseDecodable(of: CommentResponse.self){ response in
            switch response.result{
            case let .success(data):
                completion(data, nil)
            case .failure(_):
                let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "experiencing technical problems now which will be fixed soon.Thanks for your patience."])
                completion(nil,error)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    func addCommentsData(contentId: Int,
                         usercode: String,
                         description: String,
                         fullName: String,
                         imageUrl: String,
                         completion:
                         @escaping (AddCommentResponse?, Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "contentId": contentId,
            "usercode": usercode,
            "description": description,
            "fullName": fullName,
            "imageUrl" : imageUrl
        ]
        
        AF.request(
            ADD_COMMENT_URL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .responseDecodable(of: AddCommentResponse.self){ response in
            switch response.result{
            case let .success(data):
                completion(data, nil)
            case .failure(_):
                let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "experiencing technical problems now which will be fixed soon.Thanks for your patience."])
                completion(nil,error)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    func addCommentOrReplyFavorite(commentId: Int?,
                                   replyId: Int?,
                                   isLiked: Bool,
                                   usercode: String,
                                   completion:
                                   @escaping (LikeActionResponse?, Error?) -> Void) {
        
        var parameters: [String: Any] = [
            "commentId": commentId ?? NSNull(),
            "replyId": replyId ?? NSNull(),
            "isLiked": isLiked,
            "usercode": usercode
        ]
        
        AF.request(
            ADD_FAV_COMMENT_URL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .responseDecodable(of: LikeActionResponse.self){ response in
            switch response.result{
            case let .success(data):
                completion(data, nil)
            case .failure(_):
                let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "experiencing technical problems now which will be fixed soon.Thanks for your patience."])
                completion(nil,error)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    func getAllRepliessData(commentId: Int,
                            usercode: String,
                            completion:
                            @escaping (ReplyResponse?, Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "CommentId": commentId,
            "Usercode": usercode
        ]
        
        AF.request(
            GET_ALL_REPLIES_URL,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .responseDecodable(of: ReplyResponse.self){ response in
            switch response.result{
            case let .success(data):
                completion(data, nil)
            case .failure(_):
                let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "experiencing technical problems now which will be fixed soon.Thanks for your patience."])
                completion(nil,error)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
    
    
    func addRepliesData(contentId: Int,
                        description: String,
                        usercode: String,
                        fullName: String,
                        imageUrl: String,
                        completion:
                        @escaping (AddReplyCommentResponse?, Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "commentId": contentId,
            "description": description,
            "usercode": usercode,
            "fullName": fullName,
            "imageUrl": imageUrl
        ]
        
        AF.request(
            ADD_REPLIES_URL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: ShadhinShortsApiContants().API_HEADER
        )
        .validate()
        .responseDecodable(of: AddReplyCommentResponse.self){ response in
            switch response.result{
            case let .success(data):
                completion(data, nil)
            case .failure(_):
                let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "experiencing technical problems now which will be fixed soon.Thanks for your patience."])
                completion(nil,error)
                print(response.error?.localizedDescription as Any)
            }
        }
    }
}
