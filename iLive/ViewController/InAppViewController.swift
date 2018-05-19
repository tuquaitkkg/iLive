//
//  InAppViewController.swift
//  iLive
//
//  Created by DucLT on 5/13/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit

class InAppViewController: UIViewController, TTTAttributedLabelDelegate {

    @IBOutlet weak var lblDetail: TTTAttributedLabel!
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnBuy.titleLabel?.lineBreakMode = .byWordWrapping;
        btnBuy.titleLabel?.textAlignment = .center
        guard
            let font1 = UIFont(name: "HelveticaNeue-Bold", size: 20),
            let font2 = UIFont(name: "HelveticaNeue", size: 16),
            let font3 = UIFont(name: "HelveticaNeue-Bold", size: 12) else { return }
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let titleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : font1,
            NSAttributedStringKey.paragraphStyle : style,
            ]
        let subtitleAttributes = [
            NSAttributedStringKey.font : font2,
            NSAttributedStringKey.paragraphStyle : style,
            NSAttributedStringKey.foregroundColor : UIColor.black
        ]
        
        let attributedString = NSMutableAttributedString(string: "FREE TRIAL", attributes: titleAttributes)
        attributedString.append(NSAttributedString(string: "\n"))
        attributedString.append(NSAttributedString(string: "Free for 3 days, then $2.99 per week", attributes: subtitleAttributes))
        btnBuy.setAttributedTitle(attributedString, for: .normal)
        
        self.view.layoutIfNeeded()
        btnBuy.layer.masksToBounds = true
        btnBuy.layer.cornerRadius = btnBuy.bounds.size.height/2
        
        btnExit.layer.masksToBounds = true
        btnExit.layer.cornerRadius = btnExit.bounds.size.height/2
        btnExit.layer.borderWidth = 2.0
        btnExit.layer.borderColor = UIColor.white.cgColor
        btnExit.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        
        let titleAttributes1: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : font3,
            NSAttributedStringKey.paragraphStyle : style,
            ]
        let str = "Subscription automatically renews unless auto-renew is turned off at least 24h before the end of the current period. subscriptions may be managed by the user ans auto-renewal may be turned off by goipng to the user's Account setting after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription, where applicable.  Learn more Privacy and Terms of service."
        lblDetail.isUserInteractionEnabled = true
        lblDetail.delegate = self
        lblDetail.text = str
        let nsString = str as NSString
        let range = nsString.range(of: "Learn more Privacy")
        let prefixAttributes = NSTextCheckingResult.linkCheckingResult(range: range, url: URL.init(string: "action:Privacy")!)
        let range2 = nsString.range(of: "Terms of service")
        let prefixAttributes2 = NSTextCheckingResult.linkCheckingResult(range: range2, url: URL.init(string: "action:Terms")!)
        lblDetail.addLink(with: prefixAttributes, attributes: titleAttributes1)
        lblDetail.addLink(with: prefixAttributes2, attributes: titleAttributes1)
        lblDetail.activeLinkAttributes = nil
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == "action:Privacy" {
            let termVC = storyboard!.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            termVC.filename = "policy"
            termVC.typeView = 2;
            let navController = UINavigationController(rootViewController: termVC)
            
            present(navController, animated: true, completion: nil)
        } else {
            let termVC = storyboard!.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            termVC.filename = "TermsofUse"
            termVC.typeView = 2;
            let navController = UINavigationController(rootViewController: termVC)
            
            present(navController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickToBuy(_ sender: Any) {
        self.purchase(.autoRenewableWeekly, atomically: true)
    }
    
    @IBAction func clickToRestore(_ sender: Any) {
//        UIApplication.shared.openURL(URL.init(string: "https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions")!)
        self.restorePurchases()
    }
    
    @IBAction func clickExit(_ sender: Any) {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame.origin.y = self.view.frame.size.height + 1
            }, completion: {_ in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            })
        
    }
    
    func purchase(_ purchase: RegisteredPurchase, atomically: Bool) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.purchaseProduct(Constants.productIDAutoRenew, atomically: atomically) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(let purchase) = result {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
        }
    }
    
    func getInfo(_ purchase: RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([Constants.productIDAutoRenew]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(self.alertForProductRetrievalInfo(result))
        }
    }
    
    @IBAction func restorePurchases() {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for purchase in results.restoredPurchases {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                } else if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            self.showAlert(self.alertForRestorePurchases(results))
        }
    }
    
    @IBAction func verifyReceipt() {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            self.showAlert(self.alertForVerifyReceipt(result))
        }
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "your-shared-secret")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    func verifyPurchase(_ purchase: RegisteredPurchase) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                
                let productId = Constants.productIDAutoRenew
                
                switch purchase {
                case .autoRenewableWeekly, .autoRenewableMonthly, .autoRenewableYearly:
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .autoRenewable,
                        productId: productId,
                        inReceipt: receipt)
                    self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: [productId]))
                case .nonRenewingPurchase:
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .nonRenewing(validDuration: 60),
                        productId: productId,
                        inReceipt: receipt)
                    self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: [productId]))
                default:
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(
                        productId: productId,
                        inReceipt: receipt)
                    self.showAlert(self.alertForVerifyPurchase(purchaseResult, productId: productId))
                }
                
            case .error:
                self.showAlert(self.alertForVerifyReceipt(result))
            }
        }
    }
    
    func verifySubscriptions(_ purchases: Set<RegisteredPurchase>) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                let productIds = Set(purchases.map { _ in Constants.productIDAutoRenew })
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: productIds))
            case .error:
                self.showAlert(self.alertForVerifyReceipt(result))
            }
        }
    }

}

