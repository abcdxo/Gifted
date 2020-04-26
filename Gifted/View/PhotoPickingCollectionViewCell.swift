//
//  PhotoPickingCollectionViewCell.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/25/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class PhotoPickingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
     var reuseCount: Int = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        clipsToBounds = true
//        layer.borderColor = UIColor.gray.cgColor
//        layer.borderWidth = 10
//
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        clipsToBounds = true
//        layer.borderColor = UIColor.gray.cgColor
//        layer.borderWidth = 10
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 2
                layer.borderColor = UIColor.red.cgColor
            } else {
                layer.borderWidth = 0
            }
        }
    }
    
    
}
