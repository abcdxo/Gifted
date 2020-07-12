//
//  UIColor.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import Photos
import ImageIO
import MobileCoreServices

extension UIImage {
  static func animatedGif(from images: [UIImage]) {
    let fileProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]  as CFDictionary
    let frameProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [(kCGImagePropertyGIFDelayTime as String): 1.0]] as CFDictionary
    
    let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let fileURL: URL? = documentsDirectoryURL?.appendingPathComponent("animated.gif")
    
    if let url = fileURL as CFURL?
    {
      if let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil)
      {
        CGImageDestinationSetProperties(destination, fileProperties)
        for image in images
        {
          if let cgImage = image.cgImage
          {
            CGImageDestinationAddImage(destination, cgImage, frameProperties)
          }
        }
        if !CGImageDestinationFinalize(destination)
        {
          print("Failed to finalize the image destination")
        }
        print("Url = \(String(describing: fileURL))")
      }
    }
  }
}

extension IndexSet {
  
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
    PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options)
    { image, _ in
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

extension UIImage {
  func resize(targetSize: CGSize) -> UIImage {
    return UIGraphicsImageRenderer(size:targetSize).image { _ in
      self.draw(in: CGRect(origin: .zero, size: targetSize))
    }
  }
  
  func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
