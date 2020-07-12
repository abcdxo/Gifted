//
//  VideoPlayerView.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/29/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import AVFoundation

/// A simple `UIView` subclass that is backed by an `AVPlayerLayer` layer.
class VideoPlayerView: UIView {
  var player: AVPlayer? {
    get {
      return playerLayer.player
    }
    set {
      playerLayer.player = newValue
    }
  }
  var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer
  }
  override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
}
