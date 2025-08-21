//
//  String+Ex.swift
//  Shadhin_shorts_Test
//
//  Created by Shadhin Music on 9/4/25.
//


import Foundation
import UIKit

extension String {
    func imageSizeParser(contentType: String?) -> String {
        let size: String
        switch contentType {
        case "SA", "SP":
            size = "300"
        case "SV":
            size = "480"
        default:
            size = "300"
        }
        return self.replacingOccurrences(of: "<$size$>", with: size)
    }
}

extension String {
    
    var imageURL : String{
        return self.replacingOccurrences(of: "<$size$>", with: "\(300)")
    }
    var image300 : String{
        return self.replacingOccurrences(of: "<$size$>", with: "\(300)").safeUrl()
    }
    var image450 : String{
        return self.replacingOccurrences(of: "<$size$>", with: "\(450)").safeUrl()
    }
    
    var image480 : String{
        return self.replacingOccurrences(of: "<$size$>", with: "\(480)").safeUrl()
    }
    var image596 : String{
        return self.replacingOccurrences(of: "<$size$>", with: "\(596)").safeUrl()
    }
    
    //"596"
    var image1280 : String{
        
        let url = self.replacingOccurrences(of: "<$size$>", with: "\(1280)").safeUrl()
        print("url",url, self)
        return url
    }
    var image980 : String{
        return self.replacingOccurrences(of: "<$size$>", with: "\(980)").safeUrl()
    }
    var htmlToAttributedString: NSMutableAttributedString? {
        do {
            guard let data = data(using: .utf8) else { return NSMutableAttributedString(string: "") }
            let returnStr = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            return returnStr
        } catch {
            return NSMutableAttributedString(string: "")
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
  
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func attributedStringFromHTML(_ color: UIColor = .secondaryLabel, completionBlock: @escaping (NSAttributedString?) ->()) {
        
        guard let data = data(using: .utf8) else {
            return completionBlock(nil)
        }
        
        DispatchQueue.main.async{
            if let attributedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil){
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor : color], range: NSRange(location: 0, length: attributedString.length))
                completionBlock(attributedString)
            } else {
                completionBlock(nil)
            }
        }
    }
    
    func stringFromHTML(_ color: UIColor = .secondaryLabel, completionBlock: @escaping (String?) ->()) {
        guard let data = data(using: .utf8) else {
            return completionBlock(nil)
        }
        DispatchQueue.main.async{
            if let attributedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil){
                attributedString.addAttributes([NSAttributedString.Key.foregroundColor : color], range: NSRange(location: 0, length: attributedString.length))
                completionBlock(attributedString.string)
            } else {
                completionBlock(nil)
            }
        }
    }
    
    func safeUrl(_ size: ImageSize? = nil) -> String{
        var rStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if let size = size{
            rStr = rStr.replacingOccurrences(of: "<$size$>", with: size.rawValue)
        }
        rStr = rStr.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? ""
        return rStr
    }
   
    func widthOfAttributedString(withFont font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        return attributedString.size().width
    }
    
    func heightOfAttributedString(withFont font: UIFont, width: CGFloat) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = attributedString.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    var validURL: Bool {
            get {
                let regEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
                let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
                return predicate.evaluate(with: self)
            }
        }
}

enum ImageSize: String{
    case BillboardBanner = "596"
}


// MARK: - URL Validation Extension
extension URL {
    var isValidMediaURL: Bool {
        let validSchemes = ["http", "https"]
        guard let scheme = scheme, validSchemes.contains(scheme.lowercased()) else { return false }
        guard host != nil else { return false }
        return pathExtension.lowercased().isMediaFileExtension
    }
}

extension String {
    var isAudioFile: Bool {
        let audioExtensions = ["mp3", "m4a", "wav", "aac"]
        return audioExtensions.contains(pathExtension.lowercased())
    }
    
    var isVideoFile: Bool {
        let videoExtensions = ["mp4", "mov", "m4v"]
        return videoExtensions.contains(pathExtension.lowercased())
    }
}

extension String {
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
}

extension String {
    var isMediaFileExtension: Bool {
        let mediaExtensions = ["mp3", "m4a", "wav", "aac", "mp4", "mov", "m4v"]
        return mediaExtensions.contains(pathExtension.lowercased())
    }
}


