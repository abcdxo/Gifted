//
//  VideosCollectionViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/28/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

private let reuseIdentifier = "VideoCell"

class VideosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    let option = PHVideoRequestOptions()
    let videoManager = PHImageManager()
    let options = PHFetchOptions()
    var videoAssets: PHFetchResult<PHAsset>?
    let imageOption = PHImageRequestOptions()
    
    
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Pick a Video"
         self.collectionView!.register(VideoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .done, target: self, action: #selector(handleBack))
      
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoAssets = PHAsset.fetchAssets(with: .video, options: options)
        collectionView.reloadData()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return videoAssets!.count
  
    }
  
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = videoAssets?.object(at: indexPath.item)
          let vc = VideoDetailViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.video = selectedAsset
        
        present(nav, animated: true, completion: nil)
        print(selectedAsset!.duration)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
        let videoAsset = videoAssets!.object(at: indexPath.item)
        
        cell.durationLabel.text = timeIntervalFormatter.string(from: videoAsset.duration)
        let size = collectionView.frame.size.width / 5
     
        videoManager.requestImage(for: videoAsset, targetSize: CGSize(width: size, height: size), contentMode: .aspectFill, options: imageOption) { (image, _) in
            cell.imageRepresentationForVideo.image = image
           
        }
     
        // Configure the cell
    
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size.width / 5
        return CGSize(width: size,height: size)
    }
    
    

  
}
