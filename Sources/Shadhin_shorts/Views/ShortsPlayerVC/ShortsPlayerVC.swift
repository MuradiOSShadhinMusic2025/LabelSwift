//
//  ShortsPlayerVC.swift
//  Shadhin_shorts
//
//  Created by MD Murad Hossain on 6/4/25.
//

import UIKit
import AVFoundation

class ShortsPlayerVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var shortsPlayTableView: UITableView!

    // MARK: - Properties
    private let viewModel = AudioReelsViewModel()
    var audioReelsData = [ReelsContent]()
    var allFavoriteData = [Favorite]()
    var selectedIndexPath = IndexPath()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVisibleCell()
    }

    // MARK: - Setup
    private func setupTableView() {
        shortsPlayTableView.delegate = self
        shortsPlayTableView.dataSource = self
        shortsPlayTableView.register(ShortsPlayerTVCell.nib(), forCellReuseIdentifier: ShortsPlayerTVCell.identifier)
        shortsPlayTableView.rowHeight = UIScreen.main.bounds.height
        shortsPlayTableView.isPagingEnabled = true
    }
    
    // MARK: - Video Handling
    private func playVisibleCell() {
        guard let indexPath = shortsPlayTableView.indexPathsForVisibleRows?.first,
              let cell = shortsPlayTableView.cellForRow(at: indexPath) as? ShortsPlayerTVCell else {
            return
        }
        VideoPlayerController.sharedVideoPlayer.pauseCurrentVideo()
        VideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: shortsPlayTableView)
        cell.videoLayer.player?.play()
    }
}

// MARK: - TableView DataSource
extension ShortsPlayerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioReelsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShortsPlayerTVCell.identifier, for: indexPath) as? ShortsPlayerTVCell else {
            return UITableViewCell()
        }

        let reel = audioReelsData[indexPath.row]
        cell.configureCell(data: reel,
                           playUrl: reel.streamingURL ?? "",
                           isVideo: true,
                           allFavoriteData: [])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        playVisibleCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { playVisibleCell() }
    }
}


// MARK: - Navigation to push
extension ShortsPlayerVC {
    
