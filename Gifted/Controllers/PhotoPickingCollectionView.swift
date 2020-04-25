//
//  PhotoPickingCollectionView.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/25/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import Photos // access photos



extension PhotoPickingCollectionView: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange)  {
        DispatchQueue.main.async {
            if let assetsFetchResults = self.assetsFetchResults,
                let collectionChanges = changeInstance.changeDetails(for: assetsFetchResults) {
                self.assetsFetchResults = collectionChanges.fetchResultAfterChanges
                if collectionChanges.hasMoves || !collectionChanges.hasIncrementalChanges {
                    self.collectionView.reloadData()
                } else {
                    self.collectionView.performBatchUpdates({
                        if let removedIndexes = collectionChanges.removedIndexes, removedIndexes.count > 0 {
                            self.collectionView.deleteItems(at: removedIndexes.indexPaths(for: 0))
                        }
                        if let insertedIndexes = collectionChanges.insertedIndexes, insertedIndexes.count > 0 {
                            self.collectionView.insertItems(at: insertedIndexes.indexPaths(for: 0))
                        }
                        if let changedIndexes = collectionChanges.changedIndexes, changedIndexes.count > 0 {
                            self.collectionView.reloadItems(at: changedIndexes.indexPaths(for: 0))
                        }
                    })
                }
            }
        }
    }
    
    
}

class PhotoPickingCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    
    var assetsFetchResults: PHFetchResult<PHAsset>?
    var selectedAssets : [PHAsset] = []
    private let numOffScreenAssetsToCache = 60
    private let imageManager : PHCachingImageManager = PHCachingImageManager()
    private var cachedIndexes: [IndexPath] = []
    private var lastCacheFrameCenter: CGFloat = 0
    private var cacheQueue = DispatchQueue(label: "cache_queue")
    
    
    let requestOptions: PHImageRequestOptions = {
       let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.resizeMode = .fast
        return option
    }()
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         PHPhotoLibrary.shared().register(self)
        setUpNavBar()

    }
    func currentAssetAtIndex(_ index:NSInteger) -> PHAsset {
        if let fetchResult = assetsFetchResults {
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
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                }
            }
        } else {
            for i in 0..<selectedAssets.count {
                let indexPath = IndexPath(item: i, section: 0)
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }
    }
    
    private func setUpNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Select Photos"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(handleBack))
        collectionView.backgroundColor = .white
    }
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
//    var fetchResult: PHFetchResult<PHAsset> = PHFetchResult()
//
//    func fetchAssets() {
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
//        fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//    }
//
    
//    var imageArray = [UIImage]()
//
//    func grabPhotos() {
//        let imageManager = PHImageManager.default()
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.isSynchronous = true
//        requestOptions.deliveryMode = .fastFormat
//
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//
//         let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//            if fetchResult.count > 0 {
//                for index in 0 ..< fetchResult.count {
//                    imageManager.requestImage(for: fetchResult.object(at: index) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { [weak self]
//                        image, error in
//                        guard let self = self else { return }
//                        guard let image = image else { return }
//                        self.imageArray.append(image)
//
//                    }
//                      self.collectionView.reloadData()
//                }
//            } else {
//                print("You got no photos!")
////                self.collectionView.reloadData()
//            }
//
//
//    }
//
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let fetchResult = assetsFetchResults {
            return fetchResult.count
        } else {
            return selectedAssets.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoPickingCollectionViewCell
        cell.reuseCount = cell.reuseCount + 1
        let reuseCount = cell.reuseCount
        
        let asset = currentAssetAtIndex(indexPath.item)
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: collectionView.frame.width / 3 - 1, height: collectionView.frame.width / 3 - 1), contentMode: .aspectFill, options: requestOptions) { (image, metadata) in
            if reuseCount == cell.reuseCount {
                cell.photoImageView.image = image
            }
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3 - 1
        
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
}
