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
    
    @IBOutlet weak var checkMark: UIImageView!
    
    
    
     var reuseCount: Int = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkMark.image = UIImage(systemName: "checkmark")?.withTintColor(.green)
            } else {
                checkMark.image = UIImage(systemName: "")
            }
        }
    }
    
    
}
