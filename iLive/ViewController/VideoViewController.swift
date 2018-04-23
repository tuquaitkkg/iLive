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
    
    var item: Any?
    var index = 0
    var hud: MBProgressHUD!
    var screenType: ScreenType = .LiveWallpaperScreen
    var saving:Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var livePhotoView: PHLivePhotoView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let item = item as? LivePhoto, let video = item.items?.video, let image = item.items?.image {
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
                    saveFileToDocumentWithPath(url: (item.items?.video)!)
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
        } else if let item = item as? String{
            var imagePath: String
            imagePath = (item as NSString).lastPathComponent
            var videoPath = imagePath.replacingOccurrences(of: "imagexxx", with: "videoxxx")
            videoPath = videoPath.replacingOccurrences(of: ".jpg", with: "")
            let videoName = videoPath + ".mov";
            if !FCFileManager.isFileItem(atPath: FilePaths.VidToLive.livePath.appending(videoName)) {
                AppDelegate().sharedInstance().showLoading(isShow: true)
                if let filePath = Bundle.main.path(forResource: videoPath, ofType: "mov") {
                    saveFileToDocumentWithPath(url: filePath)
                }
            } else {
                if let image = UIImage(contentsOfFile: FilePaths.VidToLive.livePath.appending(imagePath)) {
                    PHLivePhoto.request(withResourceFileURLs: [URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(videoName)),URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(imagePath))], placeholderImage: nil, targetSize: image.size, contentMode: .default, resultHandler: { (livePhoto, info) in
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
        
        if let item = item as? LivePhoto, let image = item.items?.image {
            var videoLocalPath: URL?
            var videoName: String
            if url.hasSuffix("/video.MOV") {
                let urls = url.characters.split(separator: "/").map { String($0) }
                videoName = urls[urls.count - 2] + urls[urls.count - 1]
            } else {
                videoName = (url as NSString).lastPathComponent
            }
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
                    Alamofire.download((item.items?.image)!, method: .get, parameters: nil, encoding: JSONEncoding.default, to: destination)
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
        } else if let item = item as? String{
            var imagePath: String
            imagePath = (item as NSString).lastPathComponent
            var videoPath = imagePath.replacingOccurrences(of: "imagexxx", with: "videoxxx")
            videoPath = videoPath.replacingOccurrences(of: ".jpg", with: "")
            let videoName = videoPath + ".mov";
            if let filePath = Bundle.main.path(forResource: videoPath, ofType: "mov") {
                self.storeMovieFile(videoUrlString: filePath, videoName: videoName, assetIdentifier: assetIdentifier)
            }
//            if let imageLocalPath = item {
                self.storeImageFile(imageUrlString: item, imageName: imagePath, assetIdentifier: assetIdentifier, completion: { (img) in
                    PHLivePhoto.request(withResourceFileURLs: [URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(videoName)),URL.init(fileURLWithPath: FilePaths.VidToLive.livePath.appending(imagePath))], placeholderImage: nil, targetSize: img.size, contentMode: .default, resultHandler: { (livePhoto, info) in
                        DispatchQueue.main.async {
                            AppDelegate().sharedInstance().showLoading(isShow: false)
                            
                            // ...Run something once we're done with the background task...
                            self.livePhotoView.livePhoto = livePhoto
                            self.livePhotoView.startPlayback(with: .full)
                        }
                    })
                })
//            }
            AppDelegate().sharedInstance().showLoading(isShow: false)
        }
    }

}
