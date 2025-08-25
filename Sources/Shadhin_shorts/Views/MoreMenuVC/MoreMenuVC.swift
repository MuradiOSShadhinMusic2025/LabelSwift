//
//  MoreMenuVC.swift
//  Shadhin
//
//  Created by Joy on 13/7/22.
//  Copyright © 2022 Cloud 7 Limited. All rights reserved.
//

import UIKit

protocol MoreMenuDelegate : NSObject{
    func onDownload(with content : ContentProtocol)
    func onRemoveDownload(with content : ContentProtocol)
    func onAddFavourite(with content : ContentProtocol)
    func onRemoveFavourite(with content : ContentProtocol)
    func onAddToWatchList(with content : ContentProtocol)
    func onRemoveWatchList(with content : ContentProtocol)
    func onAddToPlaylist(with content : ContentProtocol)
    func onAddToQueueList(with content : ContentProtocol)
    func onGotoAlbum(with content : ContentProtocol)
    func onGotoArtist(with content : ContentProtocol)
    func onShare(with content : ContentProtocol)
    func removeFromPlaylist(with content : ContentProtocol)
    func deletePlaylist()
}
extension MoreMenuDelegate{
    func onDownload(with content : ContentProtocol){}
    func onRemoveDownload(with content : ContentProtocol){}
    func onAddFavourite(with content : ContentProtocol){}
    func onRemoveFavourite(with content : ContentProtocol){}
    func onAddToWatchList(with content : ContentProtocol){}
    func onRemoveWatchList(with content : ContentProtocol){}
    func onAddToPlaylist(with content : ContentProtocol){}
    func onAddToQueueList(with content : ContentProtocol){}
    func onGotoAlbum(with content : ContentProtocol){}
    func onGotoArtist(with content : ContentProtocol){}
    func onShare(with content : ContentProtocol){}
    func removeFromPlaylist(with content : ContentProtocol){}
    func deletePlaylist(){}
}

struct MoreMenuModel{
    var title : String
    var icon : AppImage
    var type : MenuItemType
}
enum MenuItemType{
    case offlineDownload
    case removeDownload
    case addFavourite
    case removeFavourite
    case addWatchLater
    case removeWatchLater
    case addToPlaylist
    case addToQueue
    case gotoAlbum
    case gotoArtist
    case share
    case removeFromPlaylist
    case deletePlaylist
}
enum MenuFromType : String, CaseIterable{
    case Songs = "S"
    case Album  = "R"
    case Artist = "A"
    case Podcast  =  "PD"
    case PodCastVideo = "VD"
    case Playlist  = "P"
    case UserPlaylist = "UP"
    case Video = "V"
    case None = ""
    case Download = "Download"
    case Favourite = "Favourite"
}

class MoreMenuVC: UIViewController, NIBVCProtocol {
    
    weak var delegate : MoreMenuDelegate?
    
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var contents: ReelsContent!
    private var dataSource : [MoreMenuModel] = []
    var menuFrom : MenuFromType =  .Songs
    private var contentType : ContentType = .s
    
    private var adapter : MoreMenuAdapter!
    
    var contentData : ContentProtocol!
    var isUserPlaylist : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if menuFrom == .UserPlaylist && isUserPlaylist{
//            dataSource = MoreMenuLoader.getPlaylistMenu()
//        }else{
//            dataSource = MoreMenuLoader.getMenu(content: contentData, from: menuFrom)
//        }
        
     //   contentType = ContentType(rawValue: contentData.contentType)
        
//        titleLabel.text = contentData.title
//        subtitleLabel.text = contentData.artistname
//        if contentType == .s || contentType == .podcast || contentType == .a  || contentType == .p  || contentType == .r || contentType == .videoPodcast{
//            iconIV.kf.setImage(with: URL(string: contentData.image.img300),placeholder: AppImage.tmp.uiImage)
//            //iconIV.sd_setImage(with: URL(string: contentData.image.getImageUrl(for: 300)),placeholderImage: AppImage.tmp.uiImage)
//        }else{
//            iconIV.kf.setImage(with: URL(string: contentData.image),placeholder: AppImage.tmp.uiImage)
//            //iconIV.sd_setImage(with: URL(string: contentData.image),placeholderImage: AppImage.tmp.uiImage)
//        }
        viewSetup()
        dataBind()
        
    }
    
