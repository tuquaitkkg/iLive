//
//  BaseViewController.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/8/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import UIKit
//import GoogleMobileAds

class BaseViewController: UIViewController {

//    var interstitialAd: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        interstitialAd = createAndLoadInterstitialAd()
    }
    
    func showInformationAlert(title: String, message: String) {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }

}

//extension BaseViewController: GADInterstitialDelegate {
//    func createAndLoadInterstitialAd() -> GADInterstitial {
//        let interstitial = GADInterstitial(adUnitID: Constants.AdNetwork.AdmobInterstitial)
//        interstitial.delegate = self
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID, "eeb35843469fcc9d27a343f8b9183e6a"]
//        interstitial.loadRequest(request)
//        return interstitial
//    }
//
//    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
//        interstitialAd = createAndLoadInterstitialAd()
//    }
//}

