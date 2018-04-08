//
//  Constants.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/4/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import Foundation
import UIKit

struct FilePaths {
    static let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask,true)[0] as AnyObject
    struct VidToLive {
        static var livePath = FilePaths.documentsPath
    }
}

struct Constants {
    
    static var ScreenWidth: CGFloat {
        let screenRect = UIScreen.main.bounds
        return screenRect.size.width
    }
    
    static let PhoneColumns: CGFloat = 3.0
    static let PadColumns: CGFloat = 5.0
    
    struct API {
        static let LiveWallpaper = "http://www.novasoft.ro/wallpapers/items.json"
        static let BlackWallpaper = "https://www.dropbox.com/sh/dzwoc18vug3iptg/AAAUG8H3WdEn8a_ZCNO0mEV9a?dl=0"
        static let FeaturedFileUrl = "https://dl.dropboxusercontent.com/s/lwdbonwvxcizx0m/tien.txt"
        static let Featured1 = "http://livewallpapers.ticktockapps.com/livephoto/res/images?app=livepapers233&page=1&version=1.1.0"
        static let Featured2 = "http://sct.duckdns.org/live_wallpapers?application=03.50.011&limit=53&offset=0"
        static let Featured3 = "http://sct.duckdns.org/live_wallpapers?application=03.51.010&limit=28&offset=0"
        static let Featured4 = "http://sct.duckdns.org/live_wallpapers?application=03.50.009&limit=26&offset=0"
        static let Featured5 = "http://www.webservice.pixsterstudio.com/livewallpaper.php?key=dYrtr3GGPVuhSMvm"
        static let Featured5VideoUrl = "http://www.webservice.pixsterstudio.com/videos/"
        static let Featured5ImageUrl = "http://www.webservice.pixsterstudio.com/images/"
        static let FeaturedBaseUrl = "http://sct.duckdns.org"
    }
    
    struct AdNetwork {
        static let AdmobInterstitial = "ca-app-pub-1947012962477196/3445976267"
        static let AdmobBanner = "ca-app-pub-1947012962477196/7876175862"
    }
    
    struct NotificationIdentifier {
        
    }
    
    struct Settings {
        static let barColor = UIColor(hex: 0x161618)
        static let backgroundColor = UIColor(hex: 0x2a292d)
    }
}
