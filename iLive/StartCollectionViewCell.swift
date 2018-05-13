//
//  StartCollectionViewCell.swift
//  iLive
//
//  Created by DucLT on 5/13/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class StartCollectionViewCell: UICollectionViewCell, PHLivePhotoViewDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var liveView: PHLivePhotoView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        liveView.delegate = self
        liveView.isMuted = true
        liveView.bringSubview(toFront: lblTitle)
        liveView.bringSubview(toFront: btnNext)
    }
    
    func configCell(indexPath : IndexPath) -> Void {
        if indexPath.row == 0 {
            lblTitle.text = "THE LARGEST COLLECTION\nOF LIVE WALLPAPERS"
        } else {
            lblTitle.text = "BRING YOUR iPHONE\n TO LIFE"
        }
        
        let stringImage = String(format: "Start_Image_%i.jpg", indexPath.row + 1)
        let stringVideo = String(format: "Start_Video_%i.mov", indexPath.row + 1)
        if let filePath = Bundle.main.path(forResource: stringImage, ofType: nil), let fileVideo = Bundle.main.path(forResource: stringVideo, ofType: nil){
            let image = UIImage.init(named: stringImage)
            
            PHLivePhoto.request(withResourceFileURLs: [URL.init(fileURLWithPath: filePath),URL.init(fileURLWithPath: fileVideo)], placeholderImage: nil, targetSize: (image?.size)!, contentMode: .default, resultHandler: { (livePhoto, info) in
                DispatchQueue.main.async {
                    
                    // ...Run something once we're done with the background task...
                    self.liveView.livePhoto = livePhoto
                    self.liveView.startPlayback(with: .full)
                }
            })
        }
    }

    @IBAction func clickToButton(_ sender: Any) {
        self.actionHandleBlock()
    }
    
    public func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        self.liveView.startPlayback(with: .full)
    }
    
    func actionHandleBlock(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
}
