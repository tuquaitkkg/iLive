//
//  MenuViewController.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/6/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
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
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "CellMenu"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let navigationController = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as! LiveNavigationController
        let liveVC = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        liveVC.titleCategory = categoriesArray[indexPath.row]
        navigationController.viewControllers = [liveVC]
        frostedViewController.contentViewController = navigationController
        frostedViewController.hideMenuViewController()
    }
}
