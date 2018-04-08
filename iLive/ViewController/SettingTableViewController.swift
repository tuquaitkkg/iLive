//
//  SettingTableViewController.swift
//  iLive
//
//  Created by DucLT on 4/8/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit
import MessageUI

class SettingTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Setting"
        
        let doneButton: UIButton = UIButton(type: .custom)
        doneButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        doneButton.setImage(UIImage(named: "ic_back"), for: .normal)
        doneButton.frame = CGRect(x: 10, y: 10, width: 40.0, height: 40.0)
        doneButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: doneButton)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        
        self.tableView.tableFooterView = UIView.init()
        
    }
    
    @objc func closeView() {
        UIApplication.shared.isStatusBarHidden = true
        dismiss(animated: true) {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "cellSetting"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Privacy Policy"
        case 1:
            cell.textLabel?.text = "Terms of Use"
        case 2:
            cell.textLabel?.text = "Restore Puchase"
        case 3:
            cell.textLabel?.text = "Support"
        case 4:
            cell.textLabel?.text = "Share this app"
        default:
            cell.textLabel?.text = ""
        }
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            let termVC = storyboard!.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            self.navigationController?.pushViewController(termVC, animated: true)
        case 1:
            return
        case 2:
            return
        case 3:
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: {
                    UIApplication.shared.statusBarStyle = .lightContent
                })
            } else {
                self.showSendMailErrorAlert()
            }
        case 4:
            let url : URL = URL.init(string: "https://itunes.apple.com/us/app/connect-crewlounge/id1355295696?ls=1&mt=8")!
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            let cell = tableView.cellForRow(at: indexPath)
            activityViewController.popoverPresentationController?.sourceView = cell
            self.present(activityViewController, animated: true, completion: nil)
        default:
            return
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.navigationBar.tintColor = UIColor.white;
        
        mailComposerVC.setToRecipients(["hivonghuongdicuatoi90@gmail.com"])
//        mailComposerVC.setSubject("Sending you an in-app e-mail...")
//        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alertController = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed default");
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
