//
//  DataStore.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/5/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import Foundation

class DataStore {
    
    static let sharedInstance = DataStore()
    var categoryList = [LivePhotoResponse]()
    var blackWallpaperList = [BlackWallpaper]()
    var featuredList = [Featured]()
    var counter = 0
    private init() { }
}
