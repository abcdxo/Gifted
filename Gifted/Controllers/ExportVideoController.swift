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
import CoreVideo
import VideoToolbox


class ExportVideoController: UIViewController
{
    var videoAsset: PHAsset?
    let photoManager = PHImageManager()
    let option = PHVideoRequestOptions()
    var image: UIImage?
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    let gifImageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let pixelBuffer : CVPixelBuffer! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
   
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
                let assetIG = AVAssetImageGenerator(asset: asset!)
                assetIG.appliesPreferredTrackTransform = true
                assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
                
                var time = asset?.duration
                time!.value = min(time!.value, 2)
                do {
                    let imageRef = try assetIG.copyCGImage(at: time!, actualTime: nil)
                    self.image =  UIImage(cgImage: imageRef)
                    DispatchQueue.main.async {
                             self.gifImageView.image = self.image
                    }
               
                } catch let err as NSError {
                    print(err)
                    return
                }
            }
        }
      
        
        view.backgroundColor = .white
    }
    
}
//static UIImage *frameImage(CGSize size, CGFloat radians) {
//    UIGraphicsBeginImageContextWithOptions(size, YES, 1); {
//        [[UIColor whiteColor] setFill];
//        UIRectFill(CGRectInfinite);
//        CGContextRef gc = UIGraphicsGetCurrentContext();
//        CGContextTranslateCTM(gc, size.width / 2, size.height / 2);
//        CGContextRotateCTM(gc, radians);
//        CGContextTranslateCTM(gc, size.width / 4, 0);
//        [[UIColor redColor] setFill];
//        CGFloat w = size.width / 10;
//        CGContextFillEllipseInRect(gc, CGRectMake(-w / 2, -w / 2, w, w));
//    }
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}
//
//static void makeAnimatedGif(void) {
//    static NSUInteger kFrameCount = 16;
//
//    NSDictionary *fileProperties = @{
//        (__bridge id)kCGImagePropertyGIFDictionary: @{
//            (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
//        }
//    };
//
//    NSDictionary *frameProperties = @{
//        (__bridge id)kCGImagePropertyGIFDictionary: @{
//            (__bridge id)kCGImagePropertyGIFDelayTime: @0.02f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
//        }
//    };
//
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
//    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
//
//    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
//    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
//
//    for (NSUInteger i = 0; i < kFrameCount; i++) {
//        @autoreleasepool {
//            UIImage *image = frameImage(CGSizeMake(300, 300), M_PI * 2 * i / kFrameCount);
//            CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
//        }
//    }
//
//    if (!CGImageDestinationFinalize(destination)) {
//        NSLog(@"failed to finalize image destination");
//    }
//    CFRelease(destination);
//
//    NSLog(@"url=%@", fileURL);
//}
