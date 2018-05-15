//
//  InAppViewController.swift
//  iLive
//
//  Created by DucLT on 5/13/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit

class InAppViewController: UIViewController {

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
        
        self.view.layoutIfNeeded()
        btnBuy.layer.masksToBounds = true
        btnBuy.layer.cornerRadius = btnBuy.bounds.size.height/2
        
        btnExit.layer.masksToBounds = true
        btnExit.layer.cornerRadius = btnExit.bounds.size.height/2
        btnExit.layer.borderWidth = 2.0
        btnExit.layer.borderColor = UIColor.white.cgColor
        btnExit.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
            guard let strongSelf = self else{ return }
            if type == .purchased {
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    UserDefaults.standard.set(true, forKey: Constants.InAppPurchaseComplete)
                    self?.dismiss(animated: true, completion: nil)
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            } else if type == .restored{
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickToBuy(_ sender: Any) {
        IAPHandler.shared.purchaseMyProduct(index: 0)
    }
    
    @IBAction func clickToRestore(_ sender: Any) {
        IAPHandler.shared.restorePurchase()
    }
    
    @IBAction func clickExit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
