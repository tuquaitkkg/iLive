//
//  InAppCollectionViewCell.swift
//  iLive
//
//  Created by DucLT on 5/13/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit

class InAppCollectionViewCell: UICollectionViewCell, TTTAttributedLabelDelegate {

    @IBOutlet weak var lblDetail: TTTAttributedLabel!
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
        self.layoutIfNeeded()
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
            self.goToPrivacy()
        } else {
            self.goToTerm()
        }
    }

    
    @IBAction func clickToBuy(_ sender: Any) {
        self.buyApp()
    }
    
    @IBAction func clickToRestore(_ sender: Any) {
        self.restoreApp()
    }
    
    @IBAction func clickExit(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: Constants.firstTime)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setupMainView()
    }
    
    func buyApp(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
    
    func restoreApp(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
    
    func goToPrivacy(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
    
    func goToTerm(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
}
