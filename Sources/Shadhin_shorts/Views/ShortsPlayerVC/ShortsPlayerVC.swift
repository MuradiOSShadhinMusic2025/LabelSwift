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
        // প্রথমবার visible cell টা play করানো
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
