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

class VideoDetailViewController: UIViewController {
    
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
        
    }
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    let videoPreviewView = VideoPlayerView()
    
    lazy var playButton : UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)), for: .normal)
      
        bt.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.tintColor = UIColor.white
        return bt
    }()
    
    var isPlayed = false
    
    @objc func handlePlay() {
        if isPlayed == false {
            playButton.setImage(UIImage(systemName: "pause",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)), for: .normal)
            self.videoPreviewView.player!.play()
            isPlayed.toggle()
            } else {
               playButton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)), for: .normal)
              self.videoPreviewView.player!.pause()
            isPlayed.toggle()
        }
     
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
  
        videoPreviewView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoPreviewView)
        
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
      
         
        if let video = video {
            print(video.duration)
            photoManager.requestPlayerItem(forVideo: video, options: options) { (avPlayerItem, _) in
                self.videoPreviewView.player = AVPlayer(playerItem: avPlayerItem)
             

                
            }
        }
        
        
    }
    
    private func setUpViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .done, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(handleExport))
        navigationItem.title = "Video to GIF"
    }
    
}
