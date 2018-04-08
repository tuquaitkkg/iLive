//
//  RootViewController.swift
//  iLive
//
//  Created by DucLT on 3/26/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit
import REFrostedViewController

class RootViewController: REFrostedViewController {

    override func awakeFromNib() {
        // Do any additional setup after loading the view.
        contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController")
        menuViewController = storyboard?.instantiateViewController(withIdentifier: "menuViewController")
        liveBlurBackgroundStyle = .dark
    }
}

