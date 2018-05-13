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
import GoogleMobileAds

enum ScreenType {
    case LiveWallpaperScreen
    case BlackWallpaperScreen
    case FeaturedScreen
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, GADInterstitialDelegate {
    
    
    var checkInApp = 0
    var indexSelected = 0
    var countClick = 0
    var videosArray : NSMutableArray = []
    var imagePreview: UIImageView!
    var doneButton: UIButton!
    var shareButton: UIButton!
    var settingButton: UIButton!
    var downloadButton: UIButton!
    var favoriteButton: UIButton!
    var backButton: UIButton!
    var hud: MBProgressHUD!
    var screenType: ScreenType!
    var purchased = false
    var interstitialAd: GADInterstitial!
    var bannerView : GADBannerView!
    var favoriteFile : NSMutableArray = []
    var lblDate : UILabel!
    var lblTime : UILabel!
    var timer = Timer()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitialAd = createAndLoadInterstitialAd()
        // Do any additional setup after loading the view.
        let initialViewController = viewControllerAtIndex(index: indexSelected)
        initialViewController.screenType = screenType
        setViewControllers([initialViewController], direction: .forward, animated: false, completion: nil)
        self.dataSource = self
        self.delegate = self
        
        initButtons()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        imagePreview = UIImageView(frame: view.bounds)
        view.addSubview(imagePreview)
    }
    
