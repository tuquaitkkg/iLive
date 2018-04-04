//
//  FirstFeatured.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/15/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import Foundation
import ObjectMapper

struct FirstFeatured: Mappable {
    var jpg_url: String?
    var mov_url: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        jpg_url <- map["jpg_url"]
        mov_url <- map["mov_url"]
    }
}

struct FirstFeaturedResponse: Mappable {
    var count: Int?
    var data: [FirstFeatured]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        count <- map["count"]
        data <- map["data"]
    }
}
