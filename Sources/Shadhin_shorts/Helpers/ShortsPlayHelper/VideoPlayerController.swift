//
//  VideoPlayerController.swift
//  ShortsPlayer
//
//  Created by Shadhin Music on 25/3/25.
//

import UIKit
import AVKit
import AVFoundation

class VideoContainer {
    var url: String
    var shouldPlay: Bool = false {
        didSet {
            if shouldPlay {
                player.play()
            } else {
                player.pause()
            }
        }
    }
    
    var playOn: Bool {
        didSet {
            player.isMuted = VideoPlayerController.sharedVideoPlayer.mute
            playerItem.preferredPeakBitRate = VideoPlayerController.sharedVideoPlayer.preferredPeakBitRate
            if playOn && playerItem.status == .readyToPlay {
                player.play()
            } else {
                player.pause()
            }
        }
    }
    
    let player: AVPlayer
    let playerItem: AVPlayerItem
    init(player: AVPlayer, item: AVPlayerItem, url: String) {
        self.player = player
        self.playerItem = item
        self.url = url
        playOn = false
    }
}

class VideoLayerObject: NSObject {
    var layer = AVPlayerLayer()
    var used = false
    override init() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.videoGravity = AVLayerVideoGravity.resize
    }
}

struct VideoLayers {
    var layers = [VideoLayerObject]()
    init() {
        for _ in 0..<1 {
            layers.append(VideoLayerObject())
        }
    }
    
    func getLayerForParentLayer(parentLayer: CALayer) -> AVPlayerLayer {
        for videoObject in layers where videoObject.layer.superlayer == parentLayer {
            return videoObject.layer
        }
        return getFreeVideoLayer()
    }
    
    func getFreeVideoLayer() -> AVPlayerLayer {
        for videoObject in layers where videoObject.used == false {
            videoObject.used = true
            return videoObject.layer
        }
        return layers[0].layer
    }
    
    func freeLayer(layerToFree: AVPlayerLayer) {
        for videoObject in layers where videoObject.layer == layerToFree {
            videoObject.used = false
            videoObject.layer.player = nil
            if videoObject.layer.superlayer != nil {
                videoObject.layer.removeFromSuperlayer()
            }
            break
        }
    }
}


protocol PlayVideoLayerContainer {
    var videoURL: String? { get set }
    var videoLayer: AVPlayerLayer { get set }
    func visibleVideoHeight() -> CGFloat
}

class VideoPlayerController: NSObject, NSCacheDelegate {
    
    // MARK: - Properties
    
    var shouldPlay: Bool = true {
        didSet {
            self.currentVideoContainer()?.shouldPlay = shouldPlay
        }
    }
    var minimumLayerHeightToPlay: CGFloat = 60
    // Mute unmute video
    var mute = false
    var preferredPeakBitRate: Double = 1000000
    static private var playerViewControllerKVOContext = 0
    static let sharedVideoPlayer = VideoPlayerController()
    private var videoURL: String?
    private var observingURLs = [String: Bool]()
    
    private var videoCache = NSCache<NSString, VideoContainer>()
    private var videoLayers = VideoLayers()
    private var currentLayer: AVPlayerLayer?
    override init() {
        super.init()
        videoCache.delegate = self
    }
    
    // MARK: - Methods
    
    func setupVideoFor(url: String) {
        if videoCache.object(forKey: url as NSString) != nil {
            print("Video already cached for URL: \(url)")
            return
        }
        
        guard let URL = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }
        
