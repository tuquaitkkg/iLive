//
//  FeaturedCell.swift
//  LiveWallpaper
//
//  Created by lephannam on 10/7/16.
//  Copyright © 2016 lephannam. All rights reserved.
//

import UIKit

class FeaturedCell: UITableViewCell {

    @IBOutlet weak var featuredImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        featuredImage.layer.cornerRadius = 5.0
        featuredImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
