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



class VideosCollectionViewController: UICollectionViewController {

    
    let option = PHVideoRequestOptions()
    let videoManager = PHImageManager()
    let options = PHFetchOptions()
    var asset: PHFetchResult<PHAsset>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pick Videos"
        
        self.asset = PHAsset.fetchAssets(with: .video, options: options)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.reloadData()
    }

 


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return asset!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let a = asset!.object(at: indexPath.row)
        videoManager.requestAVAsset(forVideo: a, options: option) { (av, am, a) in
            
        }
        // Configure the cell
    
        return cell
    }

  
}
