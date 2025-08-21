//
//  MenuLoader.swift
//  Shadhin-BL
//
//  Created by Joy on 26/9/22.
//

import Foundation

struct MoreMenuLoader{
    static func getHeight(contentType : ContentType)->CGFloat{
        let top : CGFloat = 12 + 28 + 250 + 25 + 24
        var item : CGFloat = 0
        if contentType ==  .s{
             item = (36 * 5) + (5 * 16) // per item height 40 and space 16
        }else if contentType == .v{
            item = (36 * 4) + ( 16 * 4)
        }
        return top + item
    }
    static func getHeight(content : ContentProtocol, from : MenuFromType)->CGFloat{
        let top : CGFloat = 12 + 28 + 250 + 25 + 24
        
        let menus = getMenu(content: content, from: from)
        let item : CGFloat = CGFloat(52 * menus.count)
        
        return top + item
    }
    static func getMenu(content : ContentProtocol,from : MenuFromType)-> [MoreMenuModel]{
        var arr : [MoreMenuModel] = []
        
        let type = ContentType(rawValue: content.contentType)
        
        if type == .s{
            arr =  [.init(title: ^String.MoreMenu.downloadOffline, icon: .downloadOffline, type: .offlineDownload),.init(title: ^String.MoreMenu.addtoFavourites, icon: .addToFavourite, type: .addFavourite),.init(title: ^String.MoreMenu.addtoPlaylist, icon: .addToPlaylist, type: .addToPlaylist)]
            if from == .Album{
                if let _ = content.artistID{
                    arr.append(.init(title: ^String.MoreMenu.gotoArtist, icon: .gotoAlbum, type: .gotoArtist))
                }
            }else if from  ==  .Artist{
                if let _ = content.albumID{
                    arr.append(.init(title: ^String.MoreMenu.gotoAlbum, icon: .gotoAlbum, type: .gotoAlbum))
                }
            }
            if from == .Download  || from == .Songs  || from == .UserPlaylist || from == .Favourite{
                if let _ = content.artistID{
                    arr.append(.init(title: ^String.MoreMenu.gotoArtist, icon: .gotoAlbum, type: .gotoArtist))
                }
                if let _ = content.albumID{
                    arr.append(.init(title: ^String.MoreMenu.gotoAlbum, icon: .gotoAlbum, type: .gotoAlbum))
                }
            }
            if from == .UserPlaylist{
                arr.removeAll(where: {$0.type == .addToPlaylist})
                arr.append(.init(title: ^String.MoreMenu.removeFromPlaylist, icon: AppImage.playlistDelete, type: .removeFromPlaylist))
            }
            //arr.append(.init(title: ^String.MoreMenu.share, icon: .shareMenu, type: .share))
        }else if type == .v{
            arr =  [.init(title: ^String.MoreMenu.downloadOffline, icon: .downloadOffline, type: .offlineDownload),.init(title: ^String.MoreMenu.addtoFavourites, icon: .addToFavourite, type: .addFavourite),.init(title: ^String.MoreMenu.addtoWatchLater, icon: .addWatchLater, type: .addWatchLater)]
        }else if type == .podcast || type == .pe || type == .ps || type == .pt{
            arr = [.init(title: ^String.MoreMenu.downloadOffline, icon: .downloadOffline, type: .offlineDownload),.init(title: ^String.MoreMenu.addtoFavourites, icon: .addToFavourite, type: .addFavourite)]
            
        }else if type == .a{
            arr = [.init(title: ^String.MoreMenu.addtoFavourites, icon: .addToFavourite, type: .addFavourite),.init(title: ^String.MoreMenu.gotoArtist, icon: .gotoAlbum, type: .gotoArtist)]
        }else if type == .r{
            arr = [.init(title: ^String.MoreMenu.addtoFavourites, icon: .addToFavourite, type: .addFavourite),.init(title: ^String.MoreMenu.gotoAlbum, icon: .gotoAlbum, type: .gotoAlbum)]
            if let _ = content.artistID {
                arr.append(.init(title: ^String.MoreMenu.gotoArtist, icon: .gotoAlbum, type: .gotoArtist))
            }
        }else if type == .p{
            arr = [.init(title: ^String.MoreMenu.addtoFavourites, icon: .addToFavourite, type: .addFavourite)]
        }else if type == .videoPodcast{
            arr = [.init(title: ^String.MoreMenu.addtoFavourites, icon: .addToFavourite, type: .addFavourite)]
        }
        arr.append(.init(title: ^String.MoreMenu.share, icon: .shareMenu, type: .share))
        
        arr = arr.filter({ mm in
            if !AppData.shared.isPremiumFeatureShow, (mm.type == .offlineDownload || mm.type  == .addFavourite  || mm.type == .addWatchLater){
                return false
            }
            return true 
        })
        return arr
    }
    static func getHeightForPlaylist()->CGFloat{
        let top : CGFloat = 12 + 28 + 250 + 25 + 24
        return top + CGFloat(52 * getPlaylistMenu().count)
    }
    static func getPlaylistMenu()->[MoreMenuModel]{
        var arr  :  [MoreMenuModel] = [.init(title: ^String.MoreMenu.deletePlaylist, icon: AppImage.playlistDelete, type: .deletePlaylist)]
        arr.append(.init(title: ^String.MoreMenu.share, icon: .shareMenu, type: .share))
        return arr
        
    }
}
