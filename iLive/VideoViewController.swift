//
//  VideoViewController.swift
//  iLive
//
//  Created by DucLT on 4/7/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import Alamofire
import FCFileManager

class VideoViewController: UIViewController {
    
    var item: LivePhotoItem?
    var index = 0
    var hud: MBProgressHUD!
    var screenType: ScreenType = .LiveWallpaperScreen
    var saving:Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var livePhotoView: PHLivePhotoView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let item = item, let video = item.video, let image = item.image {
            if screenType == .LiveWallpaperScreen || screenType == .FeaturedScreen {
                var videoPath: String
                if video.hasSuffix("/video.MOV") {
                    let urls = video.characters.split(separator: "/").map { String($0) }
                    videoPath = urls[urls.count - 2] + urls[urls.count - 1]
                } else {
                    videoPath = (video as NSString).lastPathComponent
                }
                
                var imagePath: String
                if image.hasSuffix("/pic.JPG") {
                    let urls = image.characters.split(separator: "/").map { String($0) }
                    imagePath = urls[urls.count - 2] + urls[urls.count - 1]
                } else {
                    imagePath = (image as NSString).lastPathComponent
                }
                if !FCFileManager.isFileItem(atPath: FCFileManager.pathForTemporaryDirectory(withPath: videoPath)) {
                    AppDelegate().sharedInstance().showLoading(isShow: true)
                    saveFileToDocumentWithPath(url: item.video!)
                } else {
                    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let imageUrl = directoryURL.appendingPathComponent(imagePath)
                    if let image = UIImage(contentsOfFile: imageUrl.path) {
                        PHLivePhoto.request(withResourceFileURLs: [URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(videoPath)),URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(imagePath))], placeholderImage: nil, targetSize: image.size, contentMode: .default, resultHandler: { (livePhoto, info) in
                            DispatchQueue.main.async {
                                AppDelegate().sharedInstance().showLoading(isShow: false)
                                
                                // ...Run something once we're done with the background task...
                                self.livePhotoView.livePhoto = livePhoto
                                self.livePhotoView.startPlayback(with: .full)
                            }
                        })
                    }
                }
            } else {
                AppDelegate().sharedInstance().showLoading(isShow: true)
                
                DispatchQueue.global(qos: .default).async {
                    
                    // ...Run some task in the background here...
                    var videoPath: String
                    if video.hasSuffix("/video.MOV") {
                        let urls = video.characters.split(separator: "/").map { String($0) }
                        videoPath = urls[urls.count - 2] + urls[urls.count - 1]
                    } else {
                        videoPath = (video as NSString).lastPathComponent
                    }
                    
                    var imagePath: String
                    if image.hasSuffix("/pic.JPG") {
                        let urls = image.characters.split(separator: "/").map { String($0) }
                        imagePath = urls[urls.count - 2] + urls[urls.count - 1]
                    } else {
                        imagePath = (image as NSString).lastPathComponent
                    }
                    
                    
                    if !FCFileManager.isFileItem(atPath: FCFileManager.pathForTemporaryDirectory(withPath: videoPath)) {
                        let assetIdentifier = NSUUID().uuidString
                        
                        let videoURL = NSURL(fileURLWithPath: video)
                        
                        self.storeMovieFile(videoUrlString: videoURL.path!, videoName: videoPath, assetIdentifier: assetIdentifier)
                        
                        if !self.saving {
                            
                            self.storeImageFile(imageUrlString: "", imageName: imagePath, assetIdentifier: assetIdentifier, completion: { (img) in
                                PHLivePhoto.request(withResourceFileURLs: [URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(videoPath)),URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(imagePath))], placeholderImage: nil, targetSize: img.size, contentMode: .default, resultHandler: { (livePhoto, info) in
                                    DispatchQueue.main.async {
                                        AppDelegate().sharedInstance().showLoading(isShow: false)
                                        
                                        // ...Run something once we're done with the background task...
                                        self.livePhotoView.livePhoto = livePhoto
                                        self.livePhotoView.startPlayback(with: .full)
                                    }
                                })
                                
                                
                            })
                        } else {
                            DispatchQueue.main.async {
                                AppDelegate().sharedInstance().showLoading(isShow: false)
                                
                                // ...Run something once we're done with the background task...
                            }
                        }
                    } else {
                        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let imageUrl = directoryURL.appendingPathComponent(imagePath)
                        if let image = UIImage(contentsOfFile: imageUrl.path) {
                            PHLivePhoto.request(withResourceFileURLs: [URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(videoPath)),URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(imagePath))], placeholderImage: nil, targetSize: image.size, contentMode: .default, resultHandler: { (livePhoto, info) in
                                DispatchQueue.main.async {
                                    AppDelegate().sharedInstance().showLoading(isShow: false)
                                    
                                    // ...Run something once we're done with the background task...
                                    self.livePhotoView.livePhoto = livePhoto
                                    self.livePhotoView.startPlayback(with: .full)
                                }
                            })
                        }
                        
                    }
                    
                }
                
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storeMovieFile(videoUrlString: String, videoName: String, assetIdentifier: String) {
        let videoDest = FilePaths.VidToLive.livePath.appending(videoName)
        if FileManager.default.fileExists(atPath: videoDest) {
            try! FileManager.default.removeItem(atPath: videoDest)
        }
        QuickTimeMov(path: videoUrlString).write(videoDest, assetIdentifier: assetIdentifier)
    }
    
    func storeImageFile(imageUrlString: String, imageName: String, assetIdentifier: String, completion:@escaping (_ img: UIImage) -> ()) {
        saving = true
        var img: UIImage?
        if screenType == .BlackWallpaperScreen {
            img = UIImage(named: imageName)
        } else {
            img = UIImage(contentsOfFile: imageUrlString)
        }
        if let image = img, let data = UIImagePNGRepresentation(image) {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let imageURL = urls[0].appendingPathComponent(imageName)
            if FileManager.default.fileExists(atPath: imageURL.path) {
                try! FileManager.default.removeItem(at: imageURL)
            }
            do {
                try data.write(to: imageURL, options: .atomic)
            } catch {
                print(error)
            }
            
            
            let imageDest = FilePaths.VidToLive.livePath.appending(imageName)
            if FileManager.default.fileExists(atPath: imageDest) {
                try! FileManager.default.removeItem(atPath: imageDest)
            }
            JPEG(path: imageURL.path).write(FilePaths.VidToLive.livePath.appending(imageName), assetIdentifier: assetIdentifier)
            self.saving = false
            if let image = UIImage(contentsOfFile: imageURL.path) {
                completion(image)
            }
        }
    }
    
    func saveFileToDocumentWithPath(url: String) {
        let assetIdentifier = NSUUID().uuidString
        //let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        //let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as NSString
        var videoName: String
        if url.hasSuffix("/video.MOV") {
            let urls = url.characters.split(separator: "/").map { String($0) }
            videoName = urls[urls.count - 2] + urls[urls.count - 1]
        } else {
            videoName = (url as NSString).lastPathComponent
        }
        
        //let videoDocPath = cachePath.stringByAppendingPathComponent(videoName)
        
        var videoLocalPath: URL?
        
        if let item = item, let image = item.image {
            var imageName: String
            if image.hasSuffix("/pic.JPG") {
                let urls = image.characters.split(separator: "/").map { String($0) }
                imageName = urls[urls.count - 2] + urls[urls.count - 1]
            } else {
                imageName = (image as NSString).lastPathComponent
            }
            //let imageDocPath = cachePath.stringByAppendingPathComponent(imageName)
            let tmpDirURL = NSURL.fileURL(withPath: NSTemporaryDirectory(),isDirectory: true)
            let pathComponent = videoName
            
            videoLocalPath = tmpDirURL.appendingPathComponent(pathComponent)
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (videoLocalPath!, [.createIntermediateDirectories, .removePreviousFile])
            }
//            let parameters: Parameters = ["foo": "bar"]
            
            Alamofire.download(url, method: .get, parameters: nil, encoding: JSONEncoding.default, to: destination)
                .response { response in
                    if let videoLocalPath = videoLocalPath {
                        self.storeMovieFile(videoUrlString: videoLocalPath.path, videoName: videoName, assetIdentifier: assetIdentifier)
                    }
                    var imageLocalPath: URL?
                    let tmpDirURL = NSURL.fileURL(withPath: NSTemporaryDirectory(),isDirectory: true)
                    let pathComponent = imageName
                    
                    imageLocalPath = tmpDirURL.appendingPathComponent(pathComponent)
                    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                        return (imageLocalPath!, [.createIntermediateDirectories, .removePreviousFile])
                    }
                    Alamofire.download(item.image!, method: .get, parameters: nil, encoding: JSONEncoding.default, to: destination)
                        .response { response in
                            AppDelegate().sharedInstance().showLoading(isShow: false)
                            if let imageLocalPath = imageLocalPath {
                                self.storeImageFile(imageUrlString: imageLocalPath.path, imageName: imageName, assetIdentifier: assetIdentifier, completion: { (img) in
                                    PHLivePhoto.request(withResourceFileURLs: [URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(videoName)),URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(imageName))], placeholderImage: nil, targetSize: img.size, contentMode: .default, resultHandler: { (livePhoto, info) in
                                        DispatchQueue.main.async {
                                            AppDelegate().sharedInstance().showLoading(isShow: false)
                                            
                                            // ...Run something once we're done with the background task...
                                            self.livePhotoView.livePhoto = livePhoto
                                            self.livePhotoView.startPlayback(with: .full)
                                        }
                                    })
                                })
                            }
                    }
            }
            
