//
//  UIColor.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import Photos

extension IndexSet {
    // Create an array of index paths from an index set
    func indexPaths(for section: Int) -> [IndexPath] {
        let indexPaths = map { (i) -> IndexPath in
            return IndexPath(item: i, section: section)
        }
        return indexPaths
    }
}
extension UIColor {
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
}
extension UIImageView {
    func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
        let options = PHImageRequestOptions()
        options.version = .original
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
            guard let image = image else { return }
            switch contentMode {
                case .aspectFill:
                    self.contentMode = .scaleAspectFill
                case .aspectFit:
                    self.contentMode = .scaleAspectFit
                @unknown default:
                    break
            }
            self.image = image
        }
    }
}
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoPickingCollectionViewCell
//        let image = images[indexPath.item]
//        cell.photoImageView.image = image
//          return cell
////        print(cell)
////        cell.reuseCount = cell.reuseCount + 1
////        let reuseCount = cell.reuseCount
////        let photo = (photos?.firstObject)!
////        print(photo)
////        imageManager.requestImage(for: photo, targetSize: CGSize(width: collectionView.frame.width / 3 - 1, height: collectionView.frame.width / 3 - 1), contentMode: .aspectFill, options: requestOptions) { (image, _) in
////            cell.photoImageView.image = image
////        }
//
////        imageManager2.requestImage(for: (photos?.object(at: indexPath.row))!, targetSize: CGSize(width: collectionView.frame.width / 3 - 1, height: collectionView.frame.width / 3 - 1), contentMode: .aspectFit, options: requestOptions) { (image, _) in
////            print(image?.size)
////            print(self.photos?.object(at: indexPath.row) as Any)
////            cell.photoImageView.image = image
////        }
////        let asset = currentAssetAtIndex(indexPath.item)
////        userAlbums?.object(at: indexPath.row)
////        imageManager.requestImage(for: asset, targetSize: CGSize(width: collectionView.frame.width / 3 - 1, height: collectionView.frame.width / 3 - 1), contentMode: .aspectFill, options: requestOptions) { (image, metadata) in
////            if reuseCount == cell.reuseCount {
////                cell.photoImageView.image = image
////            }
////        }
//
//
//    }
