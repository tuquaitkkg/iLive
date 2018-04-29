//
//  BaseViewController.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/8/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BaseViewController: UIViewController {

    var interstitialAd: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton: UIButton = UIButton(type: .custom)
        doneButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        doneButton.setImage(UIImage(named: "ic_list"), for: .normal)
        doneButton.frame = CGRect(x: 10, y: 10, width: 40.0, height: 40.0)
        doneButton.addTarget(self, action: #selector(showMenuView), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: doneButton)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        // Do any additional setup after loading the view.
        interstitialAd = createAndLoadInterstitialAd()
    }
    
    @objc func showMenuView() {
        frostedViewController.presentMenuViewController()
    }
    
    func showInformationAlert(title: String, message: String) {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }

}

extension BaseViewController: GADInterstitialDelegate {
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
}

