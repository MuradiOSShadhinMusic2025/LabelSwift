//
//  ShadhinApiHeaders.swift
//  Shadhin_shorts
//
//  Created by Maruf on 8/4/25.
//

import Foundation

public class ShadhinShortsApiContants {
    
    var token = "DX4B1PK1q0KjX2J5HTsGML46io6xTc2FcJeoWayG8fEzoQt8rGEGyUe9ae4OfvMY1cRklvlbBLwNwGk9YbJuod2pjWk6eYeszFBB+WlPZ4Ufgr1/Zlf+7JXWEeqln5EOi7LKm1DsXMlN2wH/wgK60jQ0EOwmnkuaZ528IgrR1RcqDNRjQ8+ZHFoCgwROFKKLEJbMolFkRvBXZjYrAHlVbrU6FvACfEh8FGeblz6/t9QlbECakAg4tQwWe0M1Mo56lno11JId+UcbeTMPCWGy1h13XGE63VsHOwXBwYkeS4DqLUi0tFUyDFhZE7SFhtfs9yI0KGmYSExIVGnB4Ivjo4/kp7DapqFdZ5NxCBVVNixcWhO2s8LztLQgoryfignNKhATqZkQPrJ/eQxTeq/HIHQrxEme+kWgI9DYe0+SQCnBhW3rym55kdYjTZK6NWH3+3Y6wgqndvYwm24v8LRJneIDMa11ckdeKOve4xxUdG0qWV86dH87fq07xa58gOdRBtVRt24rPOz8VO8N059gZb4z9PsheJ/GJsvukZmyQJGO73I/CHzTAZohtekAIKkIG7lhs7oNt5uPhf32owc7rRWqjfH08uaEA4qc5Cn/6jBFrSby65FLFf28HlS/D3eBfGPvQKiCGiN3TxRrZmUDqfeJAGD4z9OWJ/bLUmFMLMzJSpxucwvcf4pXswYC65wzHUErIYF1U6tkUdpncgBVmaiQPpSnh+9+DfwZ/RmSbpXJ3yeax1rmHG1JW7BzQ6jLy6eCx/d1SPuSlVipV3Nz+z8gpqaxCUtVA0WkilEXhmWjptZSiUo3Gur7npCytxf1zxaId5OGaU3TxYxtTsYVbsnDfJ1buMOioiOEcxBoo2LpVTMnGLUs+ZKIQLkibd4jggPlar8/lj7QeJeWDR1/6j30rQuLHH4qQ7Jap/UjNDIdMFeCR5P4Qffe/axFRYRNoRGPFG6PRb2WtpUyDKj38cwbdnDg9w9+FSaABCN/5d3jRZgmXuPVZf9xO7K/jVpFbYqQEyh4HGm0JQ+0kfUihJ7rx2re8m3elkzBUNNOqvFofBO8KDbMv00hlhBT4F5DVyL8O6pd3UmVjFM78J9BlQlx5ZXISN6a2Yi0X5A620iy5vs9nJS4/39pRfLjMXvUs9yHn9IhYQi9hNpfRGD1eQ2s0eICSCZ1xSGETVGT8yPFXNYvsW42nxuPKstVWoTx:yONSk7x+VgpIaQwkPq9m3Q=="
    
    var API_HEADER: HTTPHeaders {
        get{
            var header = [
                "Token" : !(ShadhinCore.instance.defaults.userSessionToken.isEmpty) ? ShadhinCore.instance.defaults.userSessionToken : "aU9T",
                "Content-Type" : "application/json"
            ]
//            if !ShadhinCore.instance.defaults.userSessionToken.isEmpty{
//                header["Authorization"] = "Bearer \(ShadhinCore.instance.defaults.userSessionToken)"
//            }
//            header["countryCode"] = ShadhinCore.instance.defaults.geoLocation.lowercased()
            
            header["Authorization"] = "Bearer \(token)"
            header["DeviceType"] =  "iOS"
            header["User-Agent"] = "SM Shorts Player"
            
            return  HTTPHeaders.init(header)
        }
    }
    
    
}

public class ShadhinCore{
    
    static let instance = ShadhinCore()
    
    let api: ShadhinShortsApi
    let defaults: ShadhinDefaults
    
    // TODO: - NEED TO REMOVE IT
    // static var dummyIsSubscribed = false
    
    private init(){
        defaults = ShadhinDefaults()
        api = ShadhinShortsApi()
    }
    
}


class ShadhinDefaults {
    let userDefault = UserDefaults.standard
    
    init() {
       
    }
    
    var userSessionToken: String {
        get { return userDefault.string(forKey: #function) ?? ""}
        set {
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    
    var popUpShownIds: [String]{
        get{
            return userDefault.stringArray(forKey: #function) ?? [String]()
        }
        set {
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    
    var playerSkipLimitTimestamp: Double{
        get {
            return userDefault.double(forKey: #function)
        }
        set {
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    
    var playerSkipCount: Int{
        get {
            return userDefault.integer(forKey: #function)
        }
        set {
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    
    var locationGetTimeStamp: Double{
        get {
            return userDefault.double(forKey: #function)
        }
        set {
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    

    
    var totalPlayedDuration: Int{
        get {
            return userDefault.integer(forKey: #function)
        }
        set {
            userDefault.set(newValue, forKey: #function)
            userDefault.synchronize()
        }
    }
    
    
    func setCodable<T: Codable>(_ value: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            userDefault.set(encoded, forKey: key)
        }
    }
    
    func codable<T: Codable>(forKey key: String) -> T? {
        if let data = userDefault.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(T.self, from: data) {
                return decoded
            }
        }
        return nil
    }
}
