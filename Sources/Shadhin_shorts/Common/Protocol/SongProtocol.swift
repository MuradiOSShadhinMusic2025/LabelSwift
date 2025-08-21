//
//  SongProtocol.swift
//  Shadhin_shorts
//
//  Created by Maruf on 6/5/25.
//

import Foundation
//this needs to be modify
protocol ContentProtocol{
    var contentID: String {get set}
    var albumID : String? {get set}
    var artistID : String? {get set}
    var artistname: String? {get set}
    var albumName : String? {get set}
    var image: String {get set}
    //song name
    var title: String {get set}
    //song type
    var contentType: String {get set}
    //play url
    var playURL: String? {get set}
    //track type for podcast
    var trackType : String?  {get set}
    //song dutation
    var duration : String  {get set}
    var playListID : String? {get set}
    var playListName : String? {get set}
    var playListImage : String? {get set}
    var isRBT : Bool { get set }
    var isPaid : Bool {get set}
    
    var rcCode : String{ get}
    
    func getDictionary()-> [String : Any?]
}