//            Alamofire.download(.GET, url, destination: { (tempUrl, response) -> NSURL in
//                let tmpDirURL = NSURL.fileURLWithPath(NSTemporaryDirectory(),isDirectory: true)
//                let pathComponent = videoName
//
//                videoLocalPath = tmpDirURL.URLByAppendingPathComponent(pathComponent)
//                return videoLocalPath!
//            }).response(completionHandler: { (request, response, data, error) in
//                if let videoLocalPath = videoLocalPath {
//                    self.storeMovieFile(videoLocalPath.path!, videoName: videoName, assetIdentifier: assetIdentifier)
//                }
//                var imageLocalPath: NSURL?
//                Alamofire.download(.GET, item.image!, destination: { (tempUrl, response) -> NSURL in
//                    let tmpDirURL = NSURL.fileURLWithPath(NSTemporaryDirectory(),isDirectory: true)
//                    let pathComponent = imageName
//
//                    imageLocalPath = tmpDirURL.URLByAppendingPathComponent(pathComponent)
//                    return imageLocalPath!
//                }).response(completionHandler: { (request, response, data, error) in
//                    self.hud.hide(true)
//                    if let imageLocalPath = imageLocalPath {
//                        self.storeImageFile(imageLocalPath.path!, imageName: imageName, assetIdentifier: assetIdentifier, completion: { (img) in
//                            PHLivePhoto.requestLivePhotoWithResourceFileURLs([NSURL(fileURLWithPath: FilePaths.VidToLive.livePath.stringByAppendingString(videoName)), NSURL(fileURLWithPath: FilePaths.VidToLive.livePath.stringByAppendingString(imageName))], placeholderImage: nil, targetSize: img.size, contentMode: .Default, resultHandler: { (livePhoto, info) in
//                                self.hud.hide(true)
//                                self.livePhotoView.livePhoto = livePhoto
//                                self.livePhotoView.startPlaybackWithStyle(.Full)
//                            })
//                        })
//                    }
//                })
//            })
            
        } else {
            AppDelegate().sharedInstance().showLoading(isShow: false)
        }
    }

}
