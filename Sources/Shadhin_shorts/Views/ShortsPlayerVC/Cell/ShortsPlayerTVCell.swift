//
//  ShortsPlayerTVCell.swift
//  LabelSwift
//
//  Created by Shadhin Music on 25/8/25.
//

import UIKit
import AVFoundation
import Lottie
import Kingfisher
import Alamofire

@MainActor
class ShortsPlayerTVCell: UITableViewCell {
    
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
    
    // MARK: - UI Elements (Programmatic Outlets)
    private let channelNameLabel: UILabel = UILabel()
    private let songTitleLabel: UILabel = UILabel()
    private let thumbnailImageView: UIImageView = UIImageView()
    private let profileBtn: UIButton = UIButton(type: .system)
    private let profileFollowBtn: UIButton = UIButton(type: .system)
    private let loveBtn: UIButton = UIButton(type: .system)
    private let commentBtn: UIButton = UIButton(type: .system)
    private let shareBtn: UIButton = UIButton(type: .system)
    private let moreBtn: UIButton = UIButton(type: .system)
    private let fullMusicBtn: UIButton = UIButton(type: .system)
    private let loveCountLabel: UILabel = UILabel()
    private let commentCountLabel: UILabel = UILabel()
    private let commentBgView: UIView = UIView()
    private let shareCountLabel: UILabel = UILabel()
    private let songNameLabel: UILabel = UILabel()
    private let albumNameLabel: UILabel = UILabel()
    private let artistLabel: UILabel = UILabel()
    private let soundWaveAnimView: LottieAnimationView = LottieAnimationView()
    private let musicTitleBgView: UIView = UIView()
    private let fullMusicAnimView: LottieAnimationView = LottieAnimationView()
    private let playPasueIconImgView: UIImageView = UIImageView()
    private let isVerfiedImgView: UIImageView = UIImageView()
    private let shortsPlaySlider: UISlider = UISlider()
    private let hashTagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 3
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let hashTagHeightLayout: NSLayoutConstraint!
    private let hashTagCVBottomLayout: NSLayoutConstraint!
    
    // MARK: - Audio UI Elements
    private let audioThumbImageView: UIImageView = UIImageView()
    private let audioVisualEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let audioBgView: UIView = UIView()
    private let audioEqualizerAnimView: LottieAnimationView = LottieAnimationView()
    
    // MARK: - Closure Methods
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        videoLayer.player = nil
        videoLayer.isHidden = true
        videoURL = nil
        stopSoundWaveAnimation()
        hashtags.removeAll()
        reelsContent = nil
        loveCountLabel.text = "0"
        commentCountLabel.text = "0"
        shareCountLabel.text = "0"
        isLoveBtnClick = true
        ShadhinShort.shared.isLoved = false
        loveBtn.setImage(UIImage(named: "Like"), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer.frame = contentView.bounds
    }
    
    // MARK: - Actions
    @objc private func didTapChannelBtnAction() {
        didTapChannelBtnClick?()
    }
    
    @objc private func didTapChannelFollowBtnAction() {
        profileFollowBtn.setBackgroundImage(ShadhinShort.shared.isProfileFollow ? UIImage(named: "UnFollowing") : UIImage(named: "Following"), for: .normal)
        setupChannelFollowUnFollowing()
        ShadhinShort.shared.isProfileFollow.toggle()
    }
    
    @objc private func loveBtnAction() {
        loveButtonClicked()
        setupLikeDislikeButtons()
    }
    
    @objc private func commentBtnAction() {
        didTappedCommentBtn?()
    }
    
    @objc private func shareBtnAction() {
        // Handle share button action
    }
    
    @objc private func moreBtnAction() {
        didTapthreeDotMenuClick?(reelsContent?.streamingURL?.isVideoFile ?? false)
    }
    
    @objc private func fullMusicBtnAction() {
        // Handle full music button action
    }
    
    @objc private func sliderValueDidChange() {
        // Handle slider value change
    }
}

