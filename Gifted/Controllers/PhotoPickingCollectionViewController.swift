//
//  PhotoPickingCollectionView.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/25/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

// TODO: - Checkmark picked photos

import UIKit
import Photos

class PhotoPickingCollectionViewController: UIViewController {
  //MARK:- Outlets
  
  
  @IBOutlet weak var photoCollectionView: UICollectionView! {
    didSet {
      photoCollectionView.delegate = self
      photoCollectionView.dataSource = self
      photoCollectionView.backgroundColor = .white
      photoCollectionView.allowsMultipleSelection = true
    }
  }
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
  
  //MARK:- Properties
  
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
  var count =  0
  static var selectedImages = [UIImage]()
  var images: [UIImage] = []
  let imageManager = PHImageManager.default()
  
  private let requestOptions: PHImageRequestOptions = {
    let option = PHImageRequestOptions()
    option.isNetworkAccessAllowed = false
    option.deliveryMode = .highQualityFormat
    option.resizeMode = .exact
    option.version = .original
    option.isSynchronous = false
    
    return option
  }()
  //MARK:- Life Cycle
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(zero(_:)), name: NSNotification.Name("Zero"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(closeContainerView(_:)), name: NSNotification.Name("Close"), object: nil)
    
    containerHeightConstraint.constant = 0
    setUpNavBar()
    grabPhotos()
    
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
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
  
  @objc func closeContainerView(_ notification: Notification) {
    
    let visibleCells = photoCollectionView.visibleCells as! [PhotoPickingCollectionViewCell]
    visibleCells.forEach { (cell) in
      cell.isSelected = false
      PhotoPickingCollectionViewController.selectedImages.removeAll()
      
    }
    
    containerHeightConstraint.constant = 0
    UIView.animate(withDuration: 0.2) {
      self.view.layoutIfNeeded()
    }
    photoCollectionView.reloadData()
  }
  
  deinit  {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func zero(_ notification: Notification) {
    guard let userInfo = notification.userInfo, let indexPath = userInfo["IndexPath"] as? IndexPath else { return }
    
    let cell = photoCollectionView.cellForItem(at: indexPath)
    #warning("FIXME:Logic with IndexPath not sync")
    cell?.isSelected = false
    //        PhotoPickingCollectionViewController.selectedImages.firstIndex(of: position)
    
    if PhotoPickingCollectionViewController.selectedImages.count == 0 {
      
      containerHeightConstraint.constant = 0
      
      UIView.animate(withDuration: 0.2) {
        self.view.layoutIfNeeded()
      }
    }
    
    photoCollectionView.reloadItems(at: [indexPath])
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
  
  private func setUpNavBar() {
    
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
  
  
  private func grabPhotos() {
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.fetchLimit = 60
    
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    self.assetsFetchResults = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    
    
    let scale = UIScreen.main.scale
    let numberOfPhotos: CGFloat = 3
    let thumbnailWidth = (photoCollectionView.bounds.width / numberOfPhotos) * scale
    
    if assetsFetchResults!.count > 0 {
      for index in 0 ..< assetsFetchResults!.count {
        DispatchQueue.global().async {
          self.imageManager.requestImage(for: self.assetsFetchResults!.object(at: index) , targetSize: CGSize(width: thumbnailWidth, height: thumbnailWidth), contentMode: .aspectFill, options: self.requestOptions) { [weak self]
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
      }
    } else {
      print("You got no photos!")
      
    }
    //
  }
  func drawImageOnCanvas(_ useImage: UIImage, canvasSize: CGSize, canvasColor: UIColor ) -> UIImage {
    
    let rect = CGRect(origin: .zero, size: canvasSize)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    
    // fill the entire image
    canvasColor.setFill()
    UIRectFill(rect)
    
    // calculate a Rect the size of the image to draw, centered in the canvas rect
    let centeredImageRect = CGRect(x: (canvasSize.width - useImage.size.width) / 2,
                                   y: (canvasSize.height - useImage.size.height) / 2,
                                   width: useImage.size.width,
                                   height: useImage.size.height)
    
    // get a drawing context
    let context = UIGraphicsGetCurrentContext();
    
    // "cut" a transparent rectanlge in the middle of the "canvas" image
    context?.clear(centeredImageRect)
    
    // draw the image into that rect
    useImage.draw(in: centeredImageRect)
    
    // get the new "image in the center of a canvas image"
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
    
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    //        return assetsFetchResults!.count
    return images.count
  }
  
  
  private func showContainerViewController() {
    self.containerHeightConstraint.constant = 140
    
    UIView.animate(withDuration: 0.2) {
      self.view.layoutIfNeeded()
    }
  }
  
  
  //MARK:- Collection Datasource & Delegate
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    showContainerViewController()
    
    let image = images[indexPath.row]
    PhotoPickingCollectionViewController.selectedImages.append(image)
    let userInfo = ["Photos":PhotoPickingCollectionViewController.selectedImages]
    NotificationCenter.default.post(name: NSNotification.Name("NewPhoto"), object: nil, userInfo: userInfo)
    print("Selected images is \(PhotoPickingCollectionViewController.selectedImages.count)")
    
    
    
  }
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    
    //FIXME:remove item of arrays when deselect a row
    //        selectedImages.firstIndex(of: selectedImages[indexPath.row])
    //        selectedImages.remove(at: indexPath.item)
    //         searches[indexPath.section].searchResults.remove(at: indexPath.row)
    #warning("FIXME:Remove correctly the item in collection view ")
    
    //        PhotoPickingCollectionViewController.selectedImages.remove(at: indexPath.section)
    print("Selected images after DESELECT is \(PhotoPickingCollectionViewController.selectedImages.count)")
    if PhotoPickingCollectionViewController.selectedImages.count == 0 {
      self.containerHeightConstraint.constant = 0
      
      UIView.animate(withDuration: 0.2) {
        self.view.layoutIfNeeded()
      }
    }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.photoPickingCell.rawValue, for: indexPath) as? PhotoPickingCollectionViewCell else { return UICollectionViewCell() }
 
    let image = images[indexPath.row]
    cell.imageView.image = image
 
    
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = collectionView.bounds.width / 3
    
    return CGSize(width: width, height: width)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets.zero
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { // horizontal
    return 0.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { // vertical
    return 0.0
  }
  
}


extension PhotoPickingCollectionViewController {
  func assetsAtIndexPaths(_ indexPaths: [IndexPath]) -> [PHAsset] {
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
  func photoLibraryDidChange(_ changeInstance: PHChange) {
    DispatchQueue.main.async {
      if let assetsFetchResults = self.assetsFetchResults,
         let collectionChanges = changeInstance.changeDetails(for: assetsFetchResults) {
        self.assetsFetchResults = collectionChanges.fetchResultAfterChanges
        if collectionChanges.hasMoves || !collectionChanges.hasIncrementalChanges {
          self.photoCollectionView.reloadData()
        } else {   self.photoCollectionView.performBatchUpdates( {
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
