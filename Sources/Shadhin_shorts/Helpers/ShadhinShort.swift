//
//  ShadhinShort.swift
//  Shadhin_shorts_Test
//
//  Created by Shadhin Music on 24/3/25.
//

import Foundation
import UIKit


struct VideoMoreMenuItems {
    var title: String
    var subTitle: String?
    var image: UIImage?
    var isRed: Bool? = false
    var reportDetails: String?
    
    init(title: String, subTitle: String? = nil, image: UIImage? = nil, isRed: Bool? = nil, reportDetails: String? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.image = image
        self.isRed = isRed
        self.reportDetails = reportDetails
    }
}

@objc final public class ShadhinShort : NSObject {
    
    @MainActor public static let shared = ShadhinShort()
    
    var viewModel = AudioReelsViewModel()
    
    // MARK: --- Properties ---
    var loveCount: Int = 0
    var isLoved: Bool = false
    var isFavoriteUnFav: Bool = false
    private let defaults = UserDefaults.standard

     // MARK: --- Boolean Flags ---
     public var hasSeenIntro: Bool {
         get { defaults.bool(forKey: "hasSeenIntro") }
         set { defaults.set(newValue, forKey: "hasSeenIntro") }
     }

     public var isPremiumUser: Bool {
         get { defaults.bool(forKey: "isPremiumUser") }
         set { defaults.set(newValue, forKey: "isPremiumUser") }
     }

     public var isLoggedIn: Bool {
         get { defaults.bool(forKey: "isLoggedIn") }
         set { defaults.set(newValue, forKey: "isLoggedIn") }
     }

     public var isNotificationEnabled: Bool {
         get { defaults.bool(forKey: "isNotificationEnabled") }
         set { defaults.set(newValue, forKey: "isNotificationEnabled") }
     }
    
    public var isProfileFollow: Bool {
         get { defaults.bool(forKey: "isProfileFollow") }
         set { defaults.set(newValue, forKey: "isProfileFollow") }
     }
    
    
    // MARK: --- Methods ---

    @MainActor func openSocialMediaLink(name: String, fallbackURL: String) {
        var appURL: URL?

        switch name.uppercased() {
        case "FACEBOOK":
            appURL = URL(string: "fb://facewebmodal/f?href=\(fallbackURL)")
            
        case "INSTAGRAM":
            appURL = URL(string: "instagram://user?username=shadhin.music")
            
        case "YOUTUBE":
            appURL = URL(string: "youtube://www.youtube.com/@shadhinmusicofficial")
            
        default:
            break
        }

        if let appURL = appURL, UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let url = URL(string: fallbackURL) {
            UIApplication.shared.open(url)
        }
    }
    
    
    @MainActor public func setupChannelFollowUnFollowing(id: Int, contentType: String) {
        if !ShadhinShort.shared.isProfileFollow {
            self.viewModel.favoriteAddData(id: id, contentType: contentType, completion: { isSuccess, error  in
                self.isFavoriteUnFav = isSuccess
                self.isProfileFollow = false
            })

        } else {
            self.viewModel.favoriteDeleteData(id: id, contentType: contentType, completion: { isSuccess, error  in
                self.isFavoriteUnFav = isSuccess
                self.isProfileFollow = true

            })
        }
    }
    
    @MainActor public func setupLikeDislikeButtons(id: Int, contentType: String) {
        if !ShadhinShort.shared.isLoved {
            self.viewModel.favoriteAddData(id: id, contentType: contentType, completion: { isSuccess, error  in
                self.isFavoriteUnFav = isSuccess
            })

        } else {
            self.viewModel.favoriteDeleteData(id: id, contentType: contentType, completion: { isSuccess, error  in
                self.isFavoriteUnFav = isSuccess
            })
        }
    }
    
    var videoMenuFirstItems = [
        VideoMoreMenuItems(title: "Interested",
                           subTitle: "You will see more shorts like this",
                           image: UIImage(systemName: "plus.circle")),

        VideoMoreMenuItems(title: "Not Interested",
                           subTitle: "You will see less shorts like this",
                           image: UIImage(systemName: "minus.circle")),

        VideoMoreMenuItems(title: "Report this Short",
                           subTitle: "I am concerned about this Short",
                           image: UIImage(systemName: "exclamationmark.circle"),
                           isRed: true)
    ]
    
    var videoMenuSecondItems = [
        VideoMoreMenuItems(title: "Bullying, harassment or abuse",
                           reportDetails: "Evidently, there is some overlap between bullying and harassment, and often the two are used interchangeably to describe any intimidating, unreasonable and/or offensive behaviour directed toward an individual or group of individuals."),
        
        VideoMoreMenuItems(title: "Violent or disturbing content",
                           reportDetails: "Content that depicts or glorifies violence, suffering, or any disturbing acts can negatively impact viewers and is not appropriate for most audiences."),
        
        VideoMoreMenuItems(title: "Promoting restricted items",
                           reportDetails: "This includes any content that endorses or advertises the sale or distribution of items that are regulated or banned by law, such as drugs, firearms, or counterfeit goods."),
        
        VideoMoreMenuItems(title: "Adult content",
                           reportDetails: "Material that contains explicit sexual content or nudity which is not suitable for all audiences and often breaches platform guidelines."),
        
        VideoMoreMenuItems(title: "Scam or fraud",
                           reportDetails: "Content that deceives or attempts to deceive individuals for financial gain or other purposes. This includes phishing, false promises, or any other fraudulent activities."),
        
        VideoMoreMenuItems(title: "False information",
                           reportDetails: "Dissemination of false or misleading information which can cause harm, create panic, or mislead individuals."),
       
        VideoMoreMenuItems(title: "I don't want to see this",
                           reportDetails: "Content that a user may personally find objectionable or irrelevant, regardless of its general acceptability."),
        
        VideoMoreMenuItems(title: "Using unauthorized music",
                           reportDetails: "Incorporating music in content without proper rights or permissions from the copyright holders, which is a violation of intellectual property laws.")
    ]
    
    var reelsContent: ReelsContent?
    var reportSubmitImage: UIImage? = UIImage(named: "reportSuccess")
    var isErrorText: String? = nil
    
    
    @MainActor public func formattedTimeAgo(from dateString: String) -> String {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSS"
        ]
        
        for format in formats {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.dateFormat = format
            if let date = df.date(from: dateString) {
                return ShadhinShort.shared.timeAgoSince(date)
            }
        }
        return ""
    }
    public func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        return "Just now"
        
    }

}

// MARK: - Coordinator

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

protocol NIBVCProtocol{
    static func instantiateNib() async -> Self
}

extension NIBVCProtocol where Self: UIViewController {
    @MainActor static func instantiateNib() -> Self {
        return self.init(
            nibName: String(describing: self),
            bundle: Bundle.shadhinShorts
        )
    }
}

extension Bundle{
    static var shadhinShorts : Bundle {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle(for: HomePopupVC.self)
#endif
    }
}


