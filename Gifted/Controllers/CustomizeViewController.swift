//
//  CustomizeViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/26/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

import Foundation
import UIKit
import ImageIO
import MobileCoreServices

extension UIImage {
    // create gif
    static func animatedGif(from images: [UIImage]) {
        let fileProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]  as CFDictionary
        let frameProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [(kCGImagePropertyGIFDelayTime as String): 1.0]] as CFDictionary
        
        let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL: URL? = documentsDirectoryURL?.appendingPathComponent("animated.gif")
        
        if let url = fileURL as CFURL? {
            if let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil) {
                CGImageDestinationSetProperties(destination, fileProperties)
                for image in images {
                    if let cgImage = image.cgImage {
                        CGImageDestinationAddImage(destination, cgImage, frameProperties)
                    }
                }
                if !CGImageDestinationFinalize(destination) {
                    print("Failed to finalize the image destination")
                }
                print("Url = \(String(describing: fileURL))")
            }
        }
    }
}


class CustomizeViewController: UIViewController {

    var imagesToMakeGIF: [UIImage]?
    
    
    
    @IBOutlet weak var gif: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let images = imagesToMakeGIF else  { return }
        print("images to make GIF : \(images.count)")
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            guard let images = imagesToMakeGIF else  { return }
        let animatedImage = UIImage.animatedImage(with: images, duration: 1.0)
        
        let imageView = UIImageView(image: animatedImage)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.startAnimating()
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: gif.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: gif.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: gif.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: gif.bottomAnchor)
        ])
        
        self.gif = imageView
        
      
    }
    

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
       print("Stopp")
        gif.stopAnimating()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
