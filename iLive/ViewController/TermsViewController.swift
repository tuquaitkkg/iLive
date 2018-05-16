//
//  TermsViewController.swift
//  iLive
//
//  Created by DucLT on 4/8/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit

class TermsViewController: BaseViewController {
    @IBOutlet weak var lblDetail: UILabel!
    var filename : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if filename == "policy" {
            self.title = "Privacy Policy"
        } else {
            self.title = "Terms Of Use"
        }
        
        showPrivacy()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPrivacy() -> Void {
        if let filepath = Bundle.main.path(forResource: filename, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                lblDetail.text = contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
    }

}
