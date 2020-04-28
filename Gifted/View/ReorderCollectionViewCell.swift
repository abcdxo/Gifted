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
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layoutContrainsts()
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
