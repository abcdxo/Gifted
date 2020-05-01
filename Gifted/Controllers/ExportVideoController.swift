//
//  ExportVideoController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/30/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import MobileCoreServices
import ImageIO


class ExportVideoController: UIViewController
{
    var videoAsset: PHAsset?
    let photoManager = PHImageManager()
    let option : PHVideoRequestOptions = {
       let opt = PHVideoRequestOptions()
        opt.deliveryMode = .fastFormat
        opt.isNetworkAccessAllowed = false
        opt.version =  .current
        
        return opt
    }()
    var image: UIImage?
    
    var frames: [UIImage] = []
    private var generator: AVAssetImageGenerator!
    
    func getAllFrames(from asset: AVAsset) {
        let duration: Float64 = CMTimeGetSeconds(asset.duration)
        self.generator = AVAssetImageGenerator(asset: asset)
        self.generator.appliesPreferredTrackTransform = true
        self.frames = []
        for index: Int in 0 ..< Int(duration) {
            self.getFrame(fromTime: Float64(index))
        }
        self.generator = nil
    }
    
    
    private func getFrame(fromTime:Float64) {
        let time: CMTime = CMTimeMakeWithSeconds(fromTime, preferredTimescale: 600)
        let image: CGImage
        do {
            try image = self.generator.copyCGImage(at: time, actualTime: nil)
        } catch {
            return
        }
        self.frames.append(UIImage(cgImage: image))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    let gifImageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private func createGifImage(with images: [UIImage],duration:Double) -> UIImage? {
        
        let animatedImage = UIImage.animatedImage(with:images, duration: duration ) // Create GIF
        return animatedImage
    }
    let pixelBuffer : CVPixelBuffer! = nil
    
    
    func showAlert() {
        let ac = UIAlertController(title: "GIF saved to Photo Library", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak self] (action) in
            guard let self = self else { return }
            self.createGIF(with: self.frames, url: CustomizeViewController.gifURL, frameDelay: 0.2 ) // not x count
            
            PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromImage(
                atFileURL: CustomizeViewController.self.gifURL)})
        }))
        present(ac, animated: true, completion: nil)
    }
    
    @objc func savePressed() {
        print("saving")
        showAlert()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "GIF Image"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePressed))
        view.addSubview(gifImageView)
        
        NSLayoutConstraint.activate([
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifImageView.topAnchor.constraint(equalTo: view.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        if let video = videoAsset {
            print("Export: \(video.duration)")
            
            photoManager.requestAVAsset(forVideo: video, options: option) { (asset, _, _) in
                self.getAllFrames(from: asset!)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.gifImageView.image = self.createGifImage(with: self.frames, duration: Double(0.2) * Double(self.frames.count))
                }
               
            }
        }
        view.backgroundColor = .white
    }
    
    private func createGIF(with images: [UIImage], url: URL, loopCount: Int = 0, frameDelay: Double)  {
        
        let destinationURL = url
        
        let destinationGIF = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeGIF, images.count, nil)!
        
        // This dictionary controls the delay between frames
        // If you don't specify this, CGImage will apply a default delay
        let properties = [
            (kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): frameDelay]
        ]
        
        
        for image in images {
            // Convert an UIImage to CGImage, fitting within the specified rect
            let cgImage = image.cgImage
            // Add the frame to the GIF image
            CGImageDestinationAddImage(destinationGIF, cgImage!, properties as CFDictionary?)
            
        }
        
        // Write the GIF file to disk
        CGImageDestinationFinalize(destinationGIF)
        
    }
}

