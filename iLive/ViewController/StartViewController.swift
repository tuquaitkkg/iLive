//
//  StartViewController.swift
//  iLive
//
//  Created by DucLT on 5/13/18.
//  Copyright © 2018 DucLT. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var clStart: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clStart.register(UINib.init(nibName: "StartCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellStart")
        pageControl.numberOfPages = 3
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellStart", for: indexPath) as! StartCollectionViewCell
        cell.configCell(indexPath: indexPath)
        cell.actionHandleBlock {
            self.scrollToNextCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        currentPage()
    }
    
    func scrollToNextCell(){
        
        //get cell size
        let cellSize = UIScreen.main.bounds.size;
        
        //get current content Offset of the Collection view
        let contentOffset = clStart.contentOffset;
        
        //scroll to next cell
        self.clStart.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
    }
    
    func currentPage() -> Void {
        var visibleRect = CGRect()
        
        visibleRect.origin = clStart.contentOffset
        visibleRect.size = clStart.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = clStart.indexPathForItem(at: visiblePoint) else { return }
        
        pageControl.currentPage = indexPath.row
        print(indexPath)
    }
}
