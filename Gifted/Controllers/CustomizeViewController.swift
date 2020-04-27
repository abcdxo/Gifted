//
//  CustomizeViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/26/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import ARKit
import Photos
import ImageIO
import MobileCoreServices

class CustomizeViewController: UIViewController, ARSessionDelegate
{
    //MARK:- Properties
    
    let options = ["Speed" ,
                   "Boomerang",
                   "AR",
                   "Canvas"  ,
                   "Reorder" ,
                   "Filters" ,
                   "Stickers",
                   "Text",
                   "Tune" ]
    
    let optionImages = [
        UIImage(systemName: "waveform"),
        UIImage(systemName: "lasso"),
        UIImage(systemName: "square.stack.3d.down.right"),
        UIImage(systemName: "aspectratio"),
        UIImage(systemName: "arrow.clockwise.circle"),
        UIImage(systemName: "pencil"),
        UIImage(systemName: "smiley"),
        UIImage(systemName: "textformat.size"),
        UIImage(systemName: "radiowaves.left")
        
    ]
    private var gifURL: URL {
        let documentsURL = FileManager.default.urls( for: .documentDirectory,in: .userDomainMask).first
        let imageURL = documentsURL!.appendingPathComponent("MyImage.gif")
        return imageURL
    }
    var imagesToMakeGIF: [UIImage]?
    
    //MARK:- Outlets
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var optionCollectionView: UICollectionView!  {
        didSet {
            optionCollectionView.delegate = self
            optionCollectionView.dataSource = self
        }
    }
    
    //MARK:- Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let images = imagesToMakeGIF else  { return }
        print("images to make GIF : \(images.count)")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        startGif()
        
    }
    
    
    private func createGIF(with images: [UIImage], name: URL, loopCount: Int = 0, frameDelay: Double) {
        
        let destinationURL = name
        let destinationGIF = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeGIF, images.count, nil)!
        
        // This dictionary controls the delay between frames
        // If you don't specify this, CGImage will apply a default delay
        let properties = [
            (kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): frameDelay]
        ]
        
        
        for img in images {
            // Convert an UIImage to CGImage, fitting within the specified rect
            let cgImage = img.cgImage
            // Add the frame to the GIF image
            CGImageDestinationAddImage(destinationGIF, cgImage!, properties as CFDictionary?)
        }
        
        // Write the GIF file to disk
        CGImageDestinationFinalize(destinationGIF)
    }
  
    
    private func createGifImage(with images: [UIImage]) -> UIImageView {
        let animatedImage = UIImage.animatedImage(with:images, duration: 0.5 * Double(images.count) ) // Create GIF
        
        let imageView = UIImageView(image: animatedImage)
        imageView.animationRepeatCount = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func startGif() {
      
        let imageViewForGif = createGifImage(with: imagesToMakeGIF!)
        
        view.addSubview(imageViewForGif)
        
        NSLayoutConstraint.activate([
            imageViewForGif.leadingAnchor.constraint(equalTo: gifImageView.leadingAnchor),
            imageViewForGif.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor),
            imageViewForGif.topAnchor.constraint(equalTo: gifImageView.topAnchor),
            imageViewForGif.bottomAnchor.constraint(equalTo: gifImageView.bottomAnchor)
        ])
        
        self.gifImageView = imageViewForGif
    }
    
 
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem)
    {
    // Save as gif,live photo or video, show activity controller to share to friend
        createGIF(with: imagesToMakeGIF!, name: gifURL, frameDelay: 0.2 * Double(imagesToMakeGIF!.count))
        
        PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromImage(
            atFileURL: self.gifURL)})
  
    }
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func pauseTapped(_ sender: UIButton) {

        if !sender.isSelected {
            gifImageView.image = imagesToMakeGIF?.last
            sender.isSelected = true
        } else {
            sender.isSelected = false
            startGif()
        }
    
      
    }
    
    
    
    @IBAction func reversePressed(_ sender: UIButton) {
        let reversedImages = Array(imagesToMakeGIF!.reversed())
        let imageViewForGif = createGifImage(with: reversedImages)
        
        view.addSubview(imageViewForGif)
        
        NSLayoutConstraint.activate([
            imageViewForGif.leadingAnchor.constraint(equalTo: gifImageView.leadingAnchor),
            imageViewForGif.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor),
            imageViewForGif.topAnchor.constraint(equalTo: gifImageView.topAnchor),
            imageViewForGif.bottomAnchor.constraint(equalTo: gifImageView.bottomAnchor)
        ])
        
        self.gifImageView = imageViewForGif
    }
    
    
    @IBAction func repeatPressed(_ sender: UIButton) {
        
    }
    
    //MARK:- Actions
    
    
  
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            
            print(error.localizedDescription)
            
        } else {
            
            print("Success")
        }
    }

}
extension CustomizeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.editCell.rawValue, for: indexPath) as! EditOptionCell
        cell.optionLabel.text = options[indexPath.row]
        cell.optionImageView.image = optionImages[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
