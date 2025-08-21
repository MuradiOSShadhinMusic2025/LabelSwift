//
//  AppImage.swift
//  Shadhin_shorts_Test
//
//  Created by Maruf on 6/5/25.
//

import UIKit

enum AppImage : String{
    
    typealias RawValue = String
    case more = "more"
    case music = "music"
    case crossPlaylist = "crossPlaylist"
    
    case playFill = "playButton"
    case pauseFill = "pause_music"
    case playCircleFillMusic = "play_circle_filled_music"
    case repeatMusic = "repeat"
    case repeatOne = "repeat_one_on"
    case repeatAll = "repeat_on"
    case shuffle = "shuffle"
    case shuffleOn = "shuffle_on"
    case forwardMusic = "forward.end.fill"
    case backwardMusic = "backward.end.fill"
    case volume = "speaker.wave.2.fill"
    case libraryAdd = "library_add"
    case download = "download"
    case queueMusic = "queue_music"
    case pauseCircleFillMusic = "pause_fill_circle_music"
    case down = "expand_more"
    
    case muteIcon = "muteIcon"
    case volumeIcon = "volume"
    case volumeThumb
    case music_download
    //video
    case favourites  = "favorite_border"
    case favourite_fill = "favorite_fill"
    case watchLater = "watch_later_Outline"
    case share = "share"
    case download_video = "download_outline"
    
    
    //more menu
    case downloadOffline = "download_menu"
    case removeDownload = "download_remove_menu"
    case addToFavourite = "add_favourite_menu"
    case removeFavourite = "remove_favourite_menu"
    case addWatchLater = "add_watch_later_menu"
    case removeWatchLater = "remove_watch_list_menu"
    case addToQueue = "add_to_queue_menu"
    case addToPlaylist = "add_playlist_menu"
    case gotoAlbum =  "goto_album_menu"
    //case gotoArtist = ""
    case shareMenu = "share_menu"
    case search = "search"
    case playlistDelete =  "playlistDelete"
    
    case playRadio = "play_radio"
    case pauseRadio = "pause_radio"
    
    //rbt
    case rbtChecked
    case rbtUnchecked
    case rbtDone
    case rbtError
    case timer
    case rbtDivider
    case add
    case tmp
    
    //placeholder
    case album = "default_album"
    case artist = "default_artist"
    case playlist = "default_playlist"
    case radio = "default_radio"
    case song = "default_song"
    case video = "default_video"
    
    case premium = "rank"
    
    case live = "live_tag"
    //comment
    case commentFav = "love.fill"
    case commentUnFav = "love"
    case userPremium = "user_premium"
    case thumbUp
    case thumbFill
    case profileAvater = "profileAvater"
    
    
    //subscription
    case checkMark
    case unCheckMark
    
    //navigation bar
    case faq
    case leaderboard
    case membership
    case reward
    case termsOfUses
    
    //concert ticket
    case user
    case mail
    case number
    case ticketRadio
    case ticketRadioSelect
    case event
    case diamond
    case ticketFaq
    case tc
    case dob
    
    //version compactability . value change for diffrent version
    
    //get uiImage from appImage
    var uiImage : UIImage?{
//        if #available(iOS 13, *){
//            return  UIImage(systemName: rawValue) ?? UIImage(named: rawValue, in: Bundle.bundle, compatibleWith: nil)
//        }
        return UIImage(
            named: rawValue,
            in: Bundle.shadhinShorts,
            compatibleWith: nil
        )
    }
    //get system image with tint color
    @available(iOS 13.0, *)
    func uiImage(with fontSize : CGFloat? = nil, tintColor : UIColor? = nil)-> UIImage?{
        var image = uiImage
        if let fontSize = fontSize {
            let font = UIFont.systemFont(ofSize: fontSize)
            image = image?.withConfiguration(UIImage.SymbolConfiguration(font: font))
        }
        if let tintColor = tintColor {
            return image?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        }else{
            return image
        }
    }
}

enum ContentType: String, Codable {
    
    case a = "A"
    case p = "P"
    case r = "R"
    case s = "S"
    case podcast =  "PD"
    case videoPodcast = "VD"
    case ps = "PS" //podcast show
    case pe = "PE" //podcast episode
    case pt = "PT" //podcast track
    case v = "V"
    case vs = "VS" //video podcast show
    case banner = "B"
    case leaderboard = "L"
    case userPlaylist = "UP"
    case rc = "RC"
    case link = "LK"
    case radio = "RADIO"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if string.count > 2 && string.uppercased().hasPrefix("PD"){
            self = ContentType(rawValue: String(string.uppercased().prefix(2)))
        }else{
            self = ContentType(rawValue: string)
        }
    }
    
    init(rawValue: String){
        var value = rawValue.uppercased()
        if value.starts(with: "PD") || value.starts(with: "VD"),
           value.count > 2{
            value = String(value.prefix(2))
        }
        switch value {
        case "A" : self = .a
        case "R" : self = .r
        case "S" : self = .s
        case "PD": self = .podcast
        case "VD": self = .videoPodcast
        case "PS" : self = .ps
        case "PE" : self = .pe
        case "PT" : self = .pt
        case "P" : self = .p
        case "V" : self = .v
        case "VS" : self = .vs
        case "B"  : self = .banner
        case "L" : self = .leaderboard
        case "UP" : self = .userPlaylist
        case "RC" : self = .rc
        case "LK" : self = .link
        case "RADIO" : self = .radio
        default  : self = .unknown
        }
    }
}

class AppSettings {
    static let shared = AppSettings()
    private let defaults = UserDefaults.standard
    
    var isLightTheme: Bool {
        get { defaults.bool(forKey: "isLightTheme") }
        set { defaults.set(newValue, forKey: "isLightTheme") }
    }
}



extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    enum MoreMenu : String{
        case downloadOffline
        case removeFromDownload
        case addtoFavourites
        case removeFromFavourites
        case addtoWatchLater
        case removeFromWatchLater
        case addtoQueue
        case addtoPlaylist
        case gotoAlbum
        case gotoArtist
        case share
        case removeFromPlaylist
        case deletePlaylist
        
    }
    
}
extension RawRepresentable {
    
    func format(_ args: CVarArg) -> String {
        let format = ^self
        return String(format: format, args)
    }
    
}

prefix operator ^
prefix func ^<Type: RawRepresentable> (_ value: Type) -> String {
    if let raw = value.rawValue as? String {
        let key = raw.capitalizeFirstLetter()
        return NSLocalizedString(
            key,
            bundle: Bundle.shadhinShorts,
            value: "",
            comment: ""
        )
        //return NSLocalizedString(key, comment: "")
    }
    return ""
}
