//
//  FilterManager.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/26/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

enum FilterType: Int {
    case comic
    case sepia
    case halftone
    case crystallize
    case vignette
    case noir
    
}

class FilterManager {
    
    let originalImage: UIImage
    
    let context = CIContext(options: nil)
    
    let filterNames = [
        "CIComicEffect",
        "CISepiaTone",
        "CICMYKHalftone",
        "CICrystallize",
        "CIVignette",
        "CIPhotoEffectNoir"
    ]
    
    init(image: UIImage) {
        self.originalImage = image
    }
    
    func applyFilter(type: FilterType) -> UIImage {
        
        guard let ciImage = CIImage(image: originalImage) else { fatalError("Image not found!") }
        guard let filter = CIFilter(name: filterNames[type.rawValue]) else { fatalError("Filter not found!") }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        switch type {
            case .comic:
                break
            case .sepia:
                filter.setValue(1.0, forKey: kCIInputIntensityKey)
            case .halftone:
                filter.setValue(25, forKey: kCIInputWidthKey)
            case .crystallize:
                filter.setValue(25, forKey: kCIInputRadiusKey)
            case .vignette:
                filter.setValue(3, forKey: kCIInputIntensityKey)
                
                filter.setValue(30, forKey: kCIInputRadiusKey)
            case .noir:
                break
        }
        
        guard let filteredImage = filter.value(forKey: kCIOutputImageKey) as? CIImage else { fatalError("FilterImage not found!") }
        guard let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) else { fatalError("CGImage not to create!") }
        
        return UIImage(cgImage: cgImage)
        
    }
    
}