        let asset = AVURLAsset(url: URL)
        let requestedKeys = ["playable"]
        asset.loadValuesAsynchronously(forKeys: requestedKeys) { [weak self] in
            guard let strongSelf = self else { return }
            
            var error: NSError?
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                let player = AVPlayer()
                let item = AVPlayerItem(asset: asset)
                DispatchQueue.main.async {
                    let videoContainer = VideoContainer(player: player, item: item, url: url)
                    strongSelf.videoCache.setObject(videoContainer, forKey: url as NSString)
                    videoContainer.player.replaceCurrentItem(with: item)
                    videoContainer.player.isMuted = strongSelf.mute
                    videoContainer.playerItem.preferredPeakBitRate = strongSelf.preferredPeakBitRate
                    
                    if strongSelf.videoURL == url, let layer = strongSelf.currentLayer {
                        strongSelf.playVideo(withLayer: layer, url: url)
                    }
                }
            case .failed, .cancelled:
                print("Failed to load asset for URL: \(url), error: \(error?.localizedDescription ?? "Unknown error")")
            default:
                print("Unknown asset status for URL: \(url)")
            }
        }
    }
    
    
    func playVideo(withLayer layer: AVPlayerLayer, url: String) {
        videoURL = url
        currentLayer = layer
        
        if let videoContainer = videoCache.object(forKey: url as NSString) {
            layer.player = videoContainer.player
            videoContainer.playOn = true
            addObservers(url: url, videoContainer: videoContainer)
            
            // Ensure player is ready to play
            if videoContainer.player.currentItem?.status == .readyToPlay {
                videoContainer.player.play()
                videoContainer.player.isMuted = mute
                print("Playing video for URL: \(url)")
            } else {
                print("Player not ready for URL: \(url), status: \(videoContainer.player.currentItem?.status.rawValue ?? -1)")
                // Observe status to play when ready
                videoContainer.player.currentItem?.addObserver(
                    self,
                    forKeyPath: "status",
                    options: [.new],
                    context: &VideoPlayerController.playerViewControllerKVOContext
                )
            }
        } else {
            print("No video container found for URL: \(url)")
            setupVideoFor(url: url) // Retry setup if container is missing
        }
        
        NotificationCenter.default.post(name: Notification.Name("STARTED_PLAYING"), object: nil, userInfo: nil)
    }
    
    private func pauseVideo(forLayer layer: AVPlayerLayer, url: String) {
        videoURL = nil
        currentLayer = nil
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
            removeObserverFor(url: url)
        }
    }
    
    func removeLayerFor(cell: PlayVideoLayerContainer) {
        if let url = cell.videoURL {
            removeFromSuperLayer(layer: cell.videoLayer, url: url)
        }
    }
    
    private func removeFromSuperLayer(layer: AVPlayerLayer, url: String) {
        videoURL = nil
        currentLayer = nil
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
            removeObserverFor(url: url)
        }
        layer.player = nil
    }
    
    func pauseCurrentVideo() {
        if let container = currentVideoContainer() {
            container.player.pause()
            container.playOn = false
            print("Paused current video for URL: \(container.url)")
        }
    }
    
    private func pauseRemoveLayer(layer: AVPlayerLayer, url: String, layerHeight: CGFloat) {
        pauseVideo(forLayer: layer, url: url)
    }
    
    // Play video again in case the current player has finished playing
    @objc func playerDidFinishPlaying(note: NSNotification) {
        guard let playerItem = note.object as? AVPlayerItem,
            let currentPlayer = currentVideoContainer()?.player else {
                return
        }
        if let currentItem = currentPlayer.currentItem, currentItem == playerItem {
            currentPlayer.seek(to: CMTime.zero)
            currentPlayer.play()
        }
    }
    
    private func currentVideoContainer() -> VideoContainer? {
        if let currentVideoUrl = videoURL {
            if let videoContainer = videoCache.object(forKey: currentVideoUrl as NSString) {
                return videoContainer
            }
        }
        return nil
    }
    
    private func addObservers(url: String, videoContainer: VideoContainer) {
        if self.observingURLs[url] == false || self.observingURLs[url] == nil {
            videoContainer.player.currentItem?.addObserver(
                self,
                forKeyPath: "status",
                options: [.new, .initial],
                context: &VideoPlayerController.playerViewControllerKVOContext)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerDidFinishPlaying(note:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: videoContainer.player.currentItem)
            self.observingURLs[url] = true
        }
    }
    
    private func removeObserverFor(url: String) {
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            if let currentItem = videoContainer.player.currentItem, observingURLs[url] == true {
                currentItem.removeObserver(self,
                                           forKeyPath: "status",
                                           context: &VideoPlayerController.playerViewControllerKVOContext)
                NotificationCenter.default.removeObserver(self,
                                                          name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                          object: currentItem)
                observingURLs[url] = false
            }
        }
    }
    
    func pausePlayeVideosFor(tableView: UITableView, appEnteredFromBackground: Bool = false) {
        let visibleCells = tableView.visibleCells
        var videoCellContainer: PlayVideoLayerContainer?
        var maxHeight: CGFloat = 0.0
        
        // Pause all videos first
        for cellView in visibleCells {
            guard let containerCell = cellView as? PlayVideoLayerContainer,
                  let videoCellURL = containerCell.videoURL else {
                continue
            }
            pauseVideo(forLayer: containerCell.videoLayer, url: videoCellURL)
        }
        
        // Find the most visible cell
        for cellView in visibleCells {
            guard let containerCell = cellView as? PlayVideoLayerContainer,
                  let videoCellURL = containerCell.videoURL else {
                continue
            }
            let height = containerCell.visibleVideoHeight()
            if height > maxHeight {
                maxHeight = height
                videoCellContainer = containerCell
            }
        }
        
        // Play video for the most visible cell
        guard let videoCell = videoCellContainer,
              let videoCellURL = videoCell.videoURL else {
            print("No visible video cell found")
            return
        }
        
        let minCellLayerHeight = videoCell.videoLayer.bounds.size.height * 0.5
        let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
        
        if maxHeight > minimumVideoLayerVisibleHeight {
            if appEnteredFromBackground {
                setupVideoFor(url: videoCellURL)
            }
            print("Playing video for most visible cell with URL: \(videoCellURL)")
            playVideo(withLayer: videoCell.videoLayer, url: videoCellURL)
        } else {
            print("No cell is sufficiently visible to play video")
        }
    }
    
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let videoObject = obj as? VideoContainer {
            observingURLs[videoObject.url] = false
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard context == &VideoPlayerController.playerViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == "status" {
            guard let item = object as? AVPlayerItem,
                  let newStatusNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber,
                  let currentContainer = currentVideoContainer(),
                  item == currentContainer.player.currentItem else {
                return
            }
            
            let newStatus = AVPlayerItem.Status(rawValue: newStatusNumber.intValue)!
            switch newStatus {
            case .readyToPlay:
                if currentContainer.playOn {
                    currentContainer.player.play()
                    currentContainer.player.isMuted = mute
                    print("Player is ready to play for URL: \(currentContainer.url)")
                }
            case .failed:
                print("Player item failed: \(item.error?.localizedDescription ?? "Unknown error")")
            case .unknown:
                print("Player item status unknown")
            @unknown default:
                print("Unknown player item status")
            }
        }
    }
    
    deinit {
        print("Desiposed of Video layer - No retain Cycle/Memeory leaks")
    }
}