    fileprivate func didTapShortContent(_ vc: ChannelVC) {
        vc.didTapShortsContent = { [self] index, contents in
            let indexPath = IndexPath(row: index, section: 0)
            self.audioReelsData = contents
            self.selectedIndexPath = indexPath
            self.shortsPlayTableView.scrollToRow(at: self.selectedIndexPath, at: .none, animated: false)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func navigateToChannel(withID id: Int) {
        let vc = ChannelVC(nibName: "ChannelVC", bundle: Bundle(for: ChannelVC.self))
        vc.isHashTag = false
        self.viewModel.api.getChannelHeaderData(contentType: "C", id: id) { data, error in
            vc.channelHeaderData = data?.data
        }
        
        self.viewModel.api.getMusicContentDetailsData(contentId: id, contentType: "C", nextCursor: 0, pageSize: 20) { data, error in
            guard let data = data?.data else { return }
            vc.reelsContents = data.contents
            vc.nextCursor = data.nextCursor
            vc.contentType = "C"
            vc.channelID = id
            vc.hasMoreData = !data.contents.isEmpty
        }
        
        self.didTapShortContent(vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToHashtag(withID id: Int) {
        let vc = ChannelVC(nibName: "ChannelVC", bundle: Bundle(for: ChannelVC.self))
        vc.isHashTag = true
        self.viewModel.api.getChannelHeaderData(contentType: "HT", id: id) { penging_data, error in
            vc.channelHeaderData = penging_data?.data
        }
        
        self.viewModel.api.getMusicContentDetailsData(contentId: id, contentType: "HT", nextCursor: 0, pageSize: 20) { data, error in
            guard let data = data?.data else { return }
            vc.reelsContents = data.contents
            vc.nextCursor = data.nextCursor
            vc.contentType = "HT"
            vc.channelID = id
            vc.hasMoreData = !data.contents.isEmpty
        }
        self.didTapShortContent(vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


/*
 
 // MARK: - Properties
 static let identifier = "ShortsPlayerTVCell"
 static func nib() -> UINib {
     UINib(nibName: identifier, bundle: .module)
 }

 var playerController: VideoPlayerController?
 var videoLayer: AVPlayerLayer = AVPlayerLayer()
 var videoURL: String? {
     didSet {
         if let videoURL = videoURL {
             VideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
         }
         self.videoLayer.isHidden = videoURL == nil
     }
 }
 private let viewModel = AudioReelsViewModel()
 private var timeObserverToken: Any?
 private var observedPlayer: AVPlayer?
 var isLoveBtnClick: Bool = true
 var sliderMaxValue: Float = 0.0
 public var isMediaPlaying: Bool = false {
     didSet {
         if isMediaPlaying {
             startSoundWaveAnimation()
         } else {
             stopSoundWaveAnimation()
         }
     }
 }
 private var doubleTapGesture: UITapGestureRecognizer!
 private var singleTapGesture: UITapGestureRecognizer!
 private var likeImageView: UIImageView!
 var hashtags = [Hashtag]()
 var reelsContent: ReelsContent?
 var currentLoveCount: Int = 0
 
 // MARK: -- Clouser Methods --
 var didTapChannelBtnClick: (() -> Void)?
 var hashTagClicked: ((Int) -> Void)?
 var isLovedDisLoved: (() -> Void)?
 var didTappedCommentBtn: (() -> Void)?
 var didTapthreeDotMenuClick: ((Bool) -> Void)?

 
 // MARK: - Cycle/Init
 override func awakeFromNib() {
     super.awakeFromNib()
     
     DispatchQueue.main.async {
         self.isMediaPlaying = true
         self.addTapGestureToTogglePlayback()
         self.addDoubleTapGestureForLove()
         self.setupLikeImageView()
     }
 }

 
 override func prepareForReuse() {
     super.prepareForReuse()
     thumbnailImageView.image = nil // Clear the image
     videoLayer.player = nil // Clear the player
     videoLayer.isHidden = true // Hide the video layer
     videoURL = nil // Reset the video URL
     stopSoundWaveAnimation() // Stop animations
     hashtags.removeAll() // Clear hashtags
     reelsContent = nil // Clear content
     loveCountLabel.text = "0"
     commentCountLabel.text = "0"
     shareCountLabel.text = "0"
     isLoveBtnClick = true
     ShadhinShort.shared.isLoved = false
     loveBtn.setImage(UIImage(named: "Like"), for: .normal)
 }
 
 override func layoutSubviews() {
     super.layoutSubviews()
     self.videoLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
     self.setupUI()
 }
 
//    deinit {
//        // Capture the token and player in local variables inside a closure
////        let token = timeObserverToken
//        let player = observedPlayer
//
//        // Only use them inside a Task on the MainActor
//        if let token = token, let player = player {
//            Task { @MainActor in
//                player.removeTimeObserver(token)
//            }
//        }
//
//        // Reset properties (safe because we’re just setting to nil)
////        timeObserverToken = nil
//        observedPlayer = nil
//    }


 override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
     guard keyPath == "timeControlStatus",
           let player = object as? AVPlayer else { return }

     DispatchQueue.main.async {
         
         print(player.timeControlStatus.rawValue)
         
         
         if player.timeControlStatus == .playing {
             self.startSoundWaveAnimation()
         } else {
             self.stopSoundWaveAnimation()
         }
     }
 }

 // MARK: - Actions
 @IBAction func didTapChannelBtnAction(_ sender: UIButton) {
     didTapChannelBtnClick?()
 }
 
 @IBAction func didTapChannelFollowBtnAction(_ sender: UIButton) {
     self.profileFollowBtn.setBackgroundImage(ShadhinShort.shared.isProfileFollow ? UIImage(named: "UnFollowing") : UIImage(named: "Following"), for: .normal)
     self.setupChannelFollowUnFollowing()
     ShadhinShort.shared.isProfileFollow.toggle()
 }
 
 @IBAction func loveBtnAction(_ sender: UIButton) {
     self.loveButtonClicked()
     self.setupLikeDislikeButtons()
 }
 
 @IBAction func commentBtnAction(_ sender: UIButton) {
     self.didTappedCommentBtn?()
     // Handle comment button action
 }
 
 @IBAction func shareBtnAction(_ sender: UIButton) {
     // Handle share button action
 }
 
 @IBAction func moreBtnAction(_ sender: UIButton) {
     self.didTapthreeDotMenuClick?(self.reelsContent?.streamingURL?.isVideoFile ?? false)
 }
     
 @IBAction func fullMusicBtnAction(_ sender: UIButton) {
     // Handle full music button action
 }
 
 @IBAction func sliderValueDidChange(_ sender: UISlider) {
     
 }
}

// MARK: - Private Methods
extension ShortsPlayerTVCell {
 
//    func configureCell(data: ReelsContent, playUrl: String, isVideo: Bool, allFavoriteData: [Favorite]) {
//
//        self.reelsContent = data
//        self.thumbnailImageView.kf.setImage(with: URL(string: data.imageURL?.imageSizeParser(contentType: data.contentType?.rawValue ?? "") ?? ""))
//        self.audioThumbImageView.kf.setImage(with: URL(string: data.imageURL?.imageSizeParser(contentType: data.contentType?.rawValue ?? "") ?? ""))
//        self.songTitleLabel.text = data.baseContent?.title ?? "Unknown Title"
//        self.albumNameLabel.text = data.artists?.first?.name ?? "Unknown Artist"
//        self.songNameLabel.text = data.baseContent?.title ?? "Unknown Title"
//
//        if allFavoriteData.contains(where: {$0.contentId == data.id && $0.contentType == data.contentType?.rawValue ?? ""}) {
//            self.isLoveBtnClick = false
//            ShadhinShort.shared.isLoved = true
//            self.loveBtn.setImage(UIImage(named: "LikeFill"), for: .normal)
//        } else {
//            self.isLoveBtnClick = true
//            ShadhinShort.shared.isLoved = false
//            self.loveBtn.setImage(UIImage(named: "Like"), for: .normal)
//        }
//
//        if allFavoriteData.contains(where: {$0.contentId == data.owners?.first?.id}) {
//            ShadhinShort.shared.isProfileFollow = true
//            self.profileFollowBtn.setBackgroundImage(UIImage(named: "Following"), for: .normal)
//        } else {
//            self.profileFollowBtn.setBackgroundImage(UIImage(named: "UnFollowing"), for: .normal)
//            ShadhinShort.shared.isProfileFollow = false
//        }
//
//        ShadhinShort.shared.loveCount = data.analytics?.favoritesCount ?? 0
//        self.currentLoveCount = ShadhinShort.shared.loveCount
//        loveCountLabel.text = "\(data.analytics?.favoritesCount ?? 0)"
//        commentCountLabel.text = "\(data.analytics?.commentsCount ?? 0)"
//        shareCountLabel.text = "\(data.analytics?.sharesCount ?? 0)"
//
//        if isVideo {
//            audioVisualEffectView.isHidden = true
//            audioEqualizerAnimView.pause()
//            channelNameLabel.text = "\(data.owners?.first?.name ?? "")"
//            isVerfiedImgView.isHidden = !(data.owners?.first?.isVerified ?? false)
//            hashTagCVBottomLayout.constant = 10
//
//        } else {
//            audioVisualEffectView.isHidden = false
//            channelNameLabel.text = ""
//            commentBgView.isHidden = true
//            audioEqualizerAnimView.pause()
//            isVerfiedImgView.isHidden = true
//            hashTagCVBottomLayout.constant = 0
//        }
//
//        if let hashtags = data.hashtags {
//            self.hashtags = hashtags
//            hashTagCollectionView.reloadData()
//        }
//
//        self.updateSliderValue()
//        videoURL = playUrl.isEmpty ? nil : playUrl
//    }
 
 func configureCell(data: ReelsContent, playUrl: String, isVideo: Bool, allFavoriteData: [Favorite]) {
     self.reelsContent = data
     
     // Load thumbnail with Kingfisher
     if let imageUrl = URL(string: data.imageURL?.imageSizeParser(contentType: data.contentType?.rawValue ?? "") ?? "") {
         thumbnailImageView.kf.setImage(
             with: imageUrl,
             placeholder: UIImage(named: "placeholder"), // Optional placeholder
             options: [.transition(.fade(0.2))],
             completionHandler: { result in
                 switch result {
                 case .success:
                     print("Thumbnail loaded successfully for URL: \(imageUrl)")
                 case .failure(let error):
                     print("Failed to load thumbnail: \(error.localizedDescription)")
                 }
             }
         )
         audioThumbImageView.kf.setImage(with: imageUrl)
     } else {
         thumbnailImageView.image = UIImage(named: "placeholder") // Fallback image
         audioThumbImageView.image = UIImage(named: "placeholder")
         print("Invalid thumbnail URL")
     }
     
     // Set labels
     songTitleLabel.text = data.baseContent?.title ?? "Unknown Title"
     albumNameLabel.text = data.artists?.first?.name ?? "Unknown Artist"
     songNameLabel.text = data.baseContent?.title ?? "Unknown Title"
     
     // Handle favorite state
     if allFavoriteData.contains(where: { $0.contentId == data.id && $0.contentType == data.contentType?.rawValue ?? "" }) {
         isLoveBtnClick = false
         ShadhinShort.shared.isLoved = true
         loveBtn.setImage(UIImage(named: "LikeFill"), for: .normal)
     } else {
         isLoveBtnClick = true
         ShadhinShort.shared.isLoved = false
         loveBtn.setImage(UIImage(named: "Like"), for: .normal)
     }
     
     // Handle follow state
     if allFavoriteData.contains(where: { $0.contentId == data.owners?.first?.id }) {
         ShadhinShort.shared.isProfileFollow = true
         profileFollowBtn.setBackgroundImage(UIImage(named: "Following"), for: .normal)
     } else {
         ShadhinShort.shared.isProfileFollow = false
         profileFollowBtn.setBackgroundImage(UIImage(named: "UnFollowing"), for: .normal)
     }
     
     // Update analytics
     ShadhinShort.shared.loveCount = data.analytics?.favoritesCount ?? 0
     currentLoveCount = ShadhinShort.shared.loveCount
     loveCountLabel.text = "\(data.analytics?.favoritesCount ?? 0)"
     commentCountLabel.text = "\(data.analytics?.commentsCount ?? 0)"
     shareCountLabel.text = "\(data.analytics?.sharesCount ?? 0)"
     
     // Configure UI based on content type
     if isVideo {
         audioVisualEffectView.isHidden = true
         audioEqualizerAnimView.pause()
         channelNameLabel.text = data.owners?.first?.name ?? ""
         isVerfiedImgView.isHidden = !(data.owners?.first?.isVerified ?? false)
         hashTagCVBottomLayout.constant = 10
         videoLayer.isHidden = false // Show video layer for video content
     } else {
         audioVisualEffectView.isHidden = false
         channelNameLabel.text = ""
         commentBgView.isHidden = true
         audioEqualizerAnimView.pause()
         isVerfiedImgView.isHidden = true
         hashTagCVBottomLayout.constant = 0
         videoLayer.isHidden = true // Hide video layer for audio content
     }
     
     // Load hashtags
     if let hashtags = data.hashtags {
         self.hashtags = hashtags
         hashTagCollectionView.reloadData()
     }
     
     // Set video URL and update slider
     videoURL = playUrl.isEmpty ? nil : playUrl
     updateSliderValue()
 }
 
 private func setupUI() {
     // add font
     self.channelNameLabel.font = UIFont.inter(.bold, size: 14)
     self.songTitleLabel.font = UIFont.circularStd(.book, size: 24)
     self.songNameLabel.font = UIFont.inter(.regular, size: 14)
     self.albumNameLabel.font = UIFont.inter(.regular, size: 14)
     self.artistLabel.font = UIFont.inter(.regular, size: 14)
     self.loveCountLabel.font = UIFont.inter(.regular, size: 12)
     self.shareCountLabel.font = UIFont.inter(.regular, size: 12)
     self.commentCountLabel.font = UIFont.inter(.regular, size: 12)
     
     self.audioThumbImageView.layer.cornerRadius = 15.0
     self.audioThumbImageView.layer.borderWidth = 0.8
     self.audioThumbImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
     self.setupLottieJson()
     
     self.contentView.backgroundColor = .systemBackground
     self.videoLayer.backgroundColor = UIColor.clear.cgColor
     self.videoLayer.videoGravity = .resizeAspectFill
     self.thumbnailImageView.layer.addSublayer(videoLayer)
     self.selectionStyle = .none
     self.playPasueIconImgView.alpha = 0
     self.videoLayer.player?.play()
     self.stopSoundWaveAnimation()
     self.updateSliderValue()

     // Corner Circle Radius
     self.profileBtn.layer.cornerRadius = self.profileBtn.bounds.height / 2
     self.profileBtn.clipsToBounds = true
     self.musicTitleBgView.layer.cornerRadius = self.musicTitleBgView.bounds.height / 2
     self.musicTitleBgView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
     self.musicTitleBgView.layer.borderWidth = 0.8
     self.musicTitleBgView.clipsToBounds = true
     self.applyGradientToSlider()
     self.setupHashTagCollectionView()
 }

 private func setupLottieJson() {
     soundWaveAnimView.animation = LottieAnimation.named("equalizer_animation")
     soundWaveAnimView.loopMode = .loop
     soundWaveAnimView.animationSpeed = 0.9
     fullMusicAnimView.animation = LottieAnimation.named("play_animation_reels")
     fullMusicAnimView.loopMode = .loop
     fullMusicAnimView.play()
     fullMusicAnimView.animationSpeed = 1.0
     audioEqualizerAnimView.animation = LottieAnimation.named("audio_equalizer_animation")
     audioEqualizerAnimView.loopMode = .loop
     audioEqualizerAnimView.animationSpeed = 0.8
 }
 
 private func loveButtonClicked() {
     if isLoveBtnClick {
         self.loveBtn.setImage(UIImage(named: "LikeFill"), for: .normal)
         self.loveBtn.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
         self.loveCountLabel.text = "\(self.currentLoveCount + 1)"
         ShadhinShort.shared.loveCount = self.currentLoveCount + 1
         self.currentLoveCount = ShadhinShort.shared.loveCount
         UIView.animate(withDuration: 0.3,
                        delay: 0,
                        usingSpringWithDamping: 0.6,
                        initialSpringVelocity: 0.8,
                        options: [.curveEaseOut],
                        animations: {
             self.loveBtn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
         })
     } else {
         self.loveBtn.setImage(UIImage(named: "Like"), for: .normal)
         self.loveBtn.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
         self.loveCountLabel.text = "\(self.currentLoveCount - 1 > 0 ? self.currentLoveCount - 1 : 0)"
         ShadhinShort.shared.loveCount = self.currentLoveCount - 1 > 0 ? self.currentLoveCount - 1 : 0
         self.currentLoveCount = ShadhinShort.shared.loveCount

         UIView.animate(withDuration: 0.3,
                        delay: 0,
                        usingSpringWithDamping: 0.6,
                        initialSpringVelocity: 0.8,
                        options: [.curveEaseOut],
                        animations: {
             self.loveBtn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
         })
     }
     self.isLoveBtnClick.toggle()
 }
 
 private func setupLikeDislikeButtons() {
     if !ShadhinShort.shared.isLoved {
         self.viewModel.favoriteAddData(id: self.reelsContent?.id ?? 0, contentType: self.reelsContent?.contentType?.rawValue ?? "", completion: { isSuccess, error  in
             if isSuccess {
                 self.isLovedDisLoved?()
             }
         })

     } else {
         self.viewModel.favoriteDeleteData(id: self.reelsContent?.id ?? 0, contentType: self.reelsContent?.contentType?.rawValue ?? "", completion: { isSuccess, error  in
             if isSuccess {
                 self.isLovedDisLoved?()
             }
         })
     }
 }
 
 private func setupChannelFollowUnFollowing() {
     if !ShadhinShort.shared.isProfileFollow {
         self.viewModel.favoriteAddData(id: self.reelsContent?.owners?.first?.id ?? 0, contentType: "C", completion: { isSuccess, error  in
             if isSuccess {
                 self.isLovedDisLoved?()
             }
         })

     } else {
         self.viewModel.favoriteDeleteData(id: self.reelsContent?.owners?.first?.id ?? 0, contentType: "C", completion: { isSuccess, error  in
             if isSuccess {
                 self.isLovedDisLoved?()
             }
         })
     }
 }
 
 private func addTapGestureToTogglePlayback() {
     singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleVideoPauseOnOffTap))
     singleTapGesture.numberOfTapsRequired = 1
     contentView.addGestureRecognizer(singleTapGesture)
 }
 
 @objc private func handleVideoPauseOnOffTap() {
     let player = videoLayer.player
     isMediaPlaying.toggle()
     
     if !isMediaPlaying {
         self.playPasueIconImgView.image = UIImage(named: "PauseIcon")
         self.playPasueIconImgView.alpha = 0
         self.playPasueIconImgView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
         updateSliderValue()
         
         UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations: {
             self.playPasueIconImgView.alpha = 1
             self.playPasueIconImgView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
         })
     } else {
         self.playPasueIconImgView.image = UIImage(named: "PlayIcon")
         self.playPasueIconImgView.alpha = 1
         self.playPasueIconImgView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
         UIView.animate(withDuration: 0.3, delay: 0.01, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: [.curveEaseInOut], animations: {
             self.playPasueIconImgView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
             self.playPasueIconImgView.alpha = 0
         })
     }
     
     // MARK: - Play or Pause
     if isMediaPlaying {
         player?.play()
         
         if player?.timeControlStatus == .playing {
             startSoundWaveAnimation()
         } else {
             stopSoundWaveAnimation()
         }
         observePlayerBufferingState(player)
     } else {
         player?.pause()
         stopSoundWaveAnimation()
     }
     
     setupTimeObserver()
 }
 
 private func observePlayerBufferingState(_ player: AVPlayer?) {
     NotificationCenter.default.removeObserver(self, name: .AVPlayerItemPlaybackStalled, object: player?.currentItem)

     NotificationCenter.default.addObserver(forName: .AVPlayerItemPlaybackStalled, object: player?.currentItem, queue: .main) { [weak self] _ in
         DispatchQueue.main.async {
             self?.stopSoundWaveAnimation()
         }
     }

     player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.new, .initial], context: nil)
 }

 func startSoundWaveAnimation() {
     audioEqualizerAnimView.play()
     soundWaveAnimView.play()
     fullMusicAnimView.play()
 }
 
 func stopSoundWaveAnimation() {
     soundWaveAnimView.pause()
     audioEqualizerAnimView.pause()
     fullMusicAnimView.pause()
 }
}

// MARK: - Like/Love ImageView Setup
extension ShortsPlayerTVCell {
 private func addDoubleTapGestureForLove() {
     doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapLove))
     doubleTapGesture.numberOfTapsRequired = 2
     contentView.addGestureRecognizer(doubleTapGesture)
     singleTapGesture.require(toFail: doubleTapGesture)
 }
 
 private func setupLikeImageView() {
     likeImageView = UIImageView(image: UIImage(systemName: "heart.fill"))
     likeImageView.tintColor = .red
     likeImageView.alpha = 0
     likeImageView.contentMode = .scaleAspectFit
     likeImageView.translatesAutoresizingMaskIntoConstraints = false
     contentView.addSubview(likeImageView)
     
     NSLayoutConstraint.activate([
         likeImageView.widthAnchor.constraint(equalToConstant: 56),
         likeImageView.heightAnchor.constraint(equalToConstant: 56)
     ])
 }
 
 @objc private func handleDoubleTapLove(gesture: UITapGestureRecognizer) {
     let touchLocation = gesture.location(in: thumbnailImageView)
     likeImageView.center = touchLocation
     animateLikeImageView()
     if isLoveBtnClick {
         loveButtonClicked()
     }
 }
 
 private func animateLikeImageView() {
     likeImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
     likeImageView.alpha = 1
     
     UIView.animate(withDuration: 0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 0.8,
                    options: [.curveEaseOut]) {
         self.likeImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
     } completion: { _ in
         UIView.animate(withDuration: 0.3,
                        delay: 0.2,
                        usingSpringWithDamping: 0.8,
                        initialSpringVelocity: 1.0,
                        options: [.curveEaseInOut]) {
             self.likeImageView.alpha = 0
         }
     }
     
     let verticalAnimation = CABasicAnimation(keyPath: "position.y")
     verticalAnimation.fromValue = likeImageView.center.y
     verticalAnimation.toValue = likeImageView.center.y - 300
     verticalAnimation.duration = 0.6
     verticalAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
     verticalAnimation.fillMode = .forwards
     verticalAnimation.isRemovedOnCompletion = false
     likeImageView.layer.add(verticalAnimation, forKey: "verticalMovement")
     
     let horizontalOffset = CGFloat.random(in: -40...40)
     let horizontalAnimation = CABasicAnimation(keyPath: "position.x")
     horizontalAnimation.fromValue = likeImageView.center.x
     horizontalAnimation.toValue = likeImageView.center.x + horizontalOffset
     horizontalAnimation.duration = 0.6
     horizontalAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
     horizontalAnimation.fillMode = .forwards
     horizontalAnimation.isRemovedOnCompletion = false
     likeImageView.layer.add(horizontalAnimation, forKey: "horizontalMovement")
 }
}

// MARK: - ShortsPlayer Slider Setup
extension ShortsPlayerTVCell {
 
 func setupTimeObserver() {
     guard let player = videoLayer.player else { return }
     if let token = timeObserverToken, let oldPlayer = observedPlayer {
         oldPlayer.removeTimeObserver(token)
         timeObserverToken = nil
         observedPlayer = nil
     }
     
     let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
     timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
         guard let self = self else { return }
         
         let currentTimeInSeconds = CMTimeGetSeconds(time)
         if !currentTimeInSeconds.isNaN && currentTimeInSeconds.isFinite {
             DispatchQueue.main.async {
                 self.shortsPlaySlider.value = Float(currentTimeInSeconds)
                 if let duration = player.currentItem?.duration.seconds, duration.isFinite {
                     self.shortsPlaySlider.maximumValue = Float(duration)
                     self.sliderMaxValue = Float(duration)
                 }
                 self.updateSliderValue()
             }
         }
     }
     
     observedPlayer = player
 }
 
 func updateSliderValue() {
     guard let player = videoLayer.player else { return }
     let currentTime = CMTimeGetSeconds(player.currentTime())
     if !currentTime.isNaN && currentTime.isFinite {
         shortsPlaySlider.value = Float(currentTime)
     }
 }
 
 @objc private func sliderTapped(_ gestureRecognizer: UITapGestureRecognizer) {
     let point = gestureRecognizer.location(in: shortsPlaySlider)
     let percentage = point.x / shortsPlaySlider.bounds.width
     let delta = Float(percentage) * (shortsPlaySlider.maximumValue - shortsPlaySlider.minimumValue)
     let newValue = shortsPlaySlider.minimumValue + delta
     shortsPlaySlider.setValue(newValue, animated: true)
     
     let newTime = CMTimeMakeWithSeconds(Float64(newValue), preferredTimescale: 600)
     videoLayer.player?.seek(to: newTime)
 }
 
 private func applyGradientToSlider() {
     let gradientColors = [
         UIColor.hash(string: "#5AC8FA").cgColor,
         UIColor.hash(string: "#9394FF").cgColor
     ]
     let gradientImage = gradientImage(colors: gradientColors, size: CGSize(width: shortsPlaySlider.bounds.width, height: 1.2), cornerRadius: 1.2)
     let grayImage = UIImage(color: UIColor.white.withAlphaComponent(0.33), size: CGSize(width: shortsPlaySlider.bounds.width, height: 1.2), cornerRadius: 1.2)
     let normalThumb = UIImage(color: UIColor.white.withAlphaComponent(0), size: CGSize(width: 0.1, height: 0.1), cornerRadius: 0.05)
     let highlightedThumb = UIImage(color: UIColor.white, size: CGSize(width: 4.5, height: 4.5), cornerRadius: 4.5/2)
     shortsPlaySlider.setMinimumTrackImage(gradientImage, for: .normal)
     shortsPlaySlider.setMaximumTrackImage(grayImage, for: .normal)
     shortsPlaySlider.setThumbImage(normalThumb, for: .normal)
     shortsPlaySlider.setThumbImage(highlightedThumb, for: .highlighted)
     addTapGestureToSlider()
     updateSliderValue()
 }
 
 private func addTapGestureToSlider() {
     let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(_:)))
     shortsPlaySlider.addGestureRecognizer(tapGesture)
 }
}

// MARK: - ShortsPlayerView Visibleheight
extension ShortsPlayerTVCell: @preconcurrency PlayVideoLayerContainer {
 func visibleVideoHeight() -> CGFloat {
     let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(
         thumbnailImageView.frame,
         from: thumbnailImageView)
     guard let videoFrame = videoFrameInParentSuperView,
           let superViewFrame = superview?.frame else {
               return 0
           }
     let visibleVideoFrame = videoFrame.intersection(superViewFrame)
     return visibleVideoFrame.size.height
 }
}


// MARK: - HashTag CollectionView Setup
extension ShortsPlayerTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 func setupHashTagCollectionView() {
     hashTagCollectionView.delegate = self
     hashTagCollectionView.dataSource = self
     hashTagCollectionView.register(HashTagCVCell.nib(), forCellWithReuseIdentifier: HashTagCVCell.identifier)
     let layout = LeftAlignedCollectionViewFlowLayout()
     layout.minimumInteritemSpacing = 4
     layout.minimumLineSpacing = 3
     layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     hashTagCollectionView.collectionViewLayout = layout
 }
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return hashtags.count
 }
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HashTagCVCell.identifier, for: indexPath) as! HashTagCVCell
     cell.configureCell("#\(hashtags[indexPath.row].displayName ?? "")")
     hashTagHeightLayout.constant = hashTagCollectionView.contentSize.height
     cell.layoutIfNeeded()
     return cell
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     let text = "#\(hashtags[indexPath.row].displayName ?? "")"
     let font = UIFont.inter(.regular, size: 13)
     let padding: CGFloat = 6
     let textWidth = text.size(withAttributes: [.font: font]).width
     let width = ceil(textWidth + padding)
     return CGSize(width: width, height: 25)
 }
 
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     self.hashTagClicked?(hashtags[indexPath.row].id ?? 0)
 }
}


 */
