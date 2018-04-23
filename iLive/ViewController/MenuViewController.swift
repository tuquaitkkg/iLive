//
//  MenuViewController.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/6/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import UIKit
import MessageUI

class MenuViewController: UITableViewController,MFMailComposeViewControllerDelegate {
    
    var categoriesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        for livePhoto in DataStore.sharedInstance.categoryList {
//            categoriesArray.append(livePhoto.category!)
        }
        
        tableView.separatorColor = UIColor(red: 150.0/255.0, green: 161.0/255.0, blue: 177.0/255.0, alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        let view = UIView(frame: CGRect(x : 0.0, y : 0.0,width: 0.0,height : 100.0))
        let imageView = UIImageView(frame: CGRect(x : 0.0, y : 40.0, width:80.0,height : 80.0))
        imageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        imageView.image = UIImage(named: "icon")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10.0
        imageView.layer.rasterizationScale = UIScreen.main.scale
        imageView.layer.shouldRasterize = true
        imageView.clipsToBounds = true
        
        view.addSubview(imageView)
        tableView.tableHeaderView = view
        tableView.tableFooterView = UIView.init()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        //    cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel!.textColor = UIColor.white
        
        
        if ( UI_USER_INTERFACE_IDIOM() == .pad ) {
            cell.textLabel!.font = UIFont.systemFont(ofSize: 20)
        } else {
            cell.textLabel!.font = UIFont.systemFont(ofSize: 16)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "CellMenu"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "New"
        case 1:
            cell.textLabel?.text = "Favorite"
        case 2:
            cell.textLabel?.text = "Privacy Policy"
        case 3:
            cell.textLabel?.text = "Terms of Use"
        case 4:
            cell.textLabel?.text = "Restore Puchase"
        case 5:
            cell.textLabel?.text = "Support"
        case 6:
            cell.textLabel?.text = "Share this app"
        default:
            cell.textLabel?.text = ""
        }
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let navigationController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as! LiveNavigationController
        switch indexPath.row {
        case 0:
            let liveVC = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
            liveVC.titleCategory = "New"
            navigationController.viewControllers = [liveVC]
            frostedViewController.contentViewController = navigationController
            frostedViewController.hideMenuViewController()
        case 1:
            let liveVC = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
            navigationController.viewControllers = [liveVC]
            liveVC.titleCategory = "Favorite"
            frostedViewController.contentViewController = navigationController
            frostedViewController.hideMenuViewController()
        case 2:
            let termVC = storyboard!.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            navigationController.viewControllers = [termVC]
            frostedViewController.contentViewController = navigationController
            frostedViewController.hideMenuViewController()
        case 3:
            break
        case 4:
            break
        case 5:
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: {
                    UIApplication.shared.statusBarStyle = .lightContent
                    self.frostedViewController.hideMenuViewController()
                })
            } else {
                self.showSendMailErrorAlert()
            }
        case 6:
            let url : URL = URL.init(string: "https://itunes.apple.com/us/app/connect-crewlounge/id1355295696?ls=1&mt=8")!
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            let cell = tableView.cellForRow(at: indexPath)
            activityViewController.popoverPresentationController?.sourceView = cell
            self.present(activityViewController, animated: true, completion: {
                self.frostedViewController.hideMenuViewController()
            })
        default:
            break
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
