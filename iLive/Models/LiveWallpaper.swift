//
//  LiveWallpaper.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/4/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import Foundation
import ObjectMapper

struct WallpaperImage: Mappable {
    var pic: String?
    var video: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        pic <- map["pic"]
        video <- map["video"]
    }
}

struct Saves: Mappable {
    var href: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        href <- map["href"]
    }
}

struct Links: Mappable {
    var saves: Saves?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        saves <- map["saves"]
    }
}

struct LiveWallpaper: Mappable {
    var liveWallpaperId: Int?
    var image: WallpaperImage?
    var saves: Int?
    var links: Links?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        liveWallpaperId <- map["id"]
        image <- map["image"]
        saves <- map["saves"]
        links <- map["links"]
    }
}

struct Meta: Mappable {
    var total: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        total <- map["total"]
    }
}

struct LiveWallpaperResponse: Mappable {
    var liveWallpapers: [LiveWallpaper]?
    var meta: Meta?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        liveWallpapers <- map["live_wallpapers"]
        meta <- map["meta"]
    }
}
