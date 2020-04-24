//
//  MenuCell.swift
//  Gifted
//
//  Created by Nick Nguyen on 4/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    
    @IBOutlet weak var menuLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
          backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
     
        
    }
   
}