extension Int {
    var formattedCount: String {
        switch self {
        case 0..<1_000:
            return "\(self)"
        case 1_000..<1_000_000:
            let formatted = Double(self) / 1_000
            return String(format: "%.1fK", formatted).replacingOccurrences(of: ".0", with: "")
        case 1_000_000..<1_000_000_000:
            let formatted = Double(self) / 1_000_000
            return String(format: "%.1fM", formatted).replacingOccurrences(of: ".0", with: "")
        case 1_000_000_000...:
            let formatted = Double(self) / 1_000_000_000
            return String(format: "%.1fB", formatted).replacingOccurrences(of: ".0", with: "")
        default:
            return "\(self)"
        }
    }
}
extension String{
    func adsImage(with size : String) -> String{
        if self.contains("<$size$>"){
            return self.replacingOccurrences(of: "<$size$>", with: size).replacingOccurrences(of: " ", with: "%20").safeUrl()
        }
        return self.replacingOccurrences(of: " ", with: "%20").safeUrl()
    }
    var img21 : String{
        if self.contains("<$size$>"){
            return self.replacingOccurrences(of: "<$size$>", with: "\(288)").replacingOccurrences(of: " ", with: "%20")
        }
        return self
    }
    var img288 : String{
        if self.contains("<$size$>"){
            return self.replacingOccurrences(of: "<$size$>", with: "\(288)").replacingOccurrences(of: " ", with: "%20")
        }
        return self
    }
    var img300 : String{
        if self.contains("<$size$>"){
            return self.replacingOccurrences(of: "<$size$>", with: "\(300)").replacingOccurrences(of: " ", with: "%20")
        }
        return self
    }
    var img1280: String{
        if self.contains("<$size$>"){
            return self.replacingOccurrences(of: "<$size$>", with: "\(1280)").replacingOccurrences(of: " ", with: "%20")
        }
        return self
    }
    var img984: String{
        if self.contains("<$size$>"){
            return self.replacingOccurrences(of: "<$size$>", with: "\(984)").replacingOccurrences(of: " ", with: "%20")
        }
        return self
    }
    var img800 : String{
        if self.contains("<$size$>"){
            return self.replacingOccurrences(of: "<$size$>", with: "\(800)").replacingOccurrences(of: " ", with: "%20")
        }
        return self
    }
    var img596: String{
        if self.contains("<$size$>"){
            return self.replacingOccurrences(of: "<$size$>", with: "\(596)").replacingOccurrences(of: " ", with: "%20").safeUrl()
        }
        return self.safeUrl()
    }
    func getImageUrl(for size : Int)-> String{
        if self.contains("<$size$>"){
            return self.replacingOccurrences(of: "<$size$>", with: "\(size)").replacingOccurrences(of: " ", with: "%20")
        }
        var str = self.replacingOccurrences(of: " ", with: "%20")
        if let indx = self.lastIndex(of: "."){
            str.insert(contentsOf: "_mybl", at: indx)
        }
        
        return str
    }
    
    func getImageUrl(for size : String)-> String{
        if self.contains("<$size$>"){
            return self.replacingOccurrences(of: "<$size$>", with: size).replacingOccurrences(of: " ", with: "%20").safeUrl()
        }
        var str = self.replacingOccurrences(of: " ", with: "%20")
        if let index = self.lastIndex(of: "."){
            str.insert(contentsOf: size, at: index)
        }
        return str.safeUrl()
    }
    
   
    var mmmmDYyyy : String?{
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormate.date(from: self){
            let dd = DateFormatter()
            dd.dateFormat = "MMMM d, yyyy"
            return dd.string(from: date)
        }
        
        return nil
    }
    var time : String{
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormate.date(from: self){
            let ff = DateFormatter()
            ff.timeStyle = .short
            return ff.string(from: date)
        }
        return ""
    }
    
}


extension Bundle {
    static var bundle : Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: ShadhinShort.self)
        #endif
    }
}




// MARK: ---- Latter Based Image Generate ----

