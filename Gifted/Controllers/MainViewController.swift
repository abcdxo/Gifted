//
//  ViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import Photos
// TODO: Scroll to bottom
// Fix logic deselect row 

class MainViewController: UIViewController
{
// My thinking make me make this app.
    
    @IBOutlet weak var pageView: UIPageControl!
        {
        didSet {
            pageView.numberOfPages = photos.count
            pageView.currentPage = 0
            pageView.pageIndicatorTintColor = .black
        }
    }
    
    @IBOutlet weak var topCollectionView: UICollectionView!
        {
        didSet {
            topCollectionView.delegate = self
            topCollectionView.dataSource = self
        }
    }
    
 
    @IBOutlet weak var bottomCollectionView: UICollectionView!
        {
        didSet {
            bottomCollectionView.delegate = self
            bottomCollectionView.dataSource = self
        }
    }
    
    
    private var menuOptions = ["Photo to GIF",
                               "Video to GIF",
                               "AR","Camera",
                               "GIF Editor",
                               "Timelapse",
                               "Slowmotion",
                               "Live Photo to GIF"]
    
    private let photos = [ UIImage(named: "art"),
                           UIImage(named: "background"),
                           UIImage(named: "smile"),
                           UIImage(named: "rose"),
                           UIImage(named: "selfie"),
                           UIImage(named: "sit")  ]
    
    private var timer = Timer()
    private var counter = 0
    private var minimumSpacing: CGFloat = 5
    var selectedAssets: [PHAsset] = []
    
    let AssetCollectionCellReuseIdentifier = "AssetCollectionCell"
    private let sectionNames = ["", "", "Albums"]
    private var userAlbums: PHFetchResult<PHAssetCollection>?
    private var userFavorites: PHFetchResult<PHAssetCollection>?
    //MARK:- Outlets
    func fetchCollections() {
        if let albums = PHCollectionList.fetchTopLevelUserCollections(with: nil) as? PHFetchResult<PHAssetCollection>
        {
            userAlbums = albums
        }
        userFavorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
    }
    
    private func goToSettingToTurnPrivacyOn() {
    
            let ac = UIAlertController(title: "Your Photo privacy is off", message: "Please go to Settings and turn on photo privacy so I can make a gif for you", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Turn on", style: .default, handler: self.turnOn(action:)))
            ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: askAgain(action:)))
            self.present(ac, animated: true, completion: nil)
        
       
    }
    @objc func askAgain(action: UIAlertAction) {
        PHPhotoLibrary.requestAuthorization { (ac) in
            print(ac)
        }
    }
 
    
    @objc func turnOn(action: UIAlertAction) {
        if let url = NSURL(string: UIApplication.openSettingsURLString) as URL? {
         
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
                case .authorized :
                print("Granted")
                case .denied:
                    DispatchQueue.main.async {
                        self.goToSettingToTurnPrivacyOn()
                    }
                 
                default:
                break
            }
        }
        navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeImage() {
        // automate page view
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case bottomCollectionView:
                return menuOptions.count
            default: // top collection view
                return photos.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case bottomCollectionView:
                let menu = menuOptions[indexPath.row]
                let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.menuCell.rawValue , for: indexPath) as! BottomCollectionViewCell
                cell.menuLabel.text = menu
                switch indexPath.row {
                    case 0: // photo
                        cell.menuImage.image = UIImage(systemName: "photo")
                    case 1: // video
                        cell.menuImage.image = UIImage(systemName: "video")
                    case 2: // AR
                        cell.menuImage.image = UIImage(systemName: "square.stack.3d.up")
                    case 3: // Camera
                        cell.menuImage.image = UIImage(systemName: "camera")
                    case 4: // Gif edit
                        cell.menuImage.image = UIImage(systemName: "scissors")
                    case 5: // timelapse
                        cell.menuImage.image = UIImage(systemName: "timer")
                    case 6: // slowmotion
                        cell.menuImage.image = UIImage(systemName: "slowmo")
                    case 7: // livephoto
                        cell.menuImage.image = UIImage(systemName: "livephoto")
                    default:
                        
                        break
                }
                return cell
            default: // top collection view
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.topCell.rawValue, for: indexPath) as! TopCollectionViewCell
                if let onboardingView = cell.viewWithTag(111) as? UIImageView {
                    onboardingView.image = photos[indexPath.row]
                } else if let pageView = cell.viewWithTag(222) as? UIPageControl {
                    pageView.currentPage = indexPath.row
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
                return CGSize(width: width, height: width / 2)
            default:
                let size = topCollectionView.frame.size
                
                return CGSize(width: size.width, height: size.height )
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
        print(indexPath.row)
        switch indexPath.row {
            
            case 0:
                if  let vc = ( storyboard?.instantiateViewController(identifier: "PhotoSelection")) {
                    vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: true, completion: nil)  }
        
            case 1:
                if  let vc = ( storyboard?.instantiateViewController(identifier: "Videos")) {
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    present(nav, animated: true, completion: nil)
                    
            }
            default: break

            
        }
    }
}
extension MainViewController: PHPhotoLibraryChangeObserver
{
    
    func photoLibraryDidChange(_ changeInstance: PHChange)
    {
        DispatchQueue.main.async
            {
                var updatedFetchResults = false
                if let userAlbums = self.userAlbums,
                    let changes = changeInstance.changeDetails(for: userAlbums)
                {
                    self.userAlbums = changes.fetchResultAfterChanges
                    updatedFetchResults = true
                }
                if let userFavorites = self.userFavorites,
                    let changes = changeInstance.changeDetails(for: userFavorites)
                {
                    self.userFavorites = changes.fetchResultAfterChanges
                    updatedFetchResults = true
                }
                if updatedFetchResults
                {
                    self.bottomCollectionView.reloadData()
                }
        }
    }
}
