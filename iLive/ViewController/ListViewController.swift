//
//  ListViewController.swift
//  iLive
//
//  Created by DucLT on 4/4/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ListViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var clListWallpaper: UICollectionView!
    var titleCategory = ""
    var arrayWallpaper = [LivePhotoItem]()
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
        for livePhoto in DataStore.sharedInstance.categoryList {
            if livePhoto.category?.lowercased() == titleCategory.lowercased() {
                arrayWallpaper = livePhoto.items!
                break
            }
        }
        
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
        let item = arrayWallpaper[indexPath.item]
        cell.imageView.sd_setImage(with: NSURL(string: item.image!) as URL?, placeholderImage: nil)
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

}
