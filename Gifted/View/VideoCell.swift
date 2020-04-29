//
//  VideoCell.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/29/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    let imageRepresentationForVideo: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let durationLabel: UILabel = {
       let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .right
        lb.numberOfLines = 0
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 2
     
        layer.borderWidth = 3
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 2
         
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 3
        layoutViews()
    }
    
    
    
    
    private func layoutViews() {
        addSubview(imageRepresentationForVideo)
        addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            imageRepresentationForVideo.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageRepresentationForVideo.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageRepresentationForVideo.topAnchor.constraint(equalTo: topAnchor),
            imageRepresentationForVideo.bottomAnchor.constraint(equalTo: bottomAnchor),
        
            durationLabel.bottomAnchor.constraint(equalTo: imageRepresentationForVideo.bottomAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: imageRepresentationForVideo.leadingAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: imageRepresentationForVideo.trailingAnchor,constant: -4),
            durationLabel.heightAnchor.constraint(equalToConstant: 20)
            
        ])
        
        
    }
    
    
}
