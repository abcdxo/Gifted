//
//  ReorderCollectionViewCell.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/28/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class ReorderCollectionViewCell: UICollectionViewCell {
    
    
    var imageView: UIImageView = {
       let m = UIImageView()
        m.translatesAutoresizingMaskIntoConstraints = false
        m.contentMode = .scaleAspectFit
        return m
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutContrainsts()
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth  = 2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layoutContrainsts()
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth  = 2
    }
    
    private func layoutContrainsts() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        ])
    }
}
