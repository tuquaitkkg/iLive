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
    var id: String?
    var image: String?
    var video: String?
    var category: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        image <- map["image"]
        video <- map["video"]
        category <- map["category"]
        image = "http://webservice.pixsterstudio.com/images/" + image!.trimmingCharacters(in: .whitespaces)
        video = "http://webservice.pixsterstudio.com/videos/" + video!.trimmingCharacters(in: .whitespaces)
    }
}

struct LivePhoto: Mappable {
//    var category: String?
    var items: LivePhotoItem?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        items <- map["post"]
    }
}

struct LivePhotoResponse: Mappable {
    var livePhotos: [LivePhoto]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        livePhotos <- map["posts"]
    }
}