    private func dataBind() {
        iconIV.layer.cornerRadius = 16
        iconIV.clipsToBounds = true
        iconIV.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        iconIV.layer.borderWidth = 0.8
        iconIV.kf.setImage(with: URL(string: contents.imageURL?.img300 ?? ""))
        titleLabel.text = contents.title
        subtitleLabel.text = contents.artists?.first?.name
    }
    
}
extension MoreMenuVC {
    func viewSetup(){
//        view.layer.cornerRadius =  16
//        iconIV.layer.cornerRadius = 16
//        iconIV.clipsToBounds = true
                
        //download check
      /*  if contentType == .s || contentType == .podcast || contentType  ==  .v || contentType == .a || contentType == .r  || contentType == .p || contentType == .videoPodcast{
            if contentData.getSong().isDownloaded(){
                let item = MoreMenuModel(title: ^String.MoreMenu.removeFromDownload, icon: .removeDownload, type: .removeDownload)
                if let indx = dataSource.firstIndex(where: { mm in
                    return mm.type == .offlineDownload
                }){
                    dataSource.remove(at: indx)
                    dataSource.insert(item, at: indx)
                    tableView.reloadData()
                }
            }
            if contentType == .v{
                let item = MoreMenuModel(title: ^String.MoreMenu.removeFromWatchLater, icon: AppImage.removeWatchLater, type: .removeWatchLater)
                if contentData.getVideo().isWatchLater(){
                    if let indx = dataSource.firstIndex(where: { mm in
                        return mm.type == .addWatchLater
                    }){
                        dataSource.remove(at: indx)
                        dataSource.insert(item, at: indx)
                        tableView.reloadData()
                    }
                }
            }
            if contentData.getSong().isFav() || contentData.getVideo().isFav(){
                let item = MoreMenuModel(title: ^String.MoreMenu.removeFromFavourites, icon: AppImage.removeFavourite, type: .removeFavourite)
                if let indx = dataSource.firstIndex(where: { mm in
                    return mm.type == .addFavourite
                }){
                    dataSource.remove(at: indx)
                    dataSource.insert(item, at: indx)
                    tableView.reloadData()
                }
            }
        } */
           
        tableViewSetup()
    }
    func tableViewSetup(){
        
        adapter = MoreMenuAdapter(dataSource: dataSource, delegate: self)
        tableView.register(MenuCell.nib, forCellReuseIdentifier: MenuCell.identifier)
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.dataSource = adapter
        tableView.delegate = adapter
    }
}

//MARK: Adapter protocol
extension MoreMenuVC : @preconcurrency MoreMenuAdapterProtocol{
    func onItemPressed(item: MoreMenuModel, at: Int) {
        guard let delegate = delegate else{
            return
        }
        
        switch item.type{
            
        case .offlineDownload:
            delegate.onDownload(with: contentData)
        case .removeDownload:
            delegate.onRemoveDownload(with: contentData)
        case .addFavourite:
            delegate.onAddFavourite(with: contentData)
        case .removeFavourite:
            delegate.onRemoveFavourite(with: contentData)
        case .addWatchLater:
            delegate.onAddToWatchList(with: contentData)
        case .removeWatchLater:
            delegate.onRemoveWatchList(with: contentData)
        case .addToPlaylist:
            delegate.onAddToPlaylist(with: contentData)
        case .addToQueue:
            delegate.onAddToQueueList(with: contentData)
        case .gotoAlbum:
            delegate.onGotoAlbum(with: contentData)
        case .gotoArtist:
            delegate.onGotoArtist(with: contentData)
        case .share:
            delegate.onShare(with: contentData)
        case .removeFromPlaylist:
            delegate.removeFromPlaylist(with: contentData)
        case .deletePlaylist:
            delegate.deletePlaylist()
        }
    }
}
