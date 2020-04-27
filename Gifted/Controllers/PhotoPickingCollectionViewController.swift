//
//  PhotoPickingCollectionView.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/25/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

// TODO: - Checkmark picked photos


import UIKit
import Photos // access photos

extension PhotoPickingCollectionViewController
{
//    func updateCache() {
//        let currentFrameCenter = collectionView.bounds.minY
//        let height = collectionView.bounds.height
//        let visibleIndexes = collectionView.indexPathsForVisibleItems.sorted { (a, b) -> Bool in
//            return a.item < b.item
//        }
//        guard abs(currentFrameCenter - lastCacheFrameCenter) >= height/3.0,
//            visibleIndexes.count > 0 else {
//                return
//        }
//        lastCacheFrameCenter = currentFrameCenter
//        
//        let totalItemCount = assetsFetchResults?.count ?? selectedAssets.count
//        let firstItemToCache = max(visibleIndexes[0].item - numOffscreenAssetsToCache / 2, 0)
//        let lastItemToCache = min(visibleIndexes[visibleIndexes.count - 1].item + numOffscreenAssetsToCache / 2, totalItemCount - 1)
//        
//        var indexesToStartCaching: [IndexPath] = []
//        for i in firstItemToCache..<lastItemToCache {
//            let indexPath = IndexPath(item: i, section: 0)
//            if !cachedIndexes.contains(indexPath) {
//                indexesToStartCaching.append(indexPath)
//            }
//        }
//        cachedIndexes += indexesToStartCaching
//        imageManager.startCachingImages(for: assetsAtIndexPaths(indexesToStartCaching), targetSize: cellSize, contentMode: .aspectFill, options: requestOptions)
//        
//        var indexesToStopCaching: [IndexPath] = []
//        cachedIndexes = cachedIndexes.filter({ (indexPath) -> Bool in
//            if indexPath.item < firstItemToCache || indexPath.item > lastItemToCache {
//                indexesToStopCaching.append(indexPath)
//                return false
//            }
//            return true
//        })
//        imageManager.stopCachingImages(for: assetsAtIndexPaths(indexesToStopCaching), targetSize: cellSize, contentMode: .aspectFill, options: requestOptions)
//    }
    
    func assetsAtIndexPaths(_ indexPaths: [IndexPath]) -> [PHAsset]
    {
        return indexPaths.map { (indexPath) -> PHAsset in
            return self.currentAssetAtIndex(indexPath.item)
        }
    }
    
    func resetCache() {
        imageCachingManager.stopCachingImagesForAllAssets()
        cachedIndexes = []
        lastCacheFrameCenter = 0
    }
}
extension PhotoPickingCollectionViewController: PHPhotoLibraryChangeObserver
{
    func photoLibraryDidChange(_ changeInstance: PHChange)
    {
        DispatchQueue.main.async
            {
            if let assetsFetchResults = self.assetsFetchResults,
                let collectionChanges = changeInstance.changeDetails(for: assetsFetchResults)
            {
                self.assetsFetchResults = collectionChanges.fetchResultAfterChanges
                if collectionChanges.hasMoves || !collectionChanges.hasIncrementalChanges
                {
                    self.photoCollectionView.reloadData()
                } else
                {   self.photoCollectionView.performBatchUpdates(
                    {
                        if let removedIndexes = collectionChanges.removedIndexes, removedIndexes.count > 0 {
                            self.photoCollectionView.deleteItems(at: removedIndexes.indexPaths(for: 0))
                        }
                        if let insertedIndexes = collectionChanges.insertedIndexes, insertedIndexes.count > 0 {
                            self.photoCollectionView.insertItems(at: insertedIndexes.indexPaths(for: 0))
                        }
                        if let changedIndexes = collectionChanges.changedIndexes, changedIndexes.count > 0 {
                            self.photoCollectionView.reloadItems(at: changedIndexes.indexPaths(for: 0))
                        }
                    })
                }
            }
        }
    }
    
    
}

extension PhotoPickingCollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    
}

class PhotoPickingCollectionViewController: UIViewController
{
    
   
    @IBOutlet weak var photoCollectionView: UICollectionView!
        {
        didSet {
            photoCollectionView.delegate = self
            photoCollectionView.dataSource = self
            photoCollectionView.backgroundColor = .white
            photoCollectionView.allowsMultipleSelection = true
        }
    }
    
    var assetsFetchResults: PHFetchResult<PHAsset>?
    var selectedAssets : [PHAsset] = []
    private let numOffscreenAssetsToCache = 60
    private let imageCachingManager : PHCachingImageManager = PHCachingImageManager()
    private var cachedIndexes: [IndexPath] = []
    private var lastCacheFrameCenter: CGFloat = 0
    private var cacheQueue = DispatchQueue(label: "cache_queue")
    var photos : PHFetchResult<PHAsset>?
    private var userAlbums: PHFetchResult<PHAssetCollection>?
    private var userFavorites: PHFetchResult<PHAssetCollection>?
    
