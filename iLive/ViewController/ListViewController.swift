//
//  ListViewController.swift
//  iLive
//
//  Created by DucLT on 4/4/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SDWebImage

class ListViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, SDWebImageManagerDelegate {
    
    @IBOutlet weak var clListWallpaper: UICollectionView!
    var titleCategory = ""
    var arrayWallpaper = [LivePhoto]()
    var counter = 0
    var purchased = false

    @IBOutlet weak var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.adUnitID = Constants.AdNetwork.AdmobBannerTest
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "eeb35843469fcc9d27a343f8b9183e6a","1ea46263048498a00a864fd59a2e47e1"]
        bannerView.load(request)
        
        if titleCategory == "" || titleCategory.isEmpty {
            titleCategory = "New"
        }
        navigationItem.title = titleCategory
        arrayWallpaper = DataStore.sharedInstance.categoryList[0].livePhotos!
//        for livePhoto in DataStore.sharedInstance.categoryList {
////            if livePhoto.category?.lowercased() == titleCategory.lowercased() {
//                arrayWallpaper = livePhoto
//                break
////            }
//        }
        
        let screenSize = UIScreen.main.bounds.size
        if UI_USER_INTERFACE_IDIOM() == .phone {
            let flow = clListWallpaper.collectionViewLayout as! UICollectionViewFlowLayout
            flow.itemSize = CGSize(width: screenSize.width/3 - 1, height: (screenSize.width/3 - 1)*screenSize.height/screenSize.width)
            clListWallpaper.collectionViewLayout = flow
        } else {
            let flow = clListWallpaper.collectionViewLayout as! UICollectionViewFlowLayout
            flow.itemSize = CGSize(width: screenSize.width/5 - 1, height: (screenSize.width/5 - 1)*screenSize.height/screenSize.width)
            clListWallpaper.collectionViewLayout = flow
        }
        
        clListWallpaper.register(UINib(nibName: "WallpaperCell", bundle: nil), forCellWithReuseIdentifier: "WallpaperCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        purchased = UserDefaults.standardUserDefaults().boolForKey(WallpaperProduct.AllWallpapers)
//        if purchased {
//            bannerHeight.constant = 0
//        } else {
//            bannerHeight.constant = 50
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SDWebImageManager.shared().delegate = self;
    }

    @IBAction func showMenu(_ sender: Any) {
        frostedViewController.presentMenuViewController()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayWallpaper.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
        let item = arrayWallpaper[indexPath.row]
        cell.imageView.sd_setImage(with: NSURL(string: item.items!.image!) as URL?, placeholderImage: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clListWallpaper.deselectItem(at: indexPath, animated: false)
        counter = counter + 1
//        if counter < 6
//            || WallpaperProduct.store.isProductPurchased(WallpaperProduct.AllWallpapers)
//        {
            let pageViewController = storyboard!.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
            pageViewController.countClick = counter
            pageViewController.indexSelected = indexPath.item
            pageViewController.videosArray = arrayWallpaper
            pageViewController.screenType = .LiveWallpaperScreen
            pageViewController.purchased = purchased
            present(pageViewController, animated: true, completion: nil)
//        } else {
//            let alertController = UIAlertController(title: "Purchase", message: "You reached maximum times to view live wallpapers. Please go to Home tab to unlock all.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                self.tabBarController?.selectedIndex = 3
//            })
//            alertController.addAction(okAction)
//            
//            present(alertController, animated: true, completion: nil)
//        }
    }
    
    func imageManager(_ imageManager: SDWebImageManager, transformDownloadedImage image: UIImage?, with imageURL: URL?) -> UIImage? {
        guard let image = image, let imageURL = imageURL else {
            return nil
        }
        print(imageURL)
        let size : CGSize
        let screenSize = UIScreen.main.bounds.size
        if UI_USER_INTERFACE_IDIOM() == .phone {
            size = CGSize(width: screenSize.width/3 - 1, height: (screenSize.width/3 - 1)*screenSize.height/screenSize.width)
        } else {
            size = CGSize(width: screenSize.width/5 - 1, height: (screenSize.width/5 - 1)*screenSize.height/screenSize.width)
        }
        UIGraphicsBeginImageContextWithOptions(size, !SDCGImageRefContainsAlpha(image.cgImage), 2)
        image.draw(in: CGRect(origin: .zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }

}
