//
//  LoadingViewController.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/5/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import UIKit

class LoadingViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWallpapers()
    }
    
    func getPhotos<Service: Gettable>(fromService service: Service) where Service.Data == [LivePhotoResponse] {
        service.get { [weak self] (result) in
            switch result {
            case .Success(let photos):
                DataStore.sharedInstance.categoryList = photos
//                self?.downloadFeatured(completionHandle: {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if !(UserDefaults.standard.bool(forKey: Constants.firstTime)) {
                    appDelegate.setupRootView()
                } else {
                    appDelegate.setupMainView()
                }
                
//                })

            case .Failure(_):
                self?.showAlertView()
                break
            }
        }
    }
//
    func downloadFeatured(completionHandle:@escaping () -> ()) {
        APIManager.downloadFile(urlString: Constants.API.FeaturedFileUrl) { (response, error) in
            if let _ = error {
                self.showAlertView()
            } else if let _ = response {
                let file = "Feaured.txt" //this is the file. we will write to and read from it

                if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
                    let path = NSURL(fileURLWithPath: dir).appendingPathComponent(file)

                    //reading
                    do {
                        let text = try NSString(contentsOf: path!, encoding: String.Encoding.utf8.rawValue).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                        if text.count > 0 {
                            let featuredStrings = text.components(separatedBy: "\r\n")
                            for i in 0...4 {
                                var featured = Featured()
                                featured.name = featuredStrings[i * 2]
                                featured.image = featuredStrings[i * 2 + 1]
                                DataStore.sharedInstance.featuredList.append(featured)
                                completionHandle()
                            }

                        }
                    }
                    catch {/* error handling here */}
                }
            }
        }
    }
//
    func loadWallpapers() {
        var photoService = LivePhotoService()
        photoService.path = Constants.API.LiveWallpaper
        getPhotos(fromService: photoService)
    }
//
    func showAlertView() {
        let alertController = UIAlertController(title: "Error", message: "Loading failed. Do you want try again ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let reloadAction = UIAlertAction(title: "Reload", style: .default) { (action) in
            self.loadWallpapers()
        }
        alertController.addAction(reloadAction)
        present(alertController, animated: true, completion: nil)
    }
}
