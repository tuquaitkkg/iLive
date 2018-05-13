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
    var newArray : NSMutableArray = []
    var counter = 0
    var purchased = false

    @IBOutlet weak var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.adUnitID = Constants.AdNetwork.AdmobBanner
        bannerView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "eeb35843469fcc9d27a343f8b9183e6a","1ea46263048498a00a864fd59a2e47e1"]
        bannerView.load(request)
        
        if titleCategory == "" || titleCategory.isEmpty {
            titleCategory = "New"
        }
        navigationItem.title = titleCategory
        
        
        
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
        newArray = []
        if titleCategory == "New" {
            let files = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: nil)
            newArray.addObjects(from: files);
            for fileName in newArray {
                if (fileName as! String).contains("Start") {
                    newArray.remove(fileName)
                }
            }
            newArray.addObjects(from: DataStore.sharedInstance.categoryList[0].livePhotos!);
        } else {
            if (UserDefaults.standard.object(forKey: "favoriteFile") != nil) {
                var favorite : NSMutableArray = []
                favorite = NSMutableArray.init(array: UserDefaults.standard.array(forKey: "favoriteFile")!)
                for fileName in favorite {
                    if (fileName as! String).contains("offline") {
                        let file = Bundle.main.path(forResource: fileName as? String, ofType: nil)
                        newArray.add(file as Any)
                    } else {
                        var online:[LivePhoto] = [LivePhoto]()
                        online = DataStore.sharedInstance.categoryList[0].livePhotos!;
                        let filtered_list = online.filter({$0.items?.image == (fileName as! String)})
                        newArray.addObjects(from: filtered_list)
                    }
                }
                
            }
        }
        self.clListWallpaper.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
        cell.imageView.image = nil;
        cell.imageView.sd_cancelCurrentImageLoad()
        if let item = newArray[indexPath.row] as? LivePhoto {
            cell.imageView.sd_setImage(with: NSURL(string: item.items!.image!) as URL?, placeholderImage: nil)
        } else if let item = newArray[indexPath.row] as? String {
            cell.imageView.image = UIImage(contentsOfFile: item)
        }
        
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
            pageViewController.videosArray = newArray
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
    
//    func imageManager(_ imageManager: SDWebImageManager, transformDownloadedImage image: UIImage?, with imageURL: URL?) -> UIImage? {
//        guard let image = image, let imageURL = imageURL else {
//            return nil
//        }
//        print(imageURL)
//        let size : CGSize
//        let screenSize = UIScreen.main.bounds.size
//        if UI_USER_INTERFACE_IDIOM() == .phone {
//            size = CGSize(width: screenSize.width/3 - 1, height: (screenSize.width/3 - 1)*screenSize.height/screenSize.width)
//        } else {
//            size = CGSize(width: screenSize.width/5 - 1, height: (screenSize.width/5 - 1)*screenSize.height/screenSize.width)
//        }
//        UIGraphicsBeginImageContextWithOptions(size, !SDCGImageRefContainsAlpha(image.cgImage), 2)
//        image.draw(in: CGRect(origin: .zero, size: size))
//        
//        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return scaledImage
//    }

}
