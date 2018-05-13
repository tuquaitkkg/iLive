//
//  InAppCollectionViewCell.swift
//  iLive
//
//  Created by DucLT on 5/13/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit

class InAppCollectionViewCell: UICollectionViewCell {

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
            let font2 = UIFont(name: "HelveticaNeue", size: 16)  else { return }
        
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
    }

    
    @IBAction func clickToBuy(_ sender: Any) {
        self.buyApp()
    }
    
    @IBAction func clickToRestore(_ sender: Any) {
        self.restoreApp()
    }
    
    @IBAction func clickExit(_ sender: Any) {
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
    
    
}
