//
//  LiveNavigationController.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/6/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import UIKit

class LiveNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:))))
    }

    @objc func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        frostedViewController.panGestureRecognized(sender)
    }
    

}