// MARK: User facing alerts
extension InAppViewController {
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func alertForProductRetrievalInfo(_ result: RetrieveResults) -> UIAlertController {
        
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        } else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            return alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            UserDefaults.standard.set(true, forKey: Constants.InAppPurchaseComplete)
            self.dismiss(animated: true, completion: nil)
            return nil
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            }
        }
    }
    
    func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {
        
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            UserDefaults.standard.set(false, forKey: Constants.InAppPurchaseComplete)
            return alertWithTitle("Purchases Restored", message: "All purchases have been restored")
        } else {
            print("Nothing to Restore")
            return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }
    
    func alertForVerifyReceipt(_ result: VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case .success(let receipt):
            print("Verify receipt Success: \(receipt)")
            return alertWithTitle("Receipt verified", message: "Receipt verified remotely")
        case .error(let error):
            print("Verify receipt Failed: \(error)")
            switch error {
            case .noReceiptData:
                return alertWithTitle("Receipt verification", message: "No receipt data. Try again.")
            case .networkError(let error):
                return alertWithTitle("Receipt verification", message: "Network error while verifying receipt: \(error)")
            default:
                return alertWithTitle("Receipt verification", message: "Receipt verification failed: \(error)")
            }
        }
    }
    
    func alertForVerifySubscriptions(_ result: VerifySubscriptionResult, productIds: Set<String>) -> UIAlertController {
        
        switch result {
        case .purchased(let expiryDate, let items):
            print("\(productIds) is valid until \(expiryDate)\n\(items)\n")
            return alertWithTitle("Product is purchased", message: "Product is valid until \(expiryDate)")
        case .expired(let expiryDate, let items):
            print("\(productIds) is expired since \(expiryDate)\n\(items)\n")
            return alertWithTitle("Product expired", message: "Product is expired since \(expiryDate)")
        case .notPurchased:
            print("\(productIds) has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
    
    func alertForVerifyPurchase(_ result: VerifyPurchaseResult, productId: String) -> UIAlertController {
        
        switch result {
        case .purchased:
            print("\(productId) is purchased")
            return alertWithTitle("Product is purchased", message: "Product will not expire")
        case .notPurchased:
            print("\(productId) has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
}
