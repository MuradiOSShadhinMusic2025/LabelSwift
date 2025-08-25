//
//  AppData.swift
//  Shadhin_shorts
//
//  Created by Maruf on 6/5/25.
//

import Foundation
import UIKit

class AppData {

    @MainActor static private var _initilize: AppData?  // use var, not let
    @MainActor static var shared: AppData {
        if _initilize == nil {
            _initilize = AppData()
        }
        return _initilize!
    }

    deinit {
        Task { @MainActor in
            AppData._initilize = nil
        }
    }

    private var userDefault = UserDefaults.standard

    var membership = ""

    var isBL: Bool {
        get { userDefault.bool(forKey: #function) }
        set {
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }

    var searchKeyword: [String] {
        get {
            let keywords = userDefault.stringArray(forKey: #function) ?? []
            return keywords.reversed()
        }
        set {
            var vv = newValue
            if vv.count > 10 {
                vv.removeFirst()
            }
            userDefault.set(vv, forKey: #function)
            userDefault.synchronize()
        }
    }
    
    var isFetchFavourite : Bool{
        get {
            return userDefault.bool(forKey: #function)
        }set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    var isFetchArtist : Bool{
        get{
            return userDefault.bool(forKey: #function)
        }set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    var isFetchAlbum : Bool{
        get{
            return userDefault.bool(forKey: #function)
        }set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    var isFetchPodcast : Bool{
        get{
            return userDefault.bool(forKey: #function)
        }set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    var isFetchVideoPodcast : Bool{
        get{
            return userDefault.bool(forKey: #function)
        }set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    var isFetchSong : Bool{
        get{
            return userDefault.bool(forKey: #function)
        }set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    var isFetchVideo : Bool{
        get{
            return userDefault.bool(forKey: #function)
        }set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    
    var sessionStart : String?{
        get{
            return userDefault.string(forKey: #function)
        }set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    
    var isPremiumFeatureShow : Bool{
        get {
            return userDefault.bool(forKey: #function)
        }set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    var isRBTon : Bool{
        get{
            return userDefault.bool(forKey: #function)
        }
        set{
            userDefault.set(newValue, forKey: #function)
        }
    }
    var isTestMood : Bool{
        get{
            return userDefault.bool(forKey: #function)
        }
        set{
            userDefault.set(newValue, forKey: #function)
        }
    }
    var isPremium : Bool{
        
        get{
            if isTestMood{
                return true
            }
            return userDefault.bool(forKey: #function)
        }
        set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    var bkashServiceID : String?{
        get{
            return userDefault.string(forKey: #function)
        }
        set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }

    
    var premiumPopupLastShowTime : Date?{
        get{
            return userDefault.object(forKey: #function) as? Date
        }set{
            userDefault.set(newValue, forKey: #function)
        }
    }
    
    var illegalActivity : Bool{
        get{
            userDefault.bool(forKey: #function)
        }set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    var uuid : String?{
        get {
            userDefault.string(forKey: #function)
        }set{
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    var sessionFireTime : Double{
        get{
            let time = userDefault.double(forKey: #function)
            return time < 60 ? 120 : time
        }
        set{
            userDefault.setValue(newValue < 60 ? 60 : newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    var streamFireTime : Double{
        get{
            let time = userDefault.double(forKey: #function)
            return time < 60 ? 120 : time
        }
        set{
            userDefault.setValue(newValue < 60 ? 60 : newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    
    
}
