//
//  LivePhoto.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/4/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import Foundation
import ObjectMapper

class LivePhotoItem: NSObject, Mappable {
    var image: String?
    var video: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        image <- map["image"]
        video <- map["video"]
    }
}

struct LivePhoto: Mappable {
    var category: String?
    var index: Int?
    var count: Int?
    var items: [LivePhotoItem]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        category <- map["category"]
        index <- map["index"]
        count <- map["count"]
        items <- map["items"]
    }
}

struct LivePhotoResponse: Mappable {
    var livePhotos: [LivePhoto]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        livePhotos <- map["livephotos"]
    }
}
