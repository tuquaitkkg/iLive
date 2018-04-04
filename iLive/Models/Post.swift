//
//  Post.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/7/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import Foundation
import ObjectMapper

struct Post: Mappable {
    var postId: String?
    var image: String?
    var video: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        postId <- map["id"]
        image <- map["image"]
        video <- map["video"]
    }
}

struct PostResponse: Mappable {
    var post: Post?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        post <- map["post"]
    }
}

struct Posts: Mappable {
    var posts: [PostResponse]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        posts <- map["posts"]
    }
}
