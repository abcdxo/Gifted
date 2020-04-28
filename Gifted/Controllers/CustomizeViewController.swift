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
    
    private let progressView: UIProgressView = {
        let pg = UIProgressView()
        pg.translatesAutoresizingMaskIntoConstraints = false
        pg.progressViewStyle = .default
        pg.tintColor = #colorLiteral(red: 0.3882825077, green: 0.6711806059, blue: 0.5451156497, alpha: 1)
        pg.backgroundColor = .gray
        return pg
    }()
    let options = ["Speed" ,"Boomerang" , "AR","Canvas","Reorder" , "Filters" , "Stickers", "Text", "Tune" ]
               
    
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
    var imagesToMakeGIF: [UIImage]? {
        didSet {
            progress = Progress(totalUnitCount: Int64(imagesToMakeGIF!.count))
            
        }
    }
    
 
  
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
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: gifImageView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: gifImageView.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 10)
        
        ])
      
        
        guard let images = imagesToMakeGIF else  { return }
        print("images to make GIF : \(images.count)")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        startGif()
        
    }
    
    
    private func createGIF(with images: [UIImage], url: URL, loopCount: Int = 0, frameDelay: Double) {
        
        let destinationURL = url
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
    var timer = Timer()
    
    var progress : Progress!
      
    
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
        
   
      
        Timer.scheduledTimer(withTimeInterval: 0.25  , repeats: true) { (timer) in
            
            guard self.progress.isFinished == false else {
                timer.invalidate()
                return
            }
            
            self.progress.completedUnitCount += 1
            let progressFloat = Float(self.progress.fractionCompleted)
                self.progressView.setProgress(progressFloat, animated: true)
                
            }
        
   
    }
    
    @objc func handle() {
//        let v = (gifImageView.image!.duration / Double(imagesToMakeGIF!.count))
        progressView.progress += Float(gifImageView.image!.duration) / Float(imagesToMakeGIF!.count)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem)
    {
    // Save as gif,live photo or video, show activity controller to share to friend
        createGIF(with: imagesToMakeGIF!, url: gifURL, frameDelay: 0.5 )
        
        PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromImage(
            atFileURL: self.gifURL)})
  
    }
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func pauseTapped(_ sender: UIButton) {
       
        if !sender.isSelected {

            gifImageView.image = imagesToMakeGIF!.last
            progressView.progress = 0
            sender.isSelected = true
        } else {
            progress = Progress(totalUnitCount: Int64(imagesToMakeGIF!.count))
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
