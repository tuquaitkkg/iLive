//
//  PageViewController.swift
//  iLive
//
//  Created by DucLT on 4/4/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import FCFileManager

enum ScreenType {
    case LiveWallpaperScreen
    case BlackWallpaperScreen
    case FeaturedScreen
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    
    var indexSelected = 0
    var videosArray = [LivePhotoItem]()
    var imagePreview: UIImageView!
    var doneButton: UIButton!
    var downloadButton: UIButton!
    var currentPage = 0
    var hud: MBProgressHUD!
    var screenType: ScreenType!
    var purchased = false
    //    var interstitialAd: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let initialViewController = viewControllerAtIndex(index: indexSelected)
        initialViewController.screenType = screenType
        setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
        self.dataSource = self
        self.delegate = self
        
        doneButton = UIButton(type: .custom)
        doneButton.imageEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10)
        doneButton.setImage(UIImage(named: "Done"), for: .normal)
        doneButton.frame = CGRect(x: view.frame.size.width - (51.0 + 9.0), y: 15.0, width: 51.0, height: 26.0)
        doneButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        downloadButton = UIButton(type: .system)
        downloadButton.tintColor = UIColor.white
        downloadButton.setImage(UIImage(named: "ic_download"), for:.normal)
        downloadButton.frame = CGRect(x: (self.view.frame.size.width - 40.0)/2, y: self.view.frame.size.height - 60.0, width: 40.0, height: 40.0)
        downloadButton.imageEdgeInsets = UIEdgeInsetsMake(-25, -25, -25, -25) // make click area bigger
        downloadButton.addTarget(self, action: #selector(downloadMovie), for: .touchUpInside)
        
        downloadButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        downloadButton.layer.shadowColor = UIColor.black.cgColor
        downloadButton.layer.shadowOpacity = 0.8
        
        view.addSubview(downloadButton)
        view.addSubview(doneButton)
        
        imagePreview = UIImageView(frame: view.bounds)
        view.addSubview(imagePreview)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closeView() {
        UIApplication.shared.isStatusBarHidden = false
        dismiss(animated: true) {
            
        }
    }
    
    @objc func downloadMovie() {
        
        
        //        var imageName: String = ""
        //        var videoName: String = ""
        //        let item = videosArray[indexSelected]
        //        if let video = item.video, image = item.image {
        //            if video.hasSuffix("/video.MOV") {
        //                let urls = video.characters.split("/").map { String($0) }
        //                videoName = urls[urls.count - 2] + urls[urls.count - 1]
        //            } else {
        //                videoName = (video as NSString).lastPathComponent
        //            }
        //
        //            if image.hasSuffix("/pic.JPG") {
        //                let urls = image.characters.split("/").map { String($0) }
        //                imageName = urls[urls.count - 2] + urls[urls.count - 1]
        //            } else {
        //                imageName = (image as NSString).lastPathComponent
        //            }
        //            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        //            let videoUrl = (paths.last! as NSString).stringByAppendingPathComponent(videoName)
        //            let imageUrl = (paths.last! as NSString).stringByAppendingPathComponent(imageName)
        //
        //            if screenType == .BlackWallpaperScreen && FCFileManager.isFileItemAtPath(FCFileManager.pathForDocumentsDirectoryWithPath(imageName)) {
        //                hud = MBProgressHUD(view: view)
        //                view.addSubview(hud)
        //                hud.mode = .Indeterminate
        //                hud.labelText = "Saving ..."
        //                hud.show(true)
        //                PHPhotoLibrary.sharedPhotoLibrary().performChanges({
        //                    let request = PHAssetCreationRequest.creationRequestForAsset()
        //                    let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        //
        //                    let localPath = directoryURL.URLByAppendingPathComponent(imageName)
        //
        //                    request.addResourceWithType(.Photo, fileURL: localPath, options: nil)
        //                }) { (success, error) in
        //                    dispatch_async(dispatch_get_main_queue(), {
        //                        self.hud.hide(true)
        //                        //
        //                    })
        //                }
        //            } else if screenType != .BlackWallpaperScreen && FCFileManager.isFileItemAtPath(FCFileManager.pathForTemporaryDirectoryWithPath(videoName)) && FCFileManager.isFileItemAtPath(FCFileManager.pathForTemporaryDirectoryWithPath(imageName)) {
        //                hud = MBProgressHUD(view: view)
        //                view.addSubview(hud)
        //                hud.mode = .Indeterminate
        //                hud.labelText = "Saving ..."
        //                hud.show(true)
        //                PHPhotoLibrary.sharedPhotoLibrary().performChanges({
        //                    let request = PHAssetCreationRequest.creationRequestForAsset()
        //                    request.addResourceWithType(.Photo, fileURL: NSURL(fileURLWithPath: FCFileManager.pathForTemporaryDirectoryWithPath(imageName)), options: nil)
        //                    request.addResourceWithType(.PairedVideo, fileURL: NSURL(fileURLWithPath: FCFileManager.pathForTemporaryDirectoryWithPath(videoName)), options: nil)
        //                }) { (success, error) in
        //                    dispatch_async(dispatch_get_main_queue(), {
        //                        self.hud.hide(true)
        //                        //
        //                    })
        //                }
        //            }
        //        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! VideoViewController).index
        if index == 0 {
            return nil
        }
        index = index - 1
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! VideoViewController).index
        if index + 1 == videosArray.count {
            return nil
        }
        
        index = index + 1
        return viewControllerAtIndex(index: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return videosArray.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let videoVC = viewControllers?.last as! VideoViewController
            currentPage = videoVC.index
        }
    }
    
    func viewControllerAtIndex(index: Int) -> VideoViewController {
        let imageViewController = storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        imageViewController.index = index
        imageViewController.item = videosArray[index]
        imageViewController.screenType = screenType
        return imageViewController
    }
}