extension String {
    func letterAvatar(
        size: CGSize = CGSize(width: 80, height: 80),
        font: UIFont = UIFont.systemFont(ofSize: 36, weight: .bold)
    ) -> UIImage {
        
        let character = self.first?.uppercased() ?? "?"
        let color = characterColor(character)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }

        let rect = CGRect(origin: .zero, size: size)

        // Background circle with light version of the color
        context.setFillColor(color.withAlphaComponent(0.1).cgColor)
        context.fillEllipse(in: rect)

        // Circle border
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(2)
        context.strokeEllipse(in: rect.insetBy(dx: 1, dy: 1))

        // Draw the character
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]

        let attributedString = NSAttributedString(string: character, attributes: attributes)
        let textSize = attributedString.size()
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )

        attributedString.draw(in: textRect)

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }

    private func characterColor(_ char: String) -> UIColor {
        let colors: [UIColor] = [
            .systemRed,
            .systemBlue,
            .systemGreen,
            .systemOrange,
            .systemPink,
            .systemTeal,
            .systemPurple,
            .systemYellow,
            .brown,
            .magenta,
            .cyan,
            UIColor(red: 0.5, green: 0.2, blue: 0.8, alpha: 1),
            UIColor(red: 0.3, green: 0.7, blue: 0.5, alpha: 1),
            UIColor(red: 0.6, green: 0.3, blue: 0.7, alpha: 1),
            UIColor(red: 0.7, green: 0.4, blue: 0.2, alpha: 1),
            UIColor(red: 0.1, green: 0.3, blue: 0.7, alpha: 1),
            UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1),
            UIColor(red: 0.8, green: 0.3, blue: 0.4, alpha: 1),
            UIColor(red: 0.3, green: 0.8, blue: 0.6, alpha: 1),
            UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1),
            UIColor(red: 0.9, green: 0.6, blue: 0.1, alpha: 1),
            UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1),
            UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1),
            UIColor(red: 0.7, green: 0.2, blue: 0.3, alpha: 1),
            UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1),
            UIColor(red: 0.8, green: 0.5, blue: 0.3, alpha: 1)
        ]

        guard let firstChar = char.uppercased().unicodeScalars.first,
              let ascii = firstChar.isASCII ? firstChar.value : nil,
              ascii >= 65 && ascii <= 90 else {
            return .darkGray // fallback for non A-Z
        }

        let index = Int(ascii - 65) // 'A' = 65 → index 0
        return colors[index % colors.count]
    }
}


private var waveBarsKey: UInt8 = 0

extension UIView {
    
    private var waveBars: [UIView] {
        get {
            return objc_getAssociatedObject(self, &waveBarsKey) as? [UIView] ?? []
        }
        set {
            objc_setAssociatedObject(self, &waveBarsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setupAudioWaveBars(numberOfBars: Int = 5, barWidth: CGFloat = 5, barSpacing: CGFloat = 50, barColor: UIColor = .white) {
        waveBars.forEach { $0.removeFromSuperview() }
        waveBars.removeAll()
        
        let totalWidth = CGFloat(numberOfBars) * (barWidth + barSpacing)
        let startX = (self.bounds.width - totalWidth) / 2

        var newBars: [UIView] = []
        
        for i in 0..<numberOfBars {
            let bar = UIView()
            bar.backgroundColor = barColor
            bar.layer.cornerRadius = barWidth / 2
            bar.frame = CGRect(x: startX + CGFloat(i) * (barWidth + barSpacing),
                               y: self.bounds.height / 2,
                               width: barWidth,
                               height: 50)
            self.addSubview(bar)
            newBars.append(bar)
        }

        self.waveBars = newBars
    }

    func startAudioWaveAnimation() {
        for (index, bar) in waveBars.enumerated() {
            let delay = Double(index) * 0.2
            let animation = CABasicAnimation(keyPath: "transform.scale.y")
            animation.fromValue = 1.0
            animation.toValue = 2.0
            animation.duration = 0.4
            animation.beginTime = CACurrentMediaTime() + delay
            animation.autoreverses = true
            animation.repeatCount = .infinity
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            bar.layer.add(animation, forKey: "wave")
        }
    }

    func stopAudioWaveAnimation() {
        for bar in waveBars {
            bar.layer.removeAnimation(forKey: "wave")
        }
    }
}
