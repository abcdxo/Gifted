//
//  ViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    @IBOutlet weak var pageView: UIPageControl! {
        didSet {
            pageView.numberOfPages = photos.count
            pageView.currentPage = 0
            pageView.pageIndicatorTintColor = .black
        }
    }
    
    
    private var minimumSpacing: CGFloat = 5
    @IBOutlet weak var topCollectionView: UICollectionView! {
        didSet {
            topCollectionView.delegate = self
            topCollectionView.dataSource = self
        }
    }
    
 
    @IBOutlet weak var bottomCollectionView: UICollectionView! {
        didSet {
            bottomCollectionView.delegate = self
            bottomCollectionView.dataSource = self
        }
    }
    var scrollingTimer = Timer()
    
    var menuItem = ["Photo to Gif","Video to Gif","AR","Camera","Gif Editor","Timelapse","Slowmotion","Live Photo to GIF"]
    
    let photos = [ UIImage(named: "background"),
                   UIImage(named: "rose"),
                   UIImage(named: "selfie"),
                   UIImage(named: "smile"),
                   UIImage(named: "sit")  ]
        
    var timer = Timer()
    var counter = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
      
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
       
    }
    
    @objc func changeImage() {
        if counter < photos.count {
            let index = IndexPath(item: counter, section: 0)
            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath(item: counter, section: 0)
            self.topCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    }


}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case bottomCollectionView:
                return menuItem.count
            default: // top collection view
                return photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case bottomCollectionView:
                let menu = menuItem[indexPath.row]
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
                cell.menuLabel.text = menu
                
                return cell
            default: // top collection view
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCollectionViewCell
                if let vc = cell.viewWithTag(111) as? UIImageView {
                    vc.image = photos[indexPath.row]
                } else if let ab = cell.viewWithTag(222) as? UIPageControl {
                    ab.currentPage = indexPath.row
                }
                
                
              
                
               return cell
           
            
        }
      
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case bottomCollectionView:
                let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                var totalUsableWidth = collectionView.frame.width
                let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
                totalUsableWidth -= inset.left + inset.right
                
                let minWidth: CGFloat = 150.0
                let numberOfItemsInOneRow = Int(totalUsableWidth / minWidth)
                totalUsableWidth -= CGFloat(numberOfItemsInOneRow - 1) * flowLayout.minimumInteritemSpacing
                let width = totalUsableWidth / CGFloat(numberOfItemsInOneRow)
                return CGSize(width: width, height: width)
            default:
                let size = topCollectionView.frame.size
               
                return CGSize(width: size.width, height: size.height  )
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
            case topCollectionView:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            default:
             return UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
        }
       
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
            case topCollectionView:
                return 0.0
            default:
              return minimumSpacing
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
            case topCollectionView:
                return 0.0
            default:
                return minimumSpacing
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                print(indexPath.row)
            default:
                print(indexPath.row)
        }
    }
}
