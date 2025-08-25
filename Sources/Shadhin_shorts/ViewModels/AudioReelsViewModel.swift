//
//  AudioReelsViewModel.swift
//  Shadhin_shorts
//
//  Created by Maruf on 8/4/25.
//

import Foundation

class AudioReelsViewModel {
    
    var onDataReceived: ((ReelsResponseObject) -> Void)?
    var onForYouDataReceived: ((ForYouReelsResponse) -> Void)?
    var onCommentsDataReceived: (([ShortsComment]) -> Void)?
    var onError: ((Error) -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onAllFavDataReceived: (([Favorite]?) -> Void)?
    
    let api = ShadhinShortsApi()
    
    @MainActor func fetchAudioReels() {
        onLoading?(true)
        
        api.getAudioReelsContents { [weak self] (response, error) in
            self?.onLoading?(false)
            
            if let error = error {
                self?.onError?(error)
            } else if let response = response {
                let sortedData = response.data?.sorted { ($0.sort ?? 0) < ($1.sort ?? 0) }
                var sortedResponse = response
                sortedResponse.data = sortedData
                self?.onDataReceived?(sortedResponse)
            }
        }
    }
    
    @MainActor func fetchForYouAudioReels() {
        onLoading?(true)
        api.getForYouAudioRellsContents { [weak self] (response, error) in
            self?.onLoading?(false)
            if let error = error {
                self?.onError?(error)
            } else if let response = response {
                self?.onForYouDataReceived?(response)
            }
        }
    }
    
    @MainActor func fetchAnalyticsCountData(id: Int, contentType: String, completion: @escaping (ShortsAnalytics?) -> Void) {
        self.onLoading?(true)
        self.api.getAnalyticsCount(id: id, contentType: contentType) { [weak self] response, error in
            self?.onLoading?(false)
            if let error = error {
                self?.onError?(error)
                completion(nil)
            } else {
                completion(response?.data.first?.analytics)
            }
        }
    }
    
    @MainActor func fetchAllFavoriteData() {
        onLoading?(true)
        self.api.getAllFavoriteData() { [weak self] response, error in
            self?.onLoading?(false)
            if let error = error {
                self?.onError?(error)
            } else {
                self?.onAllFavDataReceived?(response?.data)
            }
        }
    }
    
    @MainActor func favoriteAddData(id: Int, contentType: String, completion: @escaping (Bool, Error?) -> Void) {
        onLoading?(true)
        self.api.favoriteAddData(id: id, contentType: contentType) { [weak self] json, error in
            self?.onLoading?(false)
            if let error = error {
                completion(false, error)
                return
            }

            if let json = json {
                if let success = json["success"] as? Bool {
                    if success {
                        if let title = json["title"] as? String, title.lowercased() == "created" {
                            completion(true, nil)
                        } else {
                            completion(true, error)
                        }

                    } else {
                        completion(false, error)
                    }
                } else {
                    completion(false, error)
                }
            } else {
                completion(false, error)
            }
        }
    }

    @MainActor func favoriteDeleteData(id: Int, contentType: String, completion: @escaping (Bool, Error?) -> Void) {
        onLoading?(true)
        self.api.favoriteDeleteData(id: id, contentType: contentType) { [weak self] json, error in
            self?.onLoading?(false)
            if let error = error {
                completion(false, error)
                return
            }

            if let json = json {
                if let success = json["success"] as? Bool {
                    if success {
                        if let title = json["title"] as? String, title.lowercased() == "success" {
                            completion(true, nil)
                        } else {
                            completion(true, error)
                        }

                    } else {
                        completion(false, error)
                    }
                } else {
                    completion(false, error)
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    @MainActor func getAllCommentsData() {
        onLoading?(true)
        api.getAllCommentsData(contentId: 317,
                               usercode: 8801717230976,
                               pageSize: 10000,
                               nextCursor: Int(UInt32.max)) { [weak self] (response, error) in
            
            self?.onLoading?(false)
            if let error = error {
                self?.onError?(error)
            } else if let response = response {
                self?.onCommentsDataReceived?(response.data)
            }
        }
    }
}
