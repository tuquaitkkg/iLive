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
    var typeView : NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if filename == "policy" {
            self.title = "Privacy Policy"
        } else {
            self.title = "Terms Of Use"
        }
        if typeView == 2 {
            let doneButton: UIButton = UIButton(type: .custom)
            doneButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            doneButton.setTitle("Done", for: .normal)
            doneButton.frame = CGRect(x: 10, y: 10, width: 40.0, height: 40.0)
            doneButton.addTarget(self, action: #selector(exitView), for: .touchUpInside)
            
            let barButton = UIBarButtonItem(customView: doneButton)
            //assign button to navigationbar
            self.navigationItem.leftBarButtonItem = barButton
        }
        
        showPrivacy()
        // Do any additional setup after loading the view.
    }
    
    @objc func exitView() {
        self.dismiss(animated: true, completion: nil)
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
