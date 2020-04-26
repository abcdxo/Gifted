//
//  HorizontalBottomCollectionViewCell.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/26/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class HorizontalBottomCollectionViewCell: UICollectionViewCell {
    
      @IBOutlet weak var imageView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(redCancelButton)
        setUpButtons()
        layer.cornerRadius = 8
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(redCancelButton)
        layer.cornerRadius = 8
        setUpButtons()
    }
    
  
    
    
    private func setUpButtons() {
        redCancelButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -2).isActive = true
        redCancelButton.topAnchor.constraint(equalTo:topAnchor,constant: 2).isActive = true
        redCancelButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        redCancelButton.widthAnchor.constraint(equalToConstant: 15).isActive = true

    }
    
    lazy var redCancelButton: UIButton = { // lazy var so I can add Target
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle",withConfiguration: UIImage.SymbolConfiguration( weight: .heavy))!, for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCancel() {
        print("Cancel")
        // delegate
    }
    
}