    private let requestOptions: PHImageRequestOptions = {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = false
        option.deliveryMode = .highQualityFormat
        option.resizeMode = .exact
        option.version = .original
        option.isSynchronous = false
        
        return option
    }()
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    

      let imageManager = PHImageManager.default()
    //MARK:- Life Cycle
    
    @objc func closeScrene(_ notification: Notification)
    {
        containerHeightConstraint.constant = 0
        let visibleCells = photoCollectionView.visibleCells as! [PhotoPickingCollectionViewCell]
        visibleCells.forEach { (cell) in
            cell.isSelected = false
            selectedImages.removeAll()
        }
        
        UIView.animate(withDuration: 0.2)
        {
            self.view.layoutIfNeeded()
            
        }
          photoCollectionView.reloadData()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.grabPhotos()
        containerHeightConstraint.constant = 0
        setUpNavBar()
        NotificationCenter.default.addObserver(self, selector: #selector(closeScrene(_:)), name: NSNotification.Name("Close"), object: nil)
        
    }
 
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
            case 0:
                navigationItem.title = "Select Photos"
            default:
                  self.navigationItem.title = "Select Videos"
                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                    self.view.setNeedsLayout()
                  
                    
                }, completion: nil)
               
        }
    }

    func fetchCollections() {
        if let albums = PHCollectionList.fetchTopLevelUserCollections(with: nil) as? PHFetchResult<PHAssetCollection> {
            userAlbums = albums
        }
        userFavorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
    }
    
    func currentAssetAtIndex(_ index:NSInteger) -> PHAsset {
        if let fetchResult = photos {
            return fetchResult[index]
        } else {
            return selectedAssets[index]
        }
    }
    
    func updateSelectedItems() {
        if let fetchResult = assetsFetchResults {
            for asset in selectedAssets {
                let index = fetchResult.index(of: asset)
                if index != NSNotFound {
                    let indexPath = IndexPath(item: index, section: 0)
                    photoCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                }
            }
        } else {
            for i in 0..<selectedAssets.count {
                let indexPath = IndexPath(item: i, section: 0)
                photoCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }
    }
    
    private func setUpNavBar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Select Photos"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.2470482588, green: 0.239345789, blue: 0.3378213048, alpha: 1)]
        appearance.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.2470482588, green: 0.239345789, blue: 0.3378213048, alpha: 1)]
        appearance.backgroundColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.2470482588, green: 0.239345789, blue: 0.3378213048, alpha: 1)
        view.backgroundColor = .secondarySystemBackground
       

    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    var images: [UIImage] = []
    
  
    func grabPhotos() {
   
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let scale = UIScreen.main.scale
        let numberOfPhotos: CGFloat = 3
        let thumbnailWidth = (photoCollectionView.bounds.width / numberOfPhotos) * scale
        
        if fetchResult.count > 0 {
            for index in 0 ..< fetchResult.count {
                imageManager.requestImage(for: fetchResult.object(at: index) , targetSize: CGSize(width: thumbnailWidth, height: thumbnailWidth), contentMode: .aspectFill, options: requestOptions) { [weak self]
                    image, error in
//                  print(thumbnailWidth)
                    guard let self = self else { return }
                    guard let image = image else { return }
                    self.images.append(image)
                    
                    DispatchQueue.main.async {
                         self.photoCollectionView.reloadData()
                    }
                   
                }
                
            }
        } else {
            print("You got no photos!")
          
        }
     
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
     {
        
        return images.count
    }
    var count =  0
    var selectedImages = [UIImage]()
    
    private func showContainerViewController()
    {
        self.containerHeightConstraint.constant = 140
        UIView.animate(withDuration: 0.2)
        {
            self.view.layoutIfNeeded()
            
        }
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {

        showContainerViewController()
        let image = images[indexPath.row]
        selectedImages.append(image)
        let userInfo = ["Photos":selectedImages]
        NotificationCenter.default.post(name: NSNotification.Name("NewPhoto"), object: nil, userInfo: userInfo)
        print("Selected images is \(selectedImages.count)")
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {

  //FIXME:remove item of arrays when deselect a row
//        selectedImages.firstIndex(of: selectedImages[indexPath.row])
//        selectedImages.remove(at: indexPath.row)
        
        print("Selected images after DESELECT is \(selectedImages.count)")
        if selectedImages.count == 0 {
            self.containerHeightConstraint.constant = 0
            
            UIView.animate(withDuration: 0.2)
            {
                self.view.layoutIfNeeded()
                
            }
        }
      
    }
   

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
     {
        guard let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: Cell.photoPickingCell.rawValue, for: indexPath) as? PhotoPickingCollectionViewCell else { return UICollectionViewCell() }
    
        let image = images[indexPath.item]
         cell.imageView.image = image  
              
        return cell
    
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {

        let width = collectionView.bounds.width / 3

        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets.zero
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    { // horizontal
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    { // vertical
        return 0.0
    }

}
    

