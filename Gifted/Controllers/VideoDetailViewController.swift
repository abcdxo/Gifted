//
//  VideoDetailViewController.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/29/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import ImageIO
import MobileCoreServices


//extension UIImage {
//    static func animatedGif(from images: [UIImage]) {
//        let fileProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]  as CFDictionary
//        let frameProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [(kCGImagePropertyGIFDelayTime as String): 1.0]] as CFDictionary
//
//        let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//        let fileURL: URL? = documentsDirectoryURL?.appendingPathComponent("animated.gif")
//
//        if let url = fileURL as CFURL? {
//            if let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil) {
//                CGImageDestinationSetProperties(destination, fileProperties)
//                for image in images {
//                    if let cgImage = image.cgImage {
//                        CGImageDestinationAddImage(destination, cgImage, frameProperties)
//                    }
//                }
//                if !CGImageDestinationFinalize(destination) {
//                    print("Failed to finalize the image destination")
//                }
//                print("Url = \(fileURL)")
//            }
//        }
//    }
//}

class VideoDetailViewController: UIViewController {
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  var video: PHAsset?
  let photoManager = PHImageManager()
  
  let options : PHVideoRequestOptions = {
    let opt = PHVideoRequestOptions()
    opt.deliveryMode = .highQualityFormat
    opt.isNetworkAccessAllowed = true
    opt.version = .original
    return opt
  }()
  @objc func handleExport() {
    print(video!.duration)
    videoPreviewView.player?.pause()
    let exportVC = ExportVideoController()
    navigationController?.pushViewController(exportVC, animated: true)
    exportVC.videoAsset = video
    print("trying to make a gif from video")
  }
  @objc func handleCancel() {
    dismiss(animated: true, completion: nil)
  }
  
  let videoPreviewView = VideoPlayerView()
  
  lazy var playButton : UIButton = {
    let bt = UIButton(type: .system)
    bt.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .light)), for: .normal)
    
    bt.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
    bt.translatesAutoresizingMaskIntoConstraints = false
    bt.tintColor = UIColor.white
    return bt
  }()
  
  var isPlayed = false
  
  
  
  @objc func playerDidFinishPlaying() {
    segmentedControl.selectedSegmentIndex = 2
    self.videoPreviewView.player!.seek(to: .zero)
    self.videoPreviewView.player!.play()
  }
  
  @objc func handlePlay() {
    if isPlayed == false {
      playButton.setImage(UIImage(systemName: "",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)), for: .normal)
      self.videoPreviewView.player!.play()
      
      isPlayed.toggle()
    } else {
      playButton.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .light)), for: .normal)
      self.videoPreviewView.player!.pause()
      isPlayed.toggle()
    }
    
  }
  
  let segmentedControl: UISegmentedControl = {
    let sc = UISegmentedControl(items: ["-3X", "-2X","1X","+2X","+3X"])
    sc.translatesAutoresizingMaskIntoConstraints = false
    sc.selectedSegmentIndex = 2
    sc.backgroundColor = .white
    sc.selectedSegmentTintColor = .lightGray
    sc.addTarget(self, action: #selector(segmentControl), for: .valueChanged)
    return sc
  }()
  
  
  @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
    videoPreviewView.player?.automaticallyWaitsToMinimizeStalling = false
    switch (segmentedControl.selectedSegmentIndex) {
      
      case 0:
        videoPreviewView.player?.setRate(0.5, time: CMTime.invalid, atHostTime: CMTime.invalid)
      case 1:
        videoPreviewView.player?.setRate(0.75, time: CMTime.positiveInfinity, atHostTime: CMTime.negativeInfinity)
      case 2:
        videoPreviewView.player?.setRate(1.0, time: CMTime.positiveInfinity, atHostTime: CMTime.negativeInfinity)
      case 3 :
        videoPreviewView.player?.setRate(1.5, time: CMTime.positiveInfinity, atHostTime: CMTime.negativeInfinity)
      case 4:
        
        videoPreviewView.player?.setRate(2.0, time: CMTime.positiveInfinity, atHostTime: CMTime.negativeInfinity)
      default:
        break
    }
  }
  deinit{
    NotificationCenter.default.removeObserver(self)
  }
  //MARK:- Life Cycle
  
  lazy var  activityIndicator: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView()
    view.startAnimating()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.style = .large
    view.tintColor = .black
    view.backgroundColor = .white
    return view
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpViews()
    
    NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    
    
    videoPreviewView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(videoPreviewView)
    if let video = video {
      print(video.duration)
      
      photoManager.requestPlayerItem(forVideo: video, options: options) { (avPlayerItem, _) in
        
        self.videoPreviewView.player = AVPlayer(playerItem: avPlayerItem)
        self.activityIndicator.stopAnimating()
      }
    }
    NSLayoutConstraint.activate([
      videoPreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      videoPreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      videoPreviewView.topAnchor.constraint(equalTo: view.topAnchor),
      videoPreviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      
    ])
    
    view.addSubview(playButton)
    NSLayoutConstraint.activate([
      playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      playButton.heightAnchor.constraint(equalToConstant: 200),
      playButton.widthAnchor.constraint(equalToConstant: 200)
    ])
    
    
    view.addSubview(segmentedControl)
    
    NSLayoutConstraint.activate([
      segmentedControl.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0),
      segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0),
      segmentedControl.heightAnchor.constraint(equalToConstant: 40)
      
    ])
    view.addSubview(activityIndicator)
    
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    
  }
  
  private func setUpViews() {
    view.backgroundColor = .white
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .done, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(handleExport))
    navigationItem.title = "Video to GIF"
  }
}
