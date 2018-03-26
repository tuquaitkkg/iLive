//
//  ViewController.swift
//  iLive
//
//  Created by DucLT on 3/26/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate : AppDelegate = AppDelegate().sharedInstance()
        appDelegate.showLoading(isShow: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