// MARK: - Private Methods
extension ShortsPlayerTVCell {
    func configureCell(data: ReelsContent, playUrl: String, isVideo: Bool, allFavoriteData: [Favorite]) {
        self.reelsContent = data
        
        if let imageUrl = URL(string: data.imageURL?.imageSizeParser(contentType: data.contentType?.rawValue ?? "") ?? "") {
            thumbnailImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"))
            audioThumbImageView.kf.setImage(with: imageUrl)
        } else {
            thumbnailImageView.image = UIImage(named: "placeholder")
            audioThumbImageView.image = UIImage(named: "placeholder")
        }
        
        songTitleLabel.text = data.baseContent?.title ?? "Unknown Title"
        albumNameLabel.text = data.artists?.first?.name ?? "Unknown Artist"
        songNameLabel.text = data.baseContent?.title ?? "Unknown Title"
        
        if allFavoriteData.contains(where: { $0.contentId == data.id && $0.contentType == data.contentType?.rawValue ?? "" }) {
            isLoveBtnClick = false
            ShadhinShort.shared.isLoved = true
            loveBtn.setImage(UIImage(named: "LikeFill"), for: .normal)
        } else {
            isLoveBtnClick = true
            ShadhinShort.shared.isLoved = false
            loveBtn.setImage(UIImage(named: "Like"), for: .normal)
        }
        
        if allFavoriteData.contains(where: { $0.contentId == data.owners?.first?.id }) {
            ShadhinShort.shared.isProfileFollow = true
            profileFollowBtn.setBackgroundImage(UIImage(named: "Following"), for: .normal)
        } else {
            ShadhinShort.shared.isProfileFollow = false
            profileFollowBtn.setBackgroundImage(UIImage(named: "UnFollowing"), for: .normal)
        }
        
        ShadhinShort.shared.loveCount = data.analytics?.favoritesCount ?? 0
        currentLoveCount = ShadhinShort.shared.loveCount
        loveCountLabel.text = "\(data.analytics?.favoritesCount ?? 0)"
        commentCountLabel.text = "\(data.analytics?.commentsCount ?? 0)"
        shareCountLabel.text = "\(data.analytics?.sharesCount ?? 0)"
        
        if isVideo {
            audioVisualEffectView.isHidden = true
            audioEqualizerAnimView.pause()
            channelNameLabel.text = data.owners?.first?.name ?? ""
            isVerfiedImgView.isHidden = !(data.owners?.first?.isVerified ?? false)
            hashTagCVBottomLayout.constant = 10
            videoLayer.isHidden = false
        } else {
            audioVisualEffectView.isHidden = false
            channelNameLabel.text = ""
            commentBgView.isHidden = true
            audioEqualizerAnimView.pause()
            isVerfiedImgView.isHidden = true
            hashTagCVBottomLayout.constant = 0
            videoLayer.isHidden = true
        }
        
        if let hashtags = data.hashtags {
            self.hashtags = hashtags
            hashTagCollectionView.reloadData()
        }
        
        videoURL = playUrl.isEmpty ? nil : playUrl
        updateSliderValue()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = .resizeAspectFill
        contentView.layer.addSublayer(videoLayer)
        selectionStyle = .none
        playPasueIconImgView.alpha = 0
        
        // Configure labels
        channelNameLabel.font = .inter(.bold, size: 14)
        songTitleLabel.font = .circularStd(.book, size: 24)
        songNameLabel.font = .inter(.regular, size: 14)
        albumNameLabel.font = .inter(.regular, size: 14)
        artistLabel.font = .inter(.regular, size: 14)
        loveCountLabel.font = .inter(.regular, size: 12)
        shareCountLabel.font = .inter(.regular, size: 12)
        commentCountLabel.font = .inter(.regular, size: 12)
        
        // Add subviews and constraints (simplified layout; adjust as needed)
        let stackView = UIStackView(arrangedSubviews: [channelNameLabel, songTitleLabel, songNameLabel, albumNameLabel, artistLabel, loveCountLabel, commentCountLabel, shareCountLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6)
        ])
        
        // Add buttons and other views with similar constraints
        [profileBtn, profileFollowBtn, loveBtn, commentBtn, shareBtn, moreBtn, fullMusicBtn].forEach { btn in
            btn.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(btn)
        }
        NSLayoutConstraint.activate([
            profileBtn.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 20),
            profileBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileBtn.widthAnchor.constraint(equalToConstant: 40),
            profileBtn.heightAnchor.constraint(equalToConstant: 40),
            
            profileFollowBtn.topAnchor.constraint(equalTo: profileBtn.topAnchor),
            profileFollowBtn.leadingAnchor.constraint(equalTo: profileBtn.trailingAnchor, constant: 8),
            profileFollowBtn.widthAnchor.constraint(equalToConstant: 80),
            profileFollowBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Setup Lottie animations
//        setupLottieJson()
        
        // Apply corner radii and gradients
        profileBtn.layer.cornerRadius = 20
        musicTitleBgView.layer.cornerRadius = 20
        musicTitleBgView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        musicTitleBgView.layer.borderWidth = 0.8
        applyGradientToSlider()
        setupHashTagCollectionView()
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