    // must be internal or public.
    @objc func update() {
        // Something cool
        let date = Date()
        formatter.dateFormat = "HH:mm"
        let result = formatter.string(from: date)
        lblTime.text = result
        formatter.dateFormat = "EEEE, MMM dd"
        let result1 = formatter.string(from: date)
        lblDate.text = result1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        createGADBannerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initButtons() -> Void {
        if (UserDefaults.standard.object(forKey: "favoriteFile") != nil) {
            favoriteFile = NSMutableArray.init(array: UserDefaults.standard.array(forKey: "favoriteFile")!)
        }
        
        lblDate = UILabel(frame: CGRect(x: (UIScreen.main.bounds.size.width - 200)/2, y: 130, width: 200, height: 50))
        lblDate.textAlignment = .center
        lblDate.textColor = .white
        lblDate.font = UIFont.systemFont(ofSize: 20)
        lblDate.tag = 1
        
        lblTime = UILabel(frame: CGRect(x: (UIScreen.main.bounds.size.width - 200)/2, y: 50, width: 200, height: 70))
        lblTime.textAlignment = .center
        lblTime.textColor = .white
        lblTime.font = UIFont.systemFont(ofSize: 80.0, weight: .thin)
        lblTime.tag = 1
        
        doneButton = UIButton(type: .custom)
        doneButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        doneButton.setImage(UIImage(named: "ic_back"), for: .normal)
        doneButton.backgroundColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
        doneButton.frame = CGRect(x: 20, y: 20, width: 50.0, height: 50.0)
        doneButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        doneButton.layer.borderWidth = 2.0
        doneButton.layer.borderColor = UIColor.white.cgColor
        doneButton.layer.cornerRadius = doneButton.frame.size.width/2
        doneButton.layer.masksToBounds = true
        doneButton.tag = 1
        
        downloadButton = UIButton(type: .custom)
        downloadButton.setTitle("Save", for: .normal)
        downloadButton.frame = CGRect(x: (view.frame.size.width - 60)/2, y: view.frame.size.height - 150, width: 60.0, height: 60.0)
        downloadButton.backgroundColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
        downloadButton.addTarget(self, action: #selector(downloadMovie), for: .touchUpInside)
        downloadButton.layer.borderWidth = 2.0
        downloadButton.layer.borderColor = UIColor.white.cgColor
        downloadButton.layer.cornerRadius = downloadButton.frame.size.width/2
        downloadButton.layer.masksToBounds = true
        downloadButton.tag = 1
        
        let padding : CGFloat = 80
        settingButton = UIButton(type: .custom)
        settingButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        settingButton.backgroundColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
        settingButton.setImage(UIImage(named: "ic_unfavorite"), for: .normal)
        settingButton.setImage(UIImage(named: "ic_favorite"), for: .selected)
        settingButton.imageView?.contentMode = .scaleAspectFit
        settingButton.frame = CGRect(x: view.frame.size.width/2 - 50 - padding, y: view.frame.size.height - 145, width: 50.0, height: 50.0)
        settingButton.addTarget(self, action: #selector(clickFavorite), for: .touchUpInside)
        settingButton.layer.borderWidth = 2.0
        settingButton.layer.borderColor = UIColor.white.cgColor
        settingButton.layer.cornerRadius = settingButton.frame.size.width/2
        settingButton.layer.masksToBounds = true
        settingButton.tag = 1
        if let item = videosArray[indexSelected] as? LivePhoto {
            if favoriteFile.contains(item.items?.image as Any) {
                settingButton.isSelected = true
            } else {
                settingButton.isSelected = false
            }
        } else if let item = videosArray[indexSelected] as? String {
            if favoriteFile.contains((item as NSString).lastPathComponent) {
                settingButton.isSelected = true
            } else {
                settingButton.isSelected = false
            }
        }
        
        shareButton = UIButton(type: .custom)
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 10, 5)
        shareButton.setImage(UIImage(named: "ic_share"), for: .normal)
        shareButton.backgroundColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.frame = CGRect(x: view.frame.size.width/2 + padding, y: view.frame.size.height - 145, width: 50.0, height: 50.0)
        shareButton.addTarget(self, action: #selector(shareFile), for: .touchUpInside)
        shareButton.layer.borderWidth = 2.0
        shareButton.layer.borderColor = UIColor.white.cgColor
        shareButton.layer.cornerRadius = shareButton.frame.size.width/2
        shareButton.layer.masksToBounds = true
        shareButton.tag = 1
        
        for button in self.view.subviews {
            if button.tag == 1 {
                button.removeFromSuperview()
            }
        }
        view.addSubview(lblDate)
        view.addSubview(lblTime)
        view.addSubview(doneButton)
        view.addSubview(downloadButton)
        view.addSubview(settingButton)
        view.addSubview(shareButton)
    }
    
    @objc func clickFavorite() {
        settingButton.isSelected = !settingButton.isSelected
        if let item = videosArray[indexSelected] as? LivePhoto {
            if settingButton.isSelected {
                favoriteFile.add(item.items?.image as Any)
            } else {
                favoriteFile.remove(item.items?.image as Any)
            }
        } else if let item = videosArray[indexSelected] as? String {
            if settingButton.isSelected {
                favoriteFile.add((item as NSString).lastPathComponent)
            } else {
                favoriteFile.remove((item as NSString).lastPathComponent)
            }
        }
        UserDefaults.standard.set(favoriteFile, forKey: "favoriteFile")
        UserDefaults.standard.synchronize()
    }
    
    @objc func shareFile() {
        var imageName: String = ""
        var videoName: String = ""
        if let item = videosArray[indexSelected] as? LivePhoto {
            if let video = item.items?.video, let image = item.items?.image {
                if video.hasSuffix("/video.MOV") {
                    let urls = video.characters.split(separator: "/").map { String($0) }
                    videoName = urls[urls.count - 2] + urls[urls.count - 1]
                } else {
                    videoName = (video as NSString).lastPathComponent
                }
                
                if image.hasSuffix("/pic.JPG") {
                    let urls = image.characters.split(separator: "/").map { String($0) }
                    imageName = urls[urls.count - 2] + urls[urls.count - 1]
                } else {
                    imageName = (image as NSString).lastPathComponent
                }
                
                if screenType == .BlackWallpaperScreen && FCFileManager.isFileItem(atPath: FCFileManager.pathForDocumentsDirectory(withPath: imageName)) {
                    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    
                    let localPath = directoryURL.appendingPathComponent(imageName)
                    let activityViewController = UIActivityViewController(activityItems: [localPath], applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = shareButton
                    self.present(activityViewController, animated: true, completion: nil)
                } else if screenType != .BlackWallpaperScreen && FCFileManager.isFileItem(atPath: FCFileManager.pathForTemporaryDirectory(withPath: videoName)) && FCFileManager.isFileItem(atPath: FCFileManager.pathForTemporaryDirectory(withPath: imageName)) {
                    let urlVideo : URL = NSURL(fileURLWithPath: FCFileManager.pathForTemporaryDirectory(withPath: videoName)) as URL
                    let activityViewController = UIActivityViewController(activityItems: [urlVideo], applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = shareButton
                    self.present(activityViewController, animated: true, completion: nil)
                }
            }
        } else if let item = videosArray[indexSelected] as? String {
            var imagePath: String
            imagePath = (item as NSString).lastPathComponent
            var videoPath = imagePath.replacingOccurrences(of: "imagexxx", with: "videoxxx")
            videoPath = videoPath.replacingOccurrences(of: ".jpg", with: "")
            let videoName = videoPath + ".mov";
            let filePath = Bundle.main.path(forResource: videoPath, ofType: "mov")
            
            let urlVideo : URL = NSURL(fileURLWithPath: FilePaths.VidToLive.livePath.appending(videoName)) as URL
            let activityViewController = UIActivityViewController(activityItems: [urlVideo], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = shareButton
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @objc func downloadMovie() {
        
        
        var imageName: String = ""
        var videoName: String = ""
        if let item = videosArray[indexSelected] as? LivePhoto {
            if let video = item.items?.video, let image = item.items?.image {
                if video.hasSuffix("/video.MOV") {
                    let urls = video.characters.split(separator: "/").map { String($0) }
                    videoName = urls[urls.count - 2] + urls[urls.count - 1]
                } else {
                    videoName = (video as NSString).lastPathComponent
                }
                
                if image.hasSuffix("/pic.JPG") {
                    let urls = image.characters.split(separator: "/").map { String($0) }
                    imageName = urls[urls.count - 2] + urls[urls.count - 1]
                } else {
                    imageName = (image as NSString).lastPathComponent
                }
                
                if screenType == .BlackWallpaperScreen && FCFileManager.isFileItem(atPath: FCFileManager.pathForDocumentsDirectory(withPath: imageName)) {
                    hud = MBProgressHUD(view: view)
                    view.addSubview(hud)
                    hud.mode = .indeterminate
                    hud.labelText = "Saving ..."
                    hud.show(true)
                    PHPhotoLibrary.shared().performChanges({
                        let request = PHAssetCreationRequest.forAsset()
                        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        
                        let localPath = directoryURL.appendingPathComponent(imageName)
                        
                        request.addResource(with: .photo, fileURL: localPath, options: nil)
                    }) { (success, error) in
                        DispatchQueue.main.async {
                            self.hud.hide(true)
                            //
                        }
                    }
                } else if screenType != .BlackWallpaperScreen && FCFileManager.isFileItem(atPath: FCFileManager.pathForTemporaryDirectory(withPath: videoName)) && FCFileManager.isFileItem(atPath: FCFileManager.pathForTemporaryDirectory(withPath: imageName)) {
                    hud = MBProgressHUD(view: view)
                    view.addSubview(hud)
                    hud.mode = .indeterminate
                    hud.labelText = "Saving ..."
                    hud.show(true)
                    PHPhotoLibrary.shared().performChanges({
                        let request = PHAssetCreationRequest.forAsset()
                        request.addResource(with: .photo, fileURL: NSURL(fileURLWithPath: FCFileManager.pathForTemporaryDirectory(withPath: imageName)) as URL, options: nil)
                        request.addResource(with: .pairedVideo, fileURL: NSURL(fileURLWithPath: FCFileManager.pathForTemporaryDirectory(withPath: videoName)) as URL, options: nil)
                    }) { (success, error) in
                        DispatchQueue.main.async {
                            self.hud.hide(true)
                            //
                        }
                    }
                }
            }
        } else if let item = videosArray[indexSelected] as? String{
            hud = MBProgressHUD(view: view)
            view.addSubview(hud)
            hud.mode = .indeterminate
            hud.labelText = "Saving ..."
            hud.show(true)
            var imagePath: String
            imagePath = (item as NSString).lastPathComponent
            var videoPath = imagePath.replacingOccurrences(of: "imagexxx", with: "videoxxx")
            videoPath = videoPath.replacingOccurrences(of: ".jpg", with: "")
            let videoName = videoPath + ".mov";
            let filePath = Bundle.main.path(forResource: videoPath, ofType: "mov")
            
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .photo, fileURL: NSURL(fileURLWithPath: FilePaths.VidToLive.livePath.appending(imagePath)) as URL, options: nil)
                request.addResource(with: .pairedVideo, fileURL: NSURL(fileURLWithPath: FilePaths.VidToLive.livePath.appending(videoName)) as URL, options: nil)
            }) { (success, error) in
                DispatchQueue.main.async {
                    self.hud.hide(true)
                    //
                }
            }
        }
    }
    
    @objc func closeView() {
        UIApplication.shared.isStatusBarHidden = false
        dismiss(animated: true) {
            
        }
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
            indexSelected = videoVC.index;
            initButtons()
            checkInApp += 1
            if checkInApp % 3 == 0 && checkInApp > 0 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabbarController = storyboard.instantiateViewController(withIdentifier: "InAppViewController")
                self.present(tabbarController, animated: true, completion: nil)
            }
        } else {
            initButtons()
        }
    }
    
    func viewControllerAtIndex(index: Int) -> VideoViewController {
        let imageViewController = storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        imageViewController.index = index
        imageViewController.item = videosArray[index]
        imageViewController.screenType = screenType
        return imageViewController
    }
    
    func createGADBannerView() -> Void {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = Constants.AdNetwork.AdmobBanner
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "eeb35843469fcc9d27a343f8b9183e6a","1ea46263048498a00a864fd59a2e47e1"]
        bannerView.load(request)
        addBannerViewToView(bannerView)
//        view.addSubview(bannerView)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func createAndLoadInterstitialAd() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: Constants.AdNetwork.AdmobInterstitial)
        interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "eeb35843469fcc9d27a343f8b9183e6a","1ea46263048498a00a864fd59a2e47e1"]
        interstitial.load(request)
        return interstitial
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        interstitialAd = createAndLoadInterstitialAd()
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial)  {
        print("Ad Received")
        if ad.isReady {
            if countClick % 3 == 0 {
                interstitialAd.present(fromRootViewController: self)
            }
        }
    }
}

